import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/schedule.dart';
import '../models/subject.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'widgets/common.dart';
import 'widgets/schedule_dialog.dart';

/// Subject details + schedule management (day, time, room, slots).
class SubjectDetailsScreen extends StatefulWidget {
  final Subject subject;
  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectViewModel>().loadSchedules(widget.subject.id!);
    });
  }

  Future<void> _add() async {
    final schedule = await showDialog<Schedule>(
      context: context,
      builder: (_) => ScheduleDialog(subjectId: widget.subject.id!),
    );
    if (schedule == null || !mounted) return;
    final vm = context.read<SubjectViewModel>();
    final ok = await vm.addSchedule(schedule);
    if (!mounted) return;
    showSnack(context, ok ? 'Schedule added.' : vm.errorMessage!, error: !ok);
  }

  Future<void> _edit(Schedule s) async {
    final edited = await showDialog<Schedule>(
      context: context,
      builder: (_) => ScheduleDialog(subjectId: widget.subject.id!, schedule: s),
    );
    if (edited == null || !mounted) return;
    final vm = context.read<SubjectViewModel>();
    final ok = await vm.updateSchedule(edited);
    if (!mounted) return;
    showSnack(context, ok ? 'Schedule updated.' : vm.errorMessage!, error: !ok);
  }

  Future<void> _delete(Schedule s) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete schedule?',
      message: 'Delete ${s.label}?',
    );
    if (!ok || !mounted) return;
    final vm = context.read<SubjectViewModel>();
    final done = await vm.deleteSchedule(s);
    if (!mounted) return;
    showSnack(context, done ? 'Schedule deleted.' : vm.errorMessage!,
        error: !done);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SubjectViewModel>();
    final subject = widget.subject;

    Widget schedules;
    if (vm.isLoadingSchedules) {
      schedules = const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    } else if (vm.schedules.isEmpty) {
      schedules = const CenteredMessage(
        icon: Icons.event_busy,
        title: 'No schedules yet',
        subtitle: 'Tap "Add Schedule" to assign a day, time and room.',
      );
    } else {
      schedules = ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: vm.schedules.length,
        itemBuilder: (context, i) {
          final s = vm.schedules[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.schedule, color: Colors.teal),
              title: Text('${s.day}  ${s.startTime} - ${s.endTime}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Room: ${s.room.isEmpty ? '-' : s.room}\nSlots: ${s.enrolled}/${s.slots} (${s.remaining} left)'),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.teal),
                    onPressed: () => _edit(s),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _delete(s),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.code),
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
                title: Text(subject.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal)),
                subtitle: Text(
                    '${subject.units} unit(s)${(subject.description ?? '').isEmpty ? '' : '\n${subject.description}'}'),
              ),
            ),
            SectionTitle(
              'Schedules',
              trailing: ElevatedButton.icon(
                onPressed: _add,
                icon: const Icon(Icons.add),
                label: const Text('Add Schedule'),
              ),
            ),
            schedules,
          ],
        ),
      ),
    );
  }
}
