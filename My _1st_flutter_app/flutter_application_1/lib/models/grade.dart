/// Maps the existing `grades` table.
class Grade {
  static const remarkOptions = ['Passed', 'Failed', 'Incomplete'];

  final int? id; // grades.grade_id
  final int enrollmentId;
  final double? grade; // numeric(5,2), 0-100, may be null
  final String remarks; // Passed / Failed / Incomplete
  // Display-only fields filled by joins
  final String subjectCode;
  final String subjectName;

  const Grade({
    this.id,
    required this.enrollmentId,
    this.grade,
    required this.remarks,
    this.subjectCode = '',
    this.subjectName = '',
  });

  bool get passed => remarks == 'Passed';

  factory Grade.fromRow(Map<String, dynamic> r) => Grade(
        id: r['grade_id'] as int,
        enrollmentId: r['enrollment_id'] as int,
        grade: (r['grade'] as num?)?.toDouble(),
        remarks: (r['remarks'] as String?) ?? 'Incomplete',
        subjectCode: (r['subject_code'] as String?) ?? '',
        subjectName: (r['subject_name'] as String?) ?? '',
      );

  /// `grade` is sent as text and cast to numeric in SQL.
  Map<String, dynamic> toRow() => {
        'enrollment_id': enrollmentId,
        'grade': grade?.toString(),
        'remarks': remarks,
      };
}
