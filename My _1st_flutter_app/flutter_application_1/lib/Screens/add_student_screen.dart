
import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> existingStudents;

  const AddStudentScreen({
    required this.existingStudents,
  });

  @override
  State<AddStudentScreen> createState() =>
      _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final idController = TextEditingController();
  final courseController = TextEditingController();
  final yearController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final hobbyController = TextEditingController();

  // Check for duplicate Student ID
  String? checkStudentID(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Student ID';
    }

    bool alreadyExists = widget.existingStudents.any((student) {
      String existingID =
      (student['studentId'] ?? student['studentID'] ?? '')
          .toString()
          .trim()
          .toLowerCase();

      return existingID == value.trim().toLowerCase();
    });

    if (alreadyExists) {
      return 'Student ID already exists';
    }

    return null;
  }


  String? checkEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Email Address';
    }

    final emailPattern =
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailPattern.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }


  String? checkYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Year Level';
    }

    int? year = int.tryParse(value.trim());

    if (year == null || year < 1 || year > 4) {
      return 'Year Level must be between 1 and 4';
    }

    return null;
  }


  void saveStudent() {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> newStudent = {
        'name': nameController.text.trim(),
        'studentId': idController.text.trim(),
        'course': courseController.text.trim(),
        'year': int.parse(yearController.text.trim()),
        'age': int.tryParse(ageController.text.trim()) ?? 0,
        'email': emailController.text.trim(),
        'hobby': hobbyController.text.trim(),
        'image': 'assets/daddy.jpg',
        'bday': '',
        'height': 0.0,
        'favoriteSubject': '',
        'active': true,
        'favorite': false,
      };

      Navigator.pop(context, newStudent);
    }
  }

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
                  const Icon(
                    Icons.person_add_alt_1,
                    size: 70,
                    color: Colors.teal,
                  ),

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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter Student Name';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter Course';
                      }
                      return null;
                    },
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
                    validator: checkYear,
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
                      onPressed: saveStudent,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Student'),
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
