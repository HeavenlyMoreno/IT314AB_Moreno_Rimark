/// Maps the existing `enrollments` table (+ the added `schedule_id` column).
class Enrollment {
  final int? id; // enrollments.enrollment_id
  final int studentId;
  final int subjectId;
  final int? scheduleId; // null for old rows with no schedule yet
  final String status; // Enrolled / Dropped / Completed
  // Display-only fields filled by joins
  final String subjectCode;
  final String subjectName;
  final String? day;
  final String? startTime;
  final String? endTime;
  final String? room;
  final int? gradeId;
  final double? grade;
  final String? remarks;

  const Enrollment({
    this.id,
    required this.studentId,
    required this.subjectId,
    this.scheduleId,
    this.status = 'Enrolled',
    this.subjectCode = '',
    this.subjectName = '',
    this.day,
    this.startTime,
    this.endTime,
    this.room,
    this.gradeId,
    this.grade,
    this.remarks,
  });

  bool get isDropped => status == 'Dropped';

  String get scheduleLabel {
    if (scheduleId == null || day == null) return 'No schedule assigned';
    final r = (room == null || room!.isEmpty) ? '' : ' • $room';
    return '$day $startTime-$endTime$r';
  }

  factory Enrollment.fromRow(Map<String, dynamic> r) => Enrollment(
        id: r['enrollment_id'] as int,
        studentId: r['student_id'] as int,
        subjectId: r['subject_id'] as int,
        scheduleId: r['schedule_id'] as int?,
        status: r['status'] as String,
        subjectCode: r['subject_code'] as String,
        subjectName: r['subject_name'] as String,
        day: r['day_of_week'] as String?,
        startTime: r['start_time'] as String?,
        endTime: r['end_time'] as String?,
        room: r['room'] as String?,
        gradeId: r['grade_id'] as int?,
        grade: (r['grade'] as num?)?.toDouble(),
        remarks: r['remarks'] as String?,
      );
}
