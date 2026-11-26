import 'package:postgres/postgres.dart';

import '../core/app_exception.dart';
import '../core/db_connection.dart';
import '../models/enrollment.dart';

/// Only place that runs SQL for enrollments (including the business rules).
class EnrollmentRepository {
  static const _select = '''
    SELECT e.enrollment_id, e.student_id, e.subject_id, e.schedule_id, e.status,
      sub.subject_code, sub.subject_name,
      sc.day_of_week,
      to_char(sc.start_time, 'HH24:MI') AS start_time,
      to_char(sc.end_time,   'HH24:MI') AS end_time,
      sc.room,
      g.grade_id, g.grade::float8 AS grade, g.remarks
    FROM enrollments e
    JOIN subjects sub ON sub.subject_id = e.subject_id
    LEFT JOIN schedules sc ON sc.schedule_id = e.schedule_id
    LEFT JOIN grades g ON g.enrollment_id = e.enrollment_id
  ''';

  Future<List<Enrollment>> getByStudent(int studentId) async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        $_select
        WHERE e.student_id = @sid
        ORDER BY (e.status = 'Dropped'), sub.subject_code
      '''),
      parameters: {'sid': studentId},
    );
    return result.map((r) => Enrollment.fromRow(r.toColumnMap())).toList();
  }

  /// Workflow steps 3-5: duplicate, remaining slots, schedule conflict.
  /// [excludeEnrollmentId] is used when changing a schedule so the student's
  /// current enrollment is not counted against itself.
  /// Returns the schedule's subject_id.
  Future<int> _validate(
    Session tx, {
    required int studentId,
    required int scheduleId,
    int excludeEnrollmentId = -1,
  }) async {
    // Lock the schedule row so two students cannot take the last slot.
    final sc = await tx.execute(
      Sql.named('''
        SELECT subject_id, day_of_week,
               to_char(start_time, 'HH24:MI') AS start_time,
               to_char(end_time,   'HH24:MI') AS end_time, slots
        FROM schedules WHERE schedule_id = @id FOR UPDATE
      '''),
      parameters: {'id': scheduleId},
    );
    if (sc.isEmpty) throw AppException('That schedule no longer exists.');
    final row = sc.first.toColumnMap();
    final subjectId = row['subject_id'] as int;

    // Duplicate enrollment (a dropped one may be re-enrolled)
    final dup = await tx.execute(
      Sql.named('''
        SELECT 1 FROM enrollments
        WHERE student_id = @sid AND subject_id = @sub
          AND status <> 'Dropped' AND enrollment_id <> @ex
      '''),
      parameters: {'sid': studentId, 'sub': subjectId, 'ex': excludeEnrollmentId},
    );
    if (dup.isNotEmpty) {
      throw AppException('Student is already enrolled in this subject.');
    }

    // Remaining slots
    final taken = await tx.execute(
      Sql.named('''
        SELECT COUNT(*)::int FROM enrollments
        WHERE schedule_id = @id AND status = 'Enrolled' AND enrollment_id <> @ex
      '''),
      parameters: {'id': scheduleId, 'ex': excludeEnrollmentId},
    );
    if ((taken.first.first as int) >= (row['slots'] as int)) {
      throw AppException('No slots left for this schedule.');
    }

    // Schedule conflict with the student's other subjects
    final conflict = await tx.execute(
      Sql.named('''
        SELECT sub.subject_code, sc.day_of_week,
               to_char(sc.start_time, 'HH24:MI') AS start_time,
               to_char(sc.end_time,   'HH24:MI') AS end_time
        FROM enrollments e
        JOIN schedules sc  ON sc.schedule_id = e.schedule_id
        JOIN subjects  sub ON sub.subject_id = e.subject_id
        WHERE e.student_id = @sid AND e.status = 'Enrolled'
          AND e.enrollment_id <> @ex
          AND sc.day_of_week = @day
          AND sc.start_time < CAST(@et AS text)::time
          AND sc.end_time   > CAST(@st AS text)::time
        LIMIT 1
      '''),
      parameters: {
        'sid': studentId,
        'ex': excludeEnrollmentId,
        'day': row['day_of_week'],
        'st': row['start_time'],
        'et': row['end_time'],
      },
    );
    if (conflict.isNotEmpty) {
      final c = conflict.first.toColumnMap();
      throw AppException(
          'Schedule conflict with ${c['subject_code']} (${c['day_of_week']} ${c['start_time']}-${c['end_time']}).');
    }
    return subjectId;
  }

  Future<void> enroll({required int studentId, required int scheduleId}) async {
    final conn = await DbConnection.get();
    await conn.runTx((tx) async {
      final subjectId =
          await _validate(tx, studentId: studentId, scheduleId: scheduleId);

      // The table has UNIQUE(student_id, subject_id), so a previously
      // dropped enrollment is re-activated instead of inserted again.
      final old = await tx.execute(
        Sql.named('''
          SELECT enrollment_id FROM enrollments
          WHERE student_id = @sid AND subject_id = @sub AND status = 'Dropped'
        '''),
        parameters: {'sid': studentId, 'sub': subjectId},
      );
      if (old.isNotEmpty) {
        await tx.execute(
          Sql.named('''
            UPDATE enrollments
            SET status = 'Enrolled', schedule_id = @sch, enrolled_at = NOW()
            WHERE enrollment_id = @id
          '''),
          parameters: {'sch': scheduleId, 'id': old.first.first},
        );
      } else {
        await tx.execute(
          Sql.named('''
            INSERT INTO enrollments (student_id, subject_id, schedule_id, status)
            VALUES (@sid, @sub, @sch, 'Enrolled')
          '''),
          parameters: {'sid': studentId, 'sub': subjectId, 'sch': scheduleId},
        );
      }
    });
  }

  Future<void> changeSchedule({
    required int enrollmentId,
    required int newScheduleId,
  }) async {
    final conn = await DbConnection.get();
    await conn.runTx((tx) async {
      final cur = await tx.execute(
        Sql.named('''
          SELECT student_id, subject_id, status
          FROM enrollments WHERE enrollment_id = @id
        '''),
        parameters: {'id': enrollmentId},
      );
      if (cur.isEmpty) throw AppException('Enrollment not found.');
      final c = cur.first.toColumnMap();
      if (c['status'] != 'Enrolled') {
        throw AppException('Only active enrollments can change schedule.');
      }

      final subjectId = await _validate(
        tx,
        studentId: c['student_id'] as int,
        scheduleId: newScheduleId,
        excludeEnrollmentId: enrollmentId,
      );
      if (subjectId != c['subject_id']) {
        throw AppException('Please choose a schedule of the same subject.');
      }
      await tx.execute(
        Sql.named('''
          UPDATE enrollments SET schedule_id = @sch WHERE enrollment_id = @id
        '''),
        parameters: {'sch': newScheduleId, 'id': enrollmentId},
      );
    });
  }

  /// Drop = status becomes 'Dropped' (the row and any grade are kept).
  Future<void> drop(int enrollmentId) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('''
        UPDATE enrollments SET status = 'Dropped' WHERE enrollment_id = @id
      '''),
      parameters: {'id': enrollmentId},
    );
  }
}
