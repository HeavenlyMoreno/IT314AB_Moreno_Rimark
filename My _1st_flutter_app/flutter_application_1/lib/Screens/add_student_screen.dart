
import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen();

  @override
  State<AddStudentScreen> createState() =>
      _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final courseController = TextEditingController();
  final yearController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final hobbyController = TextEditingController();

  void saveStudent() {
    if (nameController.text.trim().isEmpty ||
        idController.text.trim().isEmpty ||
        courseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter the student name, ID, and course.',
          ),
        ),
      );

      return;
    }

    Map<String, dynamic> newStudent = {
      'name': nameController.text.trim(),
      'studentId': idController.text.trim(),
      'course': courseController.text.trim(),
      'year': int.tryParse(yearController.text) ?? 1,
      'age': int.tryParse(ageController.text) ?? 0,
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

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Student Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'Student ID *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: courseController,
                  decoration: const InputDecoration(
                    labelText: 'Course *',
                    hintText: 'Example: BSIT',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Year Level',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cake),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
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
    );
  }
}
