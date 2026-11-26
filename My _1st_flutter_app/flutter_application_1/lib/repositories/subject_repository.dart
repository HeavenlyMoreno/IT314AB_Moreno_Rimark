import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../models/subject.dart';

/// Only place that runs SQL for subjects.
class SubjectRepository {
  static const _cols =
      'subject_id, subject_code, subject_name, description, units::float8 AS units';

  Future<List<Subject>> getAll() async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('SELECT $_cols FROM subjects ORDER BY subject_code'),
    );
    return result.map((r) => Subject.fromRow(r.toColumnMap())).toList();
  }

  Future<Subject> create(Subject s) async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO subjects (subject_code, subject_name, description, units)
        VALUES (@subject_code, @subject_name, @description,
                CAST(@units AS text)::numeric)
        RETURNING $_cols
      '''),
      parameters: s.toRow(),
    );
    return Subject.fromRow(result.first.toColumnMap());
  }

  Future<Subject> update(Subject s) async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        UPDATE subjects SET
          subject_code = @subject_code, subject_name = @subject_name,
          description = @description, units = CAST(@units AS text)::numeric,
          updated_at = NOW()
        WHERE subject_id = @id
        RETURNING $_cols
      '''),
      parameters: {...s.toRow(), 'id': s.id},
    );
    return Subject.fromRow(result.first.toColumnMap());
  }

  Future<void> delete(int id) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('DELETE FROM subjects WHERE subject_id = @id'),
      parameters: {'id': id},
    );
  }
}
