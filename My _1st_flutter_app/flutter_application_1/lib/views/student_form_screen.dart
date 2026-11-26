import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';
import 'widgets/common.dart';
import 'widgets/validators.dart';

/// Add Student form (same look as the original Student Directory).
class StudentFormScreen extends StatefulWidget {
  const StudentFormScreen({super.key});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final formKey = GlobalKey<FormState>();
  bool saving = false;

  final nameController = TextEditingController();
  final idController = TextEditingController();
  final courseController = TextEditingController();
  final yearController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final hobbyController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    courseController.dispose();
    yearController.dispose();
    ageController.dispose();
    emailController.dispose();
    hobbyController.dispose();
    super.dispose();
  }

  String? checkStudentID(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter Student ID';
    if (context.read<StudentViewModel>().studentNoExists(value)) {
      return 'Student ID already exists';
    }
    return null;
  }

  String? checkEmail(String? value) {
    final basic = emailValidator(value);
    if (basic != null) return basic;
    if (context.read<StudentViewModel>().emailExists(value!)) {
      return 'Email is already used by another student';
    }
    return null;
  }

  Future<void> saveStudent() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => saving = true);

    final names = Student.splitName(nameController.text);
    final vm = context.read<StudentViewModel>();
    final ok = await vm.addStudent(
      Student(
        studentNo: idController.text.trim(),
        firstName: names[0],
        lastName: names[1],
        email: emailController.text.trim(),
        course: courseController.text.trim(),
        year: int.parse(yearController.text.trim()),
        age: int.tryParse(ageController.text.trim()),
        hobby: hobbyController.text.trim(),
      ),
    );

    if (!mounted) return;
    setState(() => saving = false);
    if (ok) {
      Navigator.pop(context);
      showSnack(context, 'Student added successfully!');
    } else {
      showSnack(context, vm.errorMessage!, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.teal[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Icon(Icons.person_add_alt_1, size: 70, color: Colors.teal),
                  const SizedBox(height: 20),
                  const Text(
                    'Student Information',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Student Name *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) => requiredField(v, 'Student Name'),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: 'Student ID *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                    ),
                    validator: checkStudentID,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: courseController,
                    decoration: const InputDecoration(
                      labelText: 'Course *',
                      hintText: 'Example: BSIT',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (v) => requiredField(v, 'Course'),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Year Level *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: yearValidator,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.cake),
                    ),
                    validator: (v) => optionalInt(v, label: 'Age'),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: checkEmail,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: hobbyController,
                    decoration: const InputDecoration(
                      labelText: 'Hobby',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.favorite),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: saving ? null : saveStudent,
                      icon: saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(saving ? 'Saving...' : 'Save Student'),
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
          ),
        ),
      ),
    );
  }
}
