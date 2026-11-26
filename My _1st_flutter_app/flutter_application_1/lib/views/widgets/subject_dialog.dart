import 'package:flutter/material.dart';

import '../../models/subject.dart';
import 'validators.dart';

/// Add / edit subject. Returns a Subject or null.
class SubjectDialog extends StatefulWidget {
  final Subject? subject;
  const SubjectDialog({super.key, this.subject});

  @override
  State<SubjectDialog> createState() => _SubjectDialogState();
}

class _SubjectDialogState extends State<SubjectDialog> {
  final formKey = GlobalKey<FormState>();
  late final codeC = TextEditingController(text: widget.subject?.code ?? '');
  late final nameC = TextEditingController(text: widget.subject?.name ?? '');
  late final descC = TextEditingController(text: widget.subject?.description ?? '');
  late final unitsC =
      TextEditingController(text: (widget.subject?.units ?? 3.0).toString());

  @override
  void dispose() {
    codeC.dispose();
    nameC.dispose();
    descC.dispose();
    unitsC.dispose();
    super.dispose();
  }

  void save() {
    if (!formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Subject(
        id: widget.subject?.id,
        code: codeC.text.trim().toUpperCase(),
        name: nameC.text.trim(),
        description: descC.text.trim(),
        units: double.parse(unitsC.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.subject != null;
    return AlertDialog(
      title: Text(editing ? 'Edit Subject' : 'Add Subject'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: codeC,
                decoration: const InputDecoration(labelText: 'Subject Code *'),
                validator: (v) => requiredField(v, 'Subject Code'),
              ),
              TextFormField(
                controller: nameC,
                decoration: const InputDecoration(labelText: 'Subject Name *'),
                validator: (v) => requiredField(v, 'Subject Name'),
              ),
              TextFormField(
                controller: descC,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              TextFormField(
                controller: unitsC,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Units (0.5-99.9) *'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Please enter Units';
                  final n = double.tryParse(v.trim());
                  if (n == null || n <= 0 || n > 99.9) {
                    return 'Units must be greater than 0 and at most 99.9';
                  }
                  return null;
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
