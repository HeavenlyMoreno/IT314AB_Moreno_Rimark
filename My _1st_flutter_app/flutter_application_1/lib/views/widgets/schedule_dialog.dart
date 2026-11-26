import 'package:flutter/material.dart';

import '../../models/schedule.dart';
import 'common.dart';
import 'validators.dart';

/// Add / edit schedule (day, time, room, slots). Returns a Schedule or null.
class ScheduleDialog extends StatefulWidget {
  final int subjectId;
  final Schedule? schedule;
  const ScheduleDialog({super.key, required this.subjectId, this.schedule});

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  static const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final formKey = GlobalKey<FormState>();
  late String day = widget.schedule?.day ?? 'Mon';
  late final startC = TextEditingController(text: widget.schedule?.startTime ?? '');
  late final endC = TextEditingController(text: widget.schedule?.endTime ?? '');
  late final roomC = TextEditingController(text: widget.schedule?.room ?? '');
  late final slotsC =
      TextEditingController(text: (widget.schedule?.slots ?? 30).toString());

  @override
  void dispose() {
    startC.dispose();
    endC.dispose();
    roomC.dispose();
    slotsC.dispose();
    super.dispose();
  }

  void save() {
    if (!formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Schedule(
        id: widget.schedule?.id,
        subjectId: widget.subjectId,
        day: day,
        startTime: startC.text,
        endTime: endC.text,
        room: roomC.text.trim(),
        slots: int.parse(slotsC.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.schedule != null;
    return AlertDialog(
      title: Text(editing ? 'Edit Schedule' : 'Add Schedule'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: day,
                decoration: const InputDecoration(
                    labelText: 'Day', border: OutlineInputBorder()),
                items: days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => day = v ?? day),
              ),
              const SizedBox(height: 12),
              TimeField(controller: startC, label: 'Start Time'),
              const SizedBox(height: 12),
              TimeField(
                controller: endC,
                label: 'End Time',
                extraValidator: (v) => (startC.text.isNotEmpty &&
                        v!.compareTo(startC.text) <= 0)
                    ? 'End time must be after start time'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: roomC,
                decoration: const InputDecoration(
                    labelText: 'Room', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: slotsC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Slots (capacity) *',
                    border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Please enter Slots';
                  return optionalInt(v, min: 1, max: 500, label: 'Slots');
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: save, child: const Text('Save')),
      ],
    );
  }
}
