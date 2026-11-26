import '../models/schedule.dart';
import '../models/subject.dart';
import '../repositories/schedule_repository.dart';
import '../repositories/subject_repository.dart';
import 'base_viewmodel.dart';

/// Handles subjects and the schedules of the currently selected subject.
class SubjectViewModel extends BaseViewModel {
  final SubjectRepository _subjects;
  final ScheduleRepository _schedules;
  SubjectViewModel(this._subjects, this._schedules);

  List<Subject> subjects = [];
  List<Schedule> schedules = [];
  bool isLoadingSchedules = false;

  // ---- Subjects ----
  Future<void> loadSubjects() => load(() async {
        subjects = await _subjects.getAll();
      });

  Future<bool> addSubject(Subject s) => perform(() async {
        await _subjects.create(s);
        subjects = await _subjects.getAll();
      });

  Future<bool> updateSubject(Subject s) => perform(() async {
        await _subjects.update(s);
        subjects = await _subjects.getAll();
      });

  Future<bool> deleteSubject(Subject s) => perform(() async {
        await _subjects.delete(s.id!);
        subjects.removeWhere((x) => x.id == s.id);
      });

  // ---- Schedules ----
  Future<void> loadSchedules(int subjectId) async {
    isLoadingSchedules = true;
    errorMessage = null;
    schedules = [];
    notifyListeners();
    try {
      schedules = await _schedules.getBySubject(subjectId);
    } catch (e) {
      errorMessage = 'Could not load schedules.';
    } finally {
      isLoadingSchedules = false;
      notifyListeners();
    }
  }

  Future<bool> addSchedule(Schedule s) => perform(() async {
        await _schedules.create(s);
        schedules = await _schedules.getBySubject(s.subjectId);
      });

  Future<bool> updateSchedule(Schedule s) => perform(() async {
        await _schedules.update(s);
        schedules = await _schedules.getBySubject(s.subjectId);
      });

  Future<bool> deleteSchedule(Schedule s) => perform(() async {
        await _schedules.delete(s.id!);
        schedules.removeWhere((x) => x.id == s.id);
      });
}
