import 'package:postgres/postgres.dart';

/// Business-rule error with a message that is safe to show to the user.
class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

/// Turns any error into a friendly message for the UI.
String friendlyError(Object e) {
  if (e is AppException) return e.message;
  if (e is ServerException) {
    switch (e.code) {
      case '23505':
        switch (e.constraintName) {
          case 'students_student_no_key':
            return 'That Student No. already exists.';
          case 'students_email_key':
            return 'That email is already used by another student.';
          case 'subjects_subject_code_key':
            return 'That Subject Code already exists.';
          case 'uq_student_subject':
            return 'Student is already enrolled in this subject.';
          case 'grades_enrollment_id_key':
            return 'This enrollment already has a grade.';
        }
        return 'That record already exists (duplicate value).';
      case '23503':
        return 'This record is still in use (for example, students are enrolled).';
      case '23514':
        return 'One of the values is not allowed. Please check your input.';
    }
    return 'Database error: ${e.message}';
  }
  return 'Something went wrong: $e';
}
