import '../models/student.dart';
import '../repositories/student_repository.dart';
import 'base_viewmodel.dart';

class StudentViewModel extends BaseViewModel {
  final StudentRepository _repo;
  StudentViewModel(this._repo);

  List<Student> students = [];

  Future<void> loadStudents() => load(() async {
        students = await _repo.getAll();
      });

  Student? byId(int? id) {
    for (final s in students) {
      if (s.id == id) return s;
    }
    return null;
  }

  bool studentNoExists(String studentNo, {int? exceptId}) {
    final wanted = studentNo.trim().toLowerCase();
    return students.any(
        (s) => s.id != exceptId && s.studentNo.trim().toLowerCase() == wanted);
  }

  bool emailExists(String email, {int? exceptId}) {
    final wanted = email.trim().toLowerCase();
    return students
        .any((s) => s.id != exceptId && s.email.trim().toLowerCase() == wanted);
  }

  void _sort() => students.sort((a, b) =>
      a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));

  Future<bool> addStudent(Student student) => perform(() async {
        students.add(await _repo.create(student));
        _sort();
      });

  Future<bool> updateStudent(Student student) => perform(() async {
        final saved = await _repo.update(student);
        final i = students.indexWhere((s) => s.id == saved.id);
        if (i != -1) students[i] = saved;
        _sort();
      });

  Future<bool> toggleFavorite(Student student) => perform(() async {
        final value = !student.favorite;
        await _repo.setFavorite(student.id!, value);
        final i = students.indexWhere((s) => s.id == student.id);
        if (i != -1) students[i] = student.copyWith(favorite: value);
      });

  Future<bool> deleteStudent(Student student) => perform(() async {
        await _repo.delete(student.id!);
        students.removeWhere((s) => s.id == student.id);
      });
}
