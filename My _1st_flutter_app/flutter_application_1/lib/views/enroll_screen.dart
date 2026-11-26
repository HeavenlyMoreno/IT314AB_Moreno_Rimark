import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/schedule.dart';
import '../models/student.dart';
import '../models/subject.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'widgets/common.dart';

/// Enrollment workflow:
/// 1 select student (passed in) -> 2 select subject -> 3 pick schedule
/// (shows remaining slots) -> validations run in the repository
/// -> error shown, or saved + success message.
class EnrollScreen extends StatefulWidget {
  final Student student;
  const EnrollScreen({super.key, required this.student});

  @override
  State<EnrollScreen> createState() => _EnrollScreenState();
}

class _EnrollScreenState extends State<EnrollScreen> {
  Subject? selectedSubject;
  Schedule? selectedSchedule;
  String? error;
  bool saving = false;

  Future<void> _pickSubject(Subject? subject) async {
    setState(() {
      selectedSubject = subject;
      selectedSchedule = null;
      error = null;
    });
    if (subject != null) {
      await context.read<SubjectViewModel>().loadSchedules(subject.id!);
    }
  }

  Future<void> _enroll() async {
    final schedule = selectedSchedule;
    if (selectedSubject == null || schedule == null) {
      setState(() => error = 'Please select a subject and a schedule.');
      return;
    }
    setState(() {
      saving = true;
      error = null;
    });

    final vm = context.read<EnrollmentViewModel>();
    final ok = await vm.enroll(widget.student.id!, schedule.id!);
    if (!mounted) return;

    if (ok) {
      Navigator.pop(context);
      showSnack(context,
          '${widget.student.fullName} enrolled in ${selectedSubject!.code}.');
    } else {
      setState(() {
        saving = false;
        error = vm.errorMessage; // e.g. duplicate, conflict, no slots
      });
      // Refresh so remaining slots are up to date.
      context.read<SubjectViewModel>().loadSchedules(selectedSubject!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjectVm = context.watch<SubjectViewModel>();

    Widget scheduleList;
    if (selectedSubject == null) {
      scheduleList = const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Select a subject to see its schedules.'),
      );
    } else if (subjectVm.isLoadingSchedules) {
      scheduleList = const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    } else if (subjectVm.schedules.isEmpty) {
      scheduleList = const Padding(
        padding: EdgeInsets.all(16),
        child: Text('This subject has no schedules yet. Add one in Subjects.'),
      );
    } else {
      scheduleList = ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subjectVm.schedules.length,
        itemBuilder: (context, i) {
          final s = subjectVm.schedules[i];
          final picked = selectedSchedule?.id == s.id;
          return Card(
            color: picked ? Colors.teal[100] : Colors.white,
            child: ListTile(
              enabled: !s.isFull,
              leading: Icon(
                picked ? Icons.check_circle : Icons.radio_button_unchecked,
                color: Colors.teal,
              ),
              title: Text(s.label),
              subtitle: Text(s.isFull
                  ? 'FULL (0 slots left)'
                  : '${s.remaining} of ${s.slots} slots left'),
              onTap: () => setState(() {
                selectedSchedule = s;
                error = null;
              }),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enroll Student'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.teal[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.teal),
                title: Text(widget.student.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    '${widget.student.studentNo} • ${widget.student.programLabel}'),
              ),
            ),
            const SectionTitle('1. Select a subject'),
            if (subjectVm.subjects.isEmpty)
              const Text('No subjects available. Add subjects first.')
            else
              DropdownButtonFormField<Subject>(
                value: selectedSubject,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                hint: const Text('Choose a subject'),
                items: subjectVm.subjects
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text('${s.code} - ${s.name}',
                              overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: _pickSubject,
              ),
            const SectionTitle('2. Select a schedule'),
            scheduleList,
            if (error != null)
              Card(
                color: Colors.red[50],
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.error, color: Colors.red),
                  title: Text(error!,
                      style: const TextStyle(color: Colors.red)),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saving ? null : _enroll,
                icon: saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.how_to_reg),
                label: Text(saving ? 'Enrolling...' : 'Enroll Student'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
