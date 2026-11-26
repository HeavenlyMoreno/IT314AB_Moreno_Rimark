import '../models/grade.dart';
import '../repositories/grade_repository.dart';
import 'base_viewmodel.dart';

class GradeViewModel extends BaseViewModel {
  final GradeRepository _repo;
  GradeViewModel(this._repo);

  List<Grade> grades = [];

  Future<void> loadForStudent(int studentId) => load(() async {
        grades = await _repo.getByStudent(studentId);
      });

  Future<bool> addGrade(int studentId, Grade g) => perform(() async {
        await _repo.create(g);
        grades = await _repo.getByStudent(studentId);
      });

  Future<bool> updateGrade(int studentId, Grade g) => perform(() async {
        await _repo.update(g);
        grades = await _repo.getByStudent(studentId);
      });

  Future<bool> deleteGrade(Grade g) => perform(() async {
        await _repo.delete(g);
        grades.removeWhere((x) => x.id == g.id);
      });
}
