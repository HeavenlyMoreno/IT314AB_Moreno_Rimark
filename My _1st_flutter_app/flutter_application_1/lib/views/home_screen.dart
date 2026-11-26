import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/student_viewmodel.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'student_list_screen.dart';
import 'subject_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentViewModel>().loadStudents();
      context.read<SubjectViewModel>().loadSubjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [StudentListScreen(), SubjectListScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people), label: 'Students'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Subjects'),
        ],
      ),
    );
  }
}
