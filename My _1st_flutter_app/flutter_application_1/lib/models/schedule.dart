/// Maps the existing `schedules` table (+ the added `slots` column).
class Schedule {
  final int? id; // schedules.schedule_id
  final int subjectId;
  final String day; // day_of_week: Mon..Sun
  final String startTime; // HH:MM (24h)
  final String endTime;
  final String room;
  final int slots; // capacity
  final int enrolled; // current 'Enrolled' students (read only)

  const Schedule({
    this.id,
    required this.subjectId,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.room = '',
    required this.slots,
    this.enrolled = 0,
  });

  int get remaining => slots - enrolled;
  bool get isFull => remaining <= 0;
  String get label =>
      '$day $startTime-$endTime${room.isEmpty ? '' : ' • $room'}';

  factory Schedule.fromRow(Map<String, dynamic> r) => Schedule(
        id: r['schedule_id'] as int,
        subjectId: r['subject_id'] as int,
        day: r['day_of_week'] as String,
        startTime: r['start_time'] as String,
        endTime: r['end_time'] as String,
        room: (r['room'] as String?) ?? '',
        slots: r['slots'] as int,
        enrolled: (r['enrolled'] as int?) ?? 0,
      );

  Map<String, dynamic> toRow() => {
        'subject_id': subjectId,
        'day_of_week': day,
        'start_time': startTime,
        'end_time': endTime,
        'room': room.trim(),
        'slots': slots,
      };
}
