import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/student.dart';
import '../../viewmodels/student_viewmodel.dart';
import 'validators.dart';

/// "Edit Student" modal (same fields as the original: name, email, hobby,
/// active status). Returns the updated Student, or null if cancelled.
class EditStudentDialog extends StatefulWidget {
  final Student student;
  const EditStudentDialog({super.key, required this.student});

  @override
  State<EditStudentDialog> createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends State<EditStudentDialog> {
  final formKey = GlobalKey<FormState>();
  late final nameController = TextEditingController(text: widget.student.fullName);
  late final emailController = TextEditingController(text: widget.student.email);
  late final hobbyController =
      TextEditingController(text: widget.student.hobby ?? '');
  late bool editedActive = widget.student.active;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    hobbyController.dispose();
    super.dispose();
  }

  String? checkEmail(String? v) {
    final basic = emailValidator(v);
    if (basic != null) return basic;
    if (context
        .read<StudentViewModel>()
        .emailExists(v!, exceptId: widget.student.id)) {
      return 'Email is already used by another student';
    }
    return null;
  }

  void save() {
    if (!formKey.currentState!.validate()) return;
    final names = Student.splitName(nameController.text);
    // Keep the original status (e.g. Graduated) unless the switch was changed.
    final status = editedActive == widget.student.active
        ? widget.student.status
        : (editedActive ? 'Active' : 'Inactive');
    Navigator.pop(
      context,
      Student(
        id: widget.student.id,
        studentNo: widget.student.studentNo,
        firstName: names[0],
        lastName: names[1],
        email: emailController.text.trim(),
        course: widget.student.course,
        year: widget.student.year,
        age: widget.student.age,
        dateOfBirth: widget.student.dateOfBirth,
        height: widget.student.height,
        hobby: hobbyController.text.trim(),
        favoriteSubject: widget.student.favoriteSubject,
        image: widget.student.image,
        status: status,
        favorite: widget.student.favorite,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Student'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Student Name'),
                validator: (v) => requiredField(v, 'Student Name'),
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: checkEmail,
              ),
              TextFormField(
                controller: hobbyController,
                decoration: const InputDecoration(labelText: 'Hobby'),
              ),
              SwitchListTile(
                title: const Text('Active Status'),
                value: editedActive,
                activeColor: Colors.teal,
                onChanged: (value) => setState(() => editedActive = value),
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
