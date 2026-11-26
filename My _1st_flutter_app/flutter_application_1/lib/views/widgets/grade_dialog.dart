import 'package:flutter/material.dart';

import '../../models/grade.dart';

/// Add / edit a grade for one enrollment. Returns a Grade or null.
/// Remarks must be one of: Passed / Failed / Incomplete (database rule).
class GradeDialog extends StatefulWidget {
  final int enrollmentId;
  final String subjectLabel;
  final Grade? grade;
  const GradeDialog({
    super.key,
    required this.enrollmentId,
    required this.subjectLabel,
    this.grade,
  });

  @override
  State<GradeDialog> createState() => _GradeDialogState();
}

class _GradeDialogState extends State<GradeDialog> {
  final formKey = GlobalKey<FormState>();
  late final gradeC =
      TextEditingController(text: widget.grade?.grade?.toString() ?? '');
  late String remarks = widget.grade?.remarks ?? 'Passed';

  @override
  void dispose() {
    gradeC.dispose();
    super.dispose();
  }

  /// Suggest Passed/Failed while typing (75 and above passes).
  void _suggestRemarks(String text) {
    if (remarks == 'Incomplete') return;
    final n = double.tryParse(text.trim());
    if (n == null) return;
    setState(() => remarks = n >= 75 ? 'Passed' : 'Failed');
  }

  void save() {
    if (!formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Grade(
        id: widget.grade?.id,
        enrollmentId: widget.enrollmentId,
        grade: double.tryParse(gradeC.text.trim()),
        remarks: remarks,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.grade != null;
    return AlertDialog(
      title: Text(editing ? 'Edit Grade' : 'Add Grade'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.subjectLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: gradeC,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Grade (0-100)'),
                onChanged: _suggestRemarks,
                validator: (v) {
                  final text = v?.trim() ?? '';
                  if (text.isEmpty) {
                    return remarks == 'Incomplete'
                        ? null
                        : 'Please enter a grade (or choose Incomplete)';
                  }
                  final n = double.tryParse(text);
                  if (n == null || n < 0 || n > 100) {
                    return 'Grade must be between 0 and 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: remarks,
                decoration: const InputDecoration(labelText: 'Remarks'),
                items: Grade.remarkOptions
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setState(() => remarks = v ?? remarks),
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
