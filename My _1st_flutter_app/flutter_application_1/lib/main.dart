
import 'package:flutter/material.dart';

import 'Screens/student_list_screen.dart';
import 'Screens/student_details_screen.dart';
import 'Screens/add_student_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Directory',

      initialRoute: '/student-list',

      onGenerateRoute: (settings) {
        if (settings.name == '/student-list') {
          return MaterialPageRoute(
            builder: (context) {
              return const StudentListScreen();
            },
          );
        }


        if (settings.name == '/student-details') {
          final student =
          settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(
            builder: (context) {
              return StudentDetailsScreen(
                student: student,
              );
            },
          );
        }


        if (settings.name == '/add-student') {
          return MaterialPageRoute(
            builder: (context) {
              return const AddStudentScreen();
            },
          );
        }

        return null;
      },
    );
  }
}
