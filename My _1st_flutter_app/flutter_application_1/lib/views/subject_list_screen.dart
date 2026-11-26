import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subject.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'widgets/common.dart';
import 'widgets/subject_dialog.dart';

/// Subject Management: add / view / update / delete subjects.
class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  Future<void> _add(BuildContext context) async {
    final subject = await showDialog<Subject>(
      context: context,
      builder: (_) => const SubjectDialog(),
    );
    if (subject == null || !context.mounted) return;
    final vm = context.read<SubjectViewModel>();
    final ok = await vm.addSubject(subject);
    if (!context.mounted) return;
    showSnack(context, ok ? 'Subject added.' : vm.errorMessage!, error: !ok);
  }

  Future<void> _edit(BuildContext context, Subject s) async {
    final edited = await showDialog<Subject>(
      context: context,
      builder: (_) => SubjectDialog(subject: s),
    );
    if (edited == null || !context.mounted) return;
    final vm = context.read<SubjectViewModel>();
    final ok = await vm.updateSubject(edited);
    if (!context.mounted) return;
    showSnack(context, ok ? 'Subject updated.' : vm.errorMessage!, error: !ok);
  }

  Future<void> _delete(BuildContext context, Subject s) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete subject?',
      message: 'Delete ${s.code} and all of its schedules?',
    );
    if (!ok || !context.mounted) return;
    final vm = context.read<SubjectViewModel>();
    final done = await vm.deleteSubject(s);
    if (!context.mounted) return;
    showSnack(context, done ? '${s.code} deleted.' : vm.errorMessage!,
        error: !done);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SubjectViewModel>();

    Widget body;
    if (vm.isLoading && vm.subjects.isEmpty) {
      body = const LoadingView('Loading subjects...');
    } else if (vm.errorMessage != null && vm.subjects.isEmpty) {
      body = CenteredMessage(
        icon: Icons.error_outline,
        title: 'Could not load subjects',
        subtitle: vm.errorMessage,
        action: ElevatedButton.icon(
          onPressed: vm.loadSubjects,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      );
    } else if (vm.subjects.isEmpty) {
      body = const CenteredMessage(
        icon: Icons.menu_book_outlined,
        title: 'No subjects yet',
        subtitle: 'Tap the button below to add a subject.',
      );
    } else {
      body = RefreshIndicator(
        onRefresh: vm.loadSubjects,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.subjects.length,
          itemBuilder: (context, i) {
            final s = vm.subjects[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.teal),
              ),
              child: ListTile(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/subject-details',
                  arguments: s,
                ),
                title: Text('${s.code} - ${s.name}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal)),
                subtitle: Text('${s.units} unit(s) • tap to view schedules'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.teal),
                      onPressed: () => _edit(context, s),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _delete(context, s),
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
        title: const Text('Subjects'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.teal[50],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _add(context),
        child: const Icon(Icons.add),
      ),
      body: body,
    );
  }
}
