import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../models/student.dart';

/// Only place that runs SQL for students.
class StudentRepository {
  static const _cols = '''
    student_id, student_no, first_name, last_name, email,
    course, year_level, age,
    to_char(date_of_birth, 'YYYY-MM-DD') AS date_of_birth,
    height, hobby, favorite_subject, image, status, favorite
  ''';

  Future<List<Student>> getAll() async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('SELECT $_cols FROM students ORDER BY first_name, last_name'),
    );
    return result.map((r) => Student.fromRow(r.toColumnMap())).toList();
  }

  Future<Student> create(Student s) async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO students
          (student_no, first_name, last_name, email, course, year_level, age,
           date_of_birth, height, hobby, favorite_subject, image, status, favorite)
        VALUES
          (@student_no, @first_name, @last_name, @email, @course, @year_level,
           @age, CAST(@date_of_birth AS text)::date, @height, @hobby,
           @favorite_subject, @image, @status, @favorite)
        RETURNING $_cols
      '''),
      parameters: s.toRow(),
    );
    return Student.fromRow(result.first.toColumnMap());
  }

  Future<Student> update(Student s) async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        UPDATE students SET
          student_no = @student_no, first_name = @first_name,
          last_name = @last_name, email = @email, course = @course,
          year_level = @year_level, age = @age,
          date_of_birth = CAST(@date_of_birth AS text)::date,
          height = @height, hobby = @hobby, favorite_subject = @favorite_subject,
          image = @image, status = @status, favorite = @favorite,
          updated_at = NOW()
        WHERE student_id = @id
        RETURNING $_cols
      '''),
      parameters: {...s.toRow(), 'id': s.id},
    );
    return Student.fromRow(result.first.toColumnMap());
  }

  Future<void> setFavorite(int id, bool value) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('UPDATE students SET favorite = @v WHERE student_id = @id'),
      parameters: {'v': value, 'id': id},
    );
  }

  Future<void> delete(int id) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('DELETE FROM students WHERE student_id = @id'),
      parameters: {'id': id},
    );
  }
}
