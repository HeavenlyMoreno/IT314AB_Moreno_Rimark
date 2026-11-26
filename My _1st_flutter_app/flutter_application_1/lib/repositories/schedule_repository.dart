import 'package:postgres/postgres.dart';

import '../core/app_exception.dart';
import '../core/db_connection.dart';
import '../models/schedule.dart';

/// Only place that runs SQL for schedules.
class ScheduleRepository {
  static const _select = '''
    SELECT sc.schedule_id, sc.subject_id, sc.day_of_week,
      to_char(sc.start_time, 'HH24:MI') AS start_time,
      to_char(sc.end_time,   'HH24:MI') AS end_time,
      sc.room, sc.slots,
      (SELECT COUNT(*) FROM enrollments e
        WHERE e.schedule_id = sc.schedule_id AND e.status = 'Enrolled')::int AS enrolled
    FROM schedules sc
  ''';

  Future<List<Schedule>> getBySubject(int subjectId) async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        $_select
        WHERE sc.subject_id = @sid
        ORDER BY array_position(
          ARRAY['Mon','Tue','Wed','Thu','Fri','Sat','Sun'], sc.day_of_week::text),
          sc.start_time
      '''),
      parameters: {'sid': subjectId},
    );
    return result.map((r) => Schedule.fromRow(r.toColumnMap())).toList();
  }

  Future<void> create(Schedule s) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('''
        INSERT INTO schedules
          (subject_id, day_of_week, start_time, end_time, room, slots)
        VALUES
          (@subject_id, @day_of_week,
           CAST(@start_time AS text)::time, CAST(@end_time AS text)::time,
           NULLIF(@room, ''), @slots)
      '''),
      parameters: s.toRow(),
    );
  }

  Future<void> update(Schedule s) async {
    final conn = await DbConnection.get();
    await conn.runTx((tx) async {
      // Capacity cannot go below the number of students already enrolled.
      final count = await tx.execute(
        Sql.named('''
          SELECT COUNT(*)::int FROM enrollments
          WHERE schedule_id = @id AND status = 'Enrolled'
        '''),
        parameters: {'id': s.id},
      );
      final enrolled = count.first.first as int;
      if (s.slots < enrolled) {
        throw AppException(
            'Slots cannot be less than the $enrolled student(s) already enrolled.');
      }

      // New time must not clash with other subjects of enrolled students.
      final clash = await tx.execute(
        Sql.named('''
          SELECT 1
          FROM enrollments e1
          JOIN enrollments e2
            ON e2.student_id = e1.student_id AND e2.enrollment_id <> e1.enrollment_id
          JOIN schedules s2 ON s2.schedule_id = e2.schedule_id
          WHERE e1.schedule_id = @id
            AND e1.status = 'Enrolled' AND e2.status = 'Enrolled'
            AND s2.day_of_week = @day
            AND s2.start_time < CAST(@et AS text)::time
            AND s2.end_time   > CAST(@st AS text)::time
          LIMIT 1
        '''),
        parameters: {'id': s.id, 'day': s.day, 'st': s.startTime, 'et': s.endTime},
      );
      if (clash.isNotEmpty) {
        throw AppException(
            'This new time conflicts with another subject of an enrolled student.');
      }

      await tx.execute(
        Sql.named('''
          UPDATE schedules SET
            day_of_week = @day,
            start_time = CAST(@st AS text)::time,
            end_time = CAST(@et AS text)::time,
            room = NULLIF(@room, ''), slots = @slots, updated_at = NOW()
          WHERE schedule_id = @id
        '''),
        parameters: {
          'id': s.id,
          'day': s.day,
          'st': s.startTime,
          'et': s.endTime,
          'room': s.room.trim(),
          'slots': s.slots,
        },
      );
    });
  }

  Future<void> delete(int id) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('DELETE FROM schedules WHERE schedule_id = @id'),
      parameters: {'id': id},
    );
  }
}
