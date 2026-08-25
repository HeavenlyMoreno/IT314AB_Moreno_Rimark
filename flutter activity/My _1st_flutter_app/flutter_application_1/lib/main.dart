import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String fallback(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Not provided";
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final students = [
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
        'emo': '😤',
        'studentId': '2024-001',
        'email': 'rimark@gmail.com',
        'favoriteSubject': 'Lunch',
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
        'active': true,
        'emo': '😎',
        'studentId': '2024-002',
        'email': 'mannes@gmail.com',
        'favoriteSubject': 'Web Development',
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
        'emo': '💀',
        'studentId': '2024-003',
        'email': 'johnkevin@gmail.com',
        'favoriteSubject': 'Database',
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
        'emo': '🎸',
        'studentId': '2024-004',
        'email': 'jamesneil@gmail.com',
        'favoriteSubject': 'Networking',
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
        'emo': '🎤',
        'studentId': '2024-005',
        'email': 'keith@gmail.com',
        'favoriteSubject': 'Dismisal',
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
        'emo': '🎥',
        'studentId': '2024-006',
        'email': 'wilken@gmail.com',
        'favoriteSubject': 'Mobile Development',
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
        'emo': '🎥',
        'studentId': '2024-007',
        'email': 'juswa@gmail.com',
        'favoriteSubject': 'Computer Programming',
      },
    ];

    students.sort((a, b) {
      String nameA = a['name'] as String;
      String nameB = b['name'] as String;

      return nameA.compareTo(nameB);
    });

    String currentDate =
        "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('My First Flutter Application'),
        backgroundColor: Colors.teal,
      ),

      backgroundColor: Colors.teal[50],


      body: students.isEmpty
          ? const Center(
        child: Text(
          'No students found.',
          style: TextStyle(
            fontSize: 24,
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 30),

        itemCount: students.length,

        itemBuilder: (context, index) {
          final student = students[index];

          return Column(
            children: [
              buildCard(
                student['image'] as String,
                student['name'] as String,
                student['course'] as String,
                student['hobby'] as String,
                student['emo'] as String,
                currentDate,
                student['age'] as int,
                student['bday'] as String,
                student['height'] as double,
                student['active'] as bool,
                student['studentId'] as String,
                student['email'] as String,
                student['favoriteSubject'] as String,
              ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget buildCard(
      String img,
      String name,
      String course,
      String hobby,
      String? emo,
      String date,
      int age,
      String bday,
      double height,
      bool active,
      String studentId,
      String email,
      String favoriteSubject,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 30),

      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.teal,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Center(
            child: Image.asset(
              img,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            fallback(name),
            style: const TextStyle(
              fontSize: 26,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            fallback(course),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              letterSpacing: 1.1,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            '"My First Flutter Application"',
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              color: Colors.teal,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Hobby: ${fallback(hobby)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: Colors.teal,
            ),
          ),

          if (emo != null && emo.isNotEmpty) ...[
            const SizedBox(height: 14),

            Center(
              child: Text(
                emo,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],

          const SizedBox(height: 14),

          Text(
            date,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black45,
              letterSpacing: 0.8,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Text(
                  'Age : $age',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                Flexible(
                  child: Text(
                    'Birth date : ${fallback(bday)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Height: $height ft',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Student Status: ${active ? 'Active' : 'Inactive'}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Student ID: $studentId',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Email: $email',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Favorite Subject: $favoriteSubject',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}