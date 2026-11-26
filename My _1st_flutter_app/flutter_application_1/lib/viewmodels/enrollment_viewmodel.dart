import '../models/enrollment.dart';
import '../repositories/enrollment_repository.dart';
import 'base_viewmodel.dart';

class EnrollmentViewModel extends BaseViewModel {
  final EnrollmentRepository _repo;
  EnrollmentViewModel(this._repo);

  List<Enrollment> enrollments = [];

  Future<void> loadForStudent(int studentId) => load(() async {
        enrollments = await _repo.getByStudent(studentId);
      });

  Future<bool> enroll(int studentId, int scheduleId) => perform(() async {
        await _repo.enroll(studentId: studentId, scheduleId: scheduleId);
        enrollments = await _repo.getByStudent(studentId);
      });

  Future<bool> changeSchedule(Enrollment e, int newScheduleId) => perform(() async {
        await _repo.changeSchedule(
            enrollmentId: e.id!, newScheduleId: newScheduleId);
        enrollments = await _repo.getByStudent(e.studentId);
      });

  Future<bool> drop(Enrollment e) => perform(() async {
        await _repo.drop(e.id!);
        enrollments = await _repo.getByStudent(e.studentId);
      });
}
