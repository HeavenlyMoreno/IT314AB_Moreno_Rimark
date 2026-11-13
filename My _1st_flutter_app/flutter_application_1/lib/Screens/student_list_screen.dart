
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen();

  @override
  State<StudentListScreen> createState() =>
      _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool isLoading = true;

  // Name used to identify the saved student records
  static const String storageKey = 'student_records';

  // Original student records
  List<Map<String, dynamic>> students = [
    {
      'name': 'Rimark Rafael Moreno',
      'course': 'BSIT',
      'year': 3,
      'age': 22,
      'hobby': 'Sleeping',
      'image': 'assets/daddy.jpg',
      'bday': 'April 19, 2004',
      'height': 5.2,
      'active': true,
      'studentId': '2024-001',
      'email': 'rimark@gmail.com',
      'favoriteSubject': 'Lunch',
      'favorite': false,
    },
    {
      'name': 'Mannes D. VADING',
      'course': 'BSIT',
      'year': 2,
      'age': 21,
      'hobby': 'Role Play',
      'image': 'assets/mom.jpg',
      'bday': 'May 12, 2004',
      'height': 4.2,
      'active': false,
      'studentId': '2024-002',
      'email': 'mannes@gmail.com',
      'favoriteSubject': 'Web Development',
      'favorite': false,
    },
    {
      'name': 'John Kevin Villacorte',
      'course': 'BSIT',
      'year': 2,
      'age': 20,
      'hobby': 'Painting',
      'image': 'assets/b.jpg',
      'bday': 'October 8, 2006',
      'height': 4.3,
      'active': true,
      'studentId': '2024-003',
      'email': 'johnkevin@gmail.com',
      'favoriteSubject': 'Database',
      'favorite': false,
    },
    {
      'name': 'James Neil',
      'course': 'BSIT',
      'year': 2,
      'age': 22,
      'hobby': 'Guitar',
      'image': 'assets/Lover.jpg',
      'bday': 'February 14, 2004',
      'height': 4.7,
      'active': true,
      'studentId': '2024-004',
      'email': 'jamesneil@gmail.com',
      'favoriteSubject': 'Networking',
      'favorite': false,
    },
    {
      'name': 'Keith Frances',
      'course': 'BSIT',
      'year': 3,
      'age': 23,
      'hobby': 'Joke Purpose',
      'image': 'assets/m1.jpg',
      'bday': 'July 25, 2003',
      'height': 5.4,
      'active': true,
      'studentId': '2024-005',
      'email': 'keith@gmail.com',
      'favoriteSubject': 'Dismisal',
      'favorite': false,
    },
    {
      'name': 'Wilken Nobetnom',
      'course': 'BSIT',
      'year': 3,
      'age': 23,
      'hobby': '',
      'image': 'assets/a1.jpg',
      'bday': 'July 25, 2003',
      'height': 5.4,
      'active': true,
      'studentId': '2024-006',
      'email': 'wilken@gmail.com',
      'favoriteSubject': 'Mobile Development',
      'favorite': false,
    },
    {
      'name': 'Juswa Puppy',
      'course': 'BSIT',
      'year': 3,
      'age': 23,
      'hobby': '',
      'image': 'assets/papy.jpg',
      'bday': 'July 25, 2003',
      'height': 5.4,
      'active': true,
      'studentId': '2024-007',
      'email': 'juswa@gmail.com',
      'favoriteSubject': 'Computer Programming',
      'favorite': false,
    },
  ];

  // Save student records locally
  Future<void> saveStudents() async {
    final prefs = SharedPreferencesAsync();

    String studentData = jsonEncode(students);

    await prefs.setString(storageKey, studentData);
  }

  // Load student records when the app starts
  Future<void> loadStudents() async {
    final prefs = SharedPreferencesAsync();

    try {
      String? savedData = await prefs.getString(storageKey);

      if (savedData != null) {
        List<dynamic> decodedData = jsonDecode(savedData);

        setState(() {
          students = decodedData
              .map((student) =>
          Map<String, dynamic>.from(student))
              .toList();

          isLoading = false;
        });
      } else {
        // No saved records yet.
        // Keep and save the original seven students.
        await saveStudents();

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load saved student records.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    loadStudents();
  }

  String fallback(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Not provided';
    }

    return value;
  }

  // Open Student Details Screen
  // Save again when returning in case details were edited.
  Future<void> openDetails(
      Map<String, dynamic> student) async {
    await Navigator.pushNamed(
      context,
      '/student-details',
      arguments: student,
    );

    if (!mounted) return;

    setState(() {});

    await saveStudents();
  }

  // Open Add Student Screen
  void openAddStudent() async {
    final newStudent =
    await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddStudentScreen(
          existingStudents: students,
        ),
      ),
    );

    if (!mounted) return;

    if (newStudent != null) {
      setState(() {
        students.add(newStudent);
      });

      // Save the newly enrolled student
      await saveStudents();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student added successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    students.sort(
          (a, b) => a['name'].compareTo(b['name']),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Directory'),
        backgroundColor: Colors.teal,
      ),

      backgroundColor: Colors.teal[50],

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: openAddStudent,
        child: const Icon(Icons.person_add),
      ),

      body: isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.teal,
            ),
            SizedBox(height: 16),
            Text(
              'Loading students...',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
          : students.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.teal,
            ),
            const SizedBox(height: 16),
            const Text(
              'No students found',
              style: TextStyle(
                fontSize: 24,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your student directory is empty.',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];

          return Card(
            color: student['favorite'] == true
                ? Colors.amber[50]
                : Colors.white,
            margin: const EdgeInsets.only(
              bottom: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                color: Colors.teal,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      openDetails(student);
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        student['image'],
                      ),
                    ),
                    title: Text(
                      fallback(student['name']),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    subtitle: Text(
                      '${student['course']} - Year ${student['year']}\n'
                          '${student['active'] == true ? 'Active' : 'Inactive'}',
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                  ),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            student['favorite'] =
                            !(student['favorite'] ??
                                false);
                          });

                          await saveStudents();
                        },
                        icon: Icon(
                          student['favorite'] == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        label: Text(
                          student['favorite'] == true
                              ? 'Favorited'
                              : 'Favorite',
                        ),
                      ),

                      const SizedBox(width: 10),

                      ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            students.removeAt(index);
                          });

                          await saveStudents();

                          if (!mounted) return;

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                '${student['name']} deleted.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                      ),
                    ],
                  ),

                  if (student['favorite'] == true)
                    const Text(
                      'FAVORITE STUDENT',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
