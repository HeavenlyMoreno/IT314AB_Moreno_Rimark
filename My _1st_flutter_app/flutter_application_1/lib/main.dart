import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'models/student.dart';
import 'models/subject.dart';
import 'repositories/enrollment_repository.dart';
import 'repositories/grade_repository.dart';
import 'repositories/schedule_repository.dart';
import 'repositories/student_repository.dart';
import 'repositories/subject_repository.dart';
import 'viewmodels/enrollment_viewmodel.dart';
import 'viewmodels/grade_viewmodel.dart';
import 'viewmodels/student_viewmodel.dart';
import 'viewmodels/subject_viewmodel.dart';
import 'views/enroll_screen.dart';
import 'views/home_screen.dart';
import 'views/startup_screen.dart';
import 'views/student_details_screen.dart';
import 'views/student_form_screen.dart';
import 'views/subject_details_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Missing .env is reported by the startup screen's connection test.
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentViewModel(StudentRepository())),
        ChangeNotifierProvider(
          create: (_) => SubjectViewModel(SubjectRepository(), ScheduleRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => EnrollmentViewModel(EnrollmentRepository()),
        ),
        ChangeNotifierProvider(create: (_) => GradeViewModel(GradeRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student Enrollment System',
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const StartupScreen());
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            case '/add-student':
              return MaterialPageRoute(builder: (_) => const StudentFormScreen());
            case '/student-details':
              final student = settings.arguments as Student;
              return MaterialPageRoute(
                  builder: (_) => StudentDetailsScreen(student: student));
            case '/enroll':
              final student = settings.arguments as Student;
              return MaterialPageRoute(
                  builder: (_) => EnrollScreen(student: student));
            case '/subject-details':
              final subject = settings.arguments as Subject;
              return MaterialPageRoute(
                  builder: (_) => SubjectDetailsScreen(subject: subject));
          }
          return null;
        },
      ),
    );
  }
}
