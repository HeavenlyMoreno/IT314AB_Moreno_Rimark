import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/enrollment.dart';
import '../models/grade.dart';
import '../models/student.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import '../viewmodels/grade_viewmodel.dart';
import '../viewmodels/student_viewmodel.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'widgets/common.dart';
import 'widgets/edit_student_dialog.dart';
import 'widgets/grade_dialog.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student student;
  const StudentDetailsScreen({super.key, required this.student});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    final id = widget.student.id!;
    final enrollments = context.read<EnrollmentViewModel>();
    final grades = context.read<GradeViewModel>();
    await Future.wait([
      enrollments.loadForStudent(id),
      grades.loadForStudent(id),
    ]);
  }

  // ---------- Student: update / delete ----------
  Future<void> _editStudent(Student student) async {
    final edited = await showDialog<Student>(
      context: context,
      builder: (_) => EditStudentDialog(student: student),
    );
    if (edited == null || !mounted) return;

    final vm = context.read<StudentViewModel>();
    final ok = await vm.updateStudent(edited);
    if (!mounted) return;
    showSnack(context, ok ? 'Student information updated.' : vm.errorMessage!,
        error: !ok);
  }

  Future<void> _deleteStudent(Student student) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete student?',
      message:
          'Delete ${student.fullName}? Their enrollments and grades will also be deleted.',
    );
    if (!ok || !mounted) return;

    final vm = context.read<StudentViewModel>();
    final done = await vm.deleteStudent(student);
    if (!mounted) return;
    if (done) {
      Navigator.pop(context);
      showSnack(context, '${student.fullName} deleted.');
    } else {
      showSnack(context, vm.errorMessage!, error: true);
    }
  }

  // ---------- Enrollment: enroll / change schedule / drop ----------
  Future<void> _openEnroll(Student student) async {
    await Navigator.pushNamed(context, '/enroll', arguments: student);
    if (mounted) _reload();
  }

  Future<void> _changeSchedule(Enrollment e) async {
    final subjects = context.read<SubjectViewModel>();
    await subjects.loadSchedules(e.subjectId);
    if (!mounted) return;

    final newScheduleId = await showDialog<int>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text('Change schedule: ${e.subjectCode}'),
        children: subjects.schedules.isEmpty
            ? const [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No schedules available.'),
                )
              ]
            : subjects.schedules.map((s) {
                final current = s.id == e.scheduleId;
                final disabled = current || s.isFull;
                return ListTile(
                  enabled: !disabled,
                  title: Text(s.label),
                  subtitle: Text(current
                      ? 'Current schedule'
                      : s.isFull
                          ? 'Full'
                          : '${s.remaining} slot(s) left'),
                  onTap: () => Navigator.pop(ctx, s.id),
                );
              }).toList(),
      ),
    );
    if (newScheduleId == null || !mounted) return;

    final vm = context.read<EnrollmentViewModel>();
    final ok = await vm.changeSchedule(e, newScheduleId);
    if (!mounted) return;
    showSnack(context, ok ? 'Schedule changed.' : vm.errorMessage!, error: !ok);
  }

  Future<void> _drop(Enrollment e) async {
    final ok = await confirmDialog(
      context,
      title: 'Drop subject?',
      message:
          'Drop ${e.subjectCode}? The student can enroll again later.',
      confirmText: 'Drop',
    );
    if (!ok || !mounted) return;

    final vm = context.read<EnrollmentViewModel>();
    final done = await vm.drop(e);
    if (!mounted) return;
    if (done) {
      await context.read<GradeViewModel>().loadForStudent(widget.student.id!);
      if (!mounted) return;
      showSnack(context, '${e.subjectCode} dropped.');
    } else {
      showSnack(context, vm.errorMessage!, error: true);
    }
  }

  // ---------- Grades: add / edit / delete ----------
  Future<void> _gradeDialog(Enrollment e, Grade? existing) async {
    final grade = await showDialog<Grade>(
      context: context,
      builder: (_) => GradeDialog(
        enrollmentId: e.id!,
        subjectLabel: '${e.subjectCode} - ${e.subjectName}',
        grade: existing,
      ),
    );
    if (grade == null || !mounted) return;

    final studentId = widget.student.id!;
    final gradeVm = context.read<GradeViewModel>();
    final enrollVm = context.read<EnrollmentViewModel>();
    final ok = existing == null
        ? await gradeVm.addGrade(studentId, grade)
        : await gradeVm.updateGrade(studentId, grade);
    if (ok) await enrollVm.loadForStudent(studentId); // refresh status
    if (!mounted) return;
    showSnack(context, ok ? 'Grade saved.' : gradeVm.errorMessage!, error: !ok);
  }

  Future<void> _deleteGrade(Grade g) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete grade?',
      message: 'Delete the grade for ${g.subjectCode}?',
    );
    if (!ok || !mounted) return;

    final studentId = widget.student.id!;
    final gradeVm = context.read<GradeViewModel>();
    final enrollVm = context.read<EnrollmentViewModel>();
    final done = await gradeVm.deleteGrade(g);
    if (done) await enrollVm.loadForStudent(studentId);
    if (!mounted) return;
    showSnack(context, done ? 'Grade deleted.' : gradeVm.errorMessage!,
        error: !done);
  }

  // ---------- UI helpers ----------
  String _value(dynamic v) =>
      (v == null || v.toString().isEmpty) ? 'Not provided' : v.toString();

  Widget _row(String label, dynamic value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 125,
              child: Text('$label:',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(child: Text(_value(value))),
          ],
        ),
      );

  Color _statusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Dropped':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Widget _enrollmentsSection(Student student) {
    final vm = context.watch<EnrollmentViewModel>();
    final grades = context.watch<GradeViewModel>().grades;

    Widget content;
    if (vm.isLoading && vm.enrollments.isEmpty) {
      content = const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    } else if (vm.enrollments.isEmpty) {
      content = const Padding(
        padding: EdgeInsets.all(8),
        child: Text('Not enrolled in any subject yet.'),
      );
    } else {
      content = ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: vm.enrollments.length,
        itemBuilder: (context, i) {
          final e = vm.enrollments[i];
          Grade? existing;
          for (final g in grades) {
            if (g.enrollmentId == e.id) existing = g;
          }
          return Card(
            elevation: 0,
            color: Colors.teal[50],
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${e.subjectCode} - ${e.subjectName}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${e.scheduleLabel}'
                      '${e.remarks == null ? '' : '\nGrade: ${e.grade ?? '-'} (${e.remarks})'}',
                    ),
                    isThreeLine: e.remarks != null,
                    trailing: Chip(
                      label: Text(e.status,
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: _statusColor(e.status),
                    ),
                  ),
                  if (!e.isDropped)
                    Wrap(
                      spacing: 4,
                      children: [
                        TextButton.icon(
                          onPressed: () => _changeSchedule(e),
                          icon: const Icon(Icons.schedule),
                          label: Text(e.scheduleId == null
                              ? 'Assign Schedule'
                              : 'Change Schedule'),
                        ),
                        TextButton.icon(
                          onPressed: () => _gradeDialog(e, existing),
                          icon: const Icon(Icons.grade),
                          label: Text(existing == null ? 'Add Grade' : 'Edit Grade'),
                        ),
                        TextButton.icon(
                          onPressed: () => _drop(e),
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          label: const Text('Drop',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          'Enrolled Subjects',
          trailing: ElevatedButton.icon(
            onPressed: () => _openEnroll(student),
            icon: const Icon(Icons.add),
            label: const Text('Enroll'),
          ),
        ),
        content,
      ],
    );
  }

  Widget _gradesSection() {
    final gradeVm = context.watch<GradeViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Grades'),
        if (gradeVm.grades.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('No grades yet. Add one from an enrolled subject.'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gradeVm.grades.length,
            itemBuilder: (context, i) {
              final g = gradeVm.grades[i];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: g.passed
                      ? Colors.green
                      : (g.remarks == 'Failed' ? Colors.red : Colors.orange),
                  child: Text(g.grade == null ? '-' : g.grade!.toStringAsFixed(0),
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Text('${g.subjectCode} - ${g.subjectName}'),
                subtitle: Text('${g.grade ?? '-'} • ${g.remarks}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteGrade(g),
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Always show the latest copy from the ViewModel.
    final student =
        context.watch<StudentViewModel>().byId(widget.student.id) ?? widget.student;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.teal[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage(student.image),
                    onBackgroundImageError: (_, __) {},
                    child: const Icon(Icons.person, size: 65, color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    _value(student.fullName),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 30),
                _row('Student ID', student.studentNo),
                _row('Course', student.course),
                _row('Year Level', student.year),
                _row('Age', student.age),
                _row('Birthday', student.birthdayText),
                _row('Height',
                    student.height == null ? null : '${student.height} ft'),
                _row('Hobby', student.hobby),
                _row('Email', student.email),
                _row('Favorite Subject', student.favoriteSubject),
                _row('Status', student.active ? 'Active' : student.status),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _editStudent(student),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Student'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _deleteStudent(student),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete Student'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const Divider(height: 30),
                _enrollmentsSection(student),
                const Divider(height: 30),
                _gradesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
