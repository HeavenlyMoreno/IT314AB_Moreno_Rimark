import 'package:postgres/postgres.dart';

import '../core/app_exception.dart';
import '../core/db_connection.dart';
import '../models/grade.dart';

/// Only place that runs SQL for grades.
class GradeRepository {
  Future<List<Grade>> getByStudent(int studentId) async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        SELECT g.grade_id, g.enrollment_id, g.grade::float8 AS grade, g.remarks,
               sub.subject_code, sub.subject_name
        FROM grades g
        JOIN enrollments e ON e.enrollment_id = g.enrollment_id
        JOIN subjects sub  ON sub.subject_id = e.subject_id
        WHERE e.student_id = @sid
        ORDER BY sub.subject_code
      '''),
      parameters: {'sid': studentId},
    );
    return result.map((r) => Grade.fromRow(r.toColumnMap())).toList();
  }

  Future<void> create(Grade g) async {
    final conn = await DbConnection.get();
    await conn.runTx((tx) async {
      final enr = await tx.execute(
        Sql.named('SELECT status FROM enrollments WHERE enrollment_id = @id'),
        parameters: {'id': g.enrollmentId},
      );
      if (enr.isEmpty) {
        throw AppException('An enrollment must exist before assigning grades.');
      }
      if (enr.first.first == 'Dropped') {
        throw AppException('Cannot grade a dropped subject.');
      }
      final existing = await tx.execute(
        Sql.named('SELECT 1 FROM grades WHERE enrollment_id = @id'),
        parameters: {'id': g.enrollmentId},
      );
      if (existing.isNotEmpty) {
        throw AppException('This enrollment already has a grade. Edit it instead.');
      }
      await tx.execute(
        Sql.named('''
          INSERT INTO grades (enrollment_id, grade, remarks)
          VALUES (@enrollment_id, CAST(@grade AS text)::numeric, @remarks)
        '''),
        parameters: g.toRow(),
      );
      await _syncStatus(tx, g.enrollmentId, g.remarks);
    });
  }

  Future<void> update(Grade g) async {
    final conn = await DbConnection.get();
    await conn.runTx((tx) async {
      await tx.execute(
        Sql.named('''
          UPDATE grades
          SET grade = CAST(@grade AS text)::numeric, remarks = @remarks,
              updated_at = NOW()
          WHERE grade_id = @id
        '''),
        parameters: {
          'grade': g.grade?.toString(),
          'remarks': g.remarks,
          'id': g.id,
        },
      );
      await _syncStatus(tx, g.enrollmentId, g.remarks);
    });
  }

  Future<void> delete(Grade g) async {
    final conn = await DbConnection.get();
    await conn.runTx((tx) async {
      await tx.execute(
        Sql.named('DELETE FROM grades WHERE grade_id = @id'),
        parameters: {'id': g.id},
      );
      await _syncStatus(tx, g.enrollmentId, null);
    });
  }

  /// Passed/Failed grade -> enrollment 'Completed'; otherwise back to 'Enrolled'.
  Future<void> _syncStatus(Session tx, int enrollmentId, String? remarks) async {
    final completed = remarks == 'Passed' || remarks == 'Failed';
    await tx.execute(
      Sql.named('''
        UPDATE enrollments SET status = @status
        WHERE enrollment_id = @id AND status <> 'Dropped'
      '''),
      parameters: {
        'status': completed ? 'Completed' : 'Enrolled',
        'id': enrollmentId,
      },
    );
  }
}
