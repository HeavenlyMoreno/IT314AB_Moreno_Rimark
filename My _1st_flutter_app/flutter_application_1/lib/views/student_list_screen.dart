import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';
import 'widgets/common.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  Future<void> _delete(BuildContext context, Student s) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete student?',
      message:
          'Delete ${s.fullName}? Their enrollments and grades will also be deleted.',
    );
    if (!ok || !context.mounted) return;
    final vm = context.read<StudentViewModel>();
    final done = await vm.deleteStudent(s);
    if (!context.mounted) return;
    showSnack(context, done ? '${s.fullName} deleted.' : vm.errorMessage!,
        error: !done);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudentViewModel>();

    Widget body;
    if (vm.isLoading && vm.students.isEmpty) {
      body = const LoadingView('Loading students...');
    } else if (vm.errorMessage != null && vm.students.isEmpty) {
      body = CenteredMessage(
        icon: Icons.error_outline,
        title: 'Could not load students',
        subtitle: vm.errorMessage,
        action: ElevatedButton.icon(
          onPressed: vm.loadStudents,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      );
    } else if (vm.students.isEmpty) {
      body = const CenteredMessage(
        icon: Icons.people_outline,
        title: 'No students found',
        subtitle: 'Your student directory is empty.',
      );
    } else {
      body = RefreshIndicator(
        onRefresh: vm.loadStudents,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.students.length,
          itemBuilder: (context, index) {
            final student = vm.students[index];
            return Card(
              color: student.favorite ? Colors.amber[50] : Colors.white,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.teal),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/student-details',
                        arguments: student,
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(student.image),
                        onBackgroundImageError: (_, __) {},
                        child: const Icon(Icons.person, color: Colors.white54),
                      ),
                      title: Text(
                        student.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      subtitle: Text(
                        '${student.programLabel}\n'
                        '${student.active ? 'Active' : 'Inactive'}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final ok = await vm.toggleFavorite(student);
                            if (!ok && context.mounted) {
                              showSnack(context, vm.errorMessage!, error: true);
                            }
                          },
                          icon: Icon(student.favorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          label: Text(student.favorite ? 'Favorited' : 'Favorite'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () => _delete(context, student),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                        ),
                      ],
                    ),
                    if (student.favorite)
                      const Text(
                        'FAVORITE STUDENT',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Directory'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.teal[50],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => Navigator.pushNamed(context, '/add-student'),
        child: const Icon(Icons.person_add),
      ),
      body: body,
    );
  }
}
