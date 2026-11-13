
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen();

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  bool isLoading = true;

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


  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    });
  }

  String fallback(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Not provided";
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {

    students.sort((a, b) {
      String nameA = a['name'];
      String nameB = b['name'];

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
                fontSize: 16,
                color: Colors.teal,
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
            Icon(
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
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
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
                context,
                index,
                student,
                currentDate,
              ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget buildCard(
      BuildContext context,
      int index,
      Map<String, dynamic> student,
      String date,
      ) {

    String name = student['name'];

    bool isFavorite = student['favorite'];

    return InkWell(


      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Student Card tapped: $name',
            ),
          ),
        );
      },

      borderRadius: BorderRadius.circular(15),

      child: Container(
        padding: const EdgeInsets.all(20),

        margin: const EdgeInsets.symmetric(horizontal: 30),

        decoration: BoxDecoration(
          color: isFavorite
              ? Colors.amber[50]
              : Colors.white,

          border: Border.all(
            color: isFavorite
                ? Colors.amber
                : Colors.teal,
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
                student['image'],
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              fallback(student['name']),
              style: const TextStyle(
                fontSize: 26,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              fallback(student['course']),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
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
              'Hobby: ${fallback(student['hobby'])}',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.teal,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              date,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black45,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Age : ${student['age']}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Birth date : ${student['bday']}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Height: ${student['height']} ft',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),


            Text(
              student['active'] == true
                  ? 'Student Status: Active'
                  : 'Student Status: Inactive',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: student['active'] == true
                    ? Colors.green
                    : Colors.red,
              ),
            ),


            if (student['active'] == false) ...[
              const SizedBox(height: 8),

              const Text(
                'INACTIVE STUDENT',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],

            const SizedBox(height: 8),

            Text(
              'Student ID: ${student['studentId']}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Email: ${student['email']}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Favorite Subject: ${student['favoriteSubject']}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (student['favorite'] == true) {
                        student['favorite'] = false;
                      } else {
                        student['favorite'] = true;
                      }
                    });
                  },

                  icon: Icon(
                    student['favorite']
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),

                  label: Text(
                    student['favorite']
                        ? 'Favorited'
                        : 'Favorite',
                  ),
                ),

                const SizedBox(width: 10),


                ElevatedButton.icon(
                  onPressed: () {

                    bool editedActive = student['active'] == true;

                    showDialog(
                      context: context,

                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setDialogState) {
                            return AlertDialog(
                              title: const Text('Edit Student'),

                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Student: $name'),

                                  const SizedBox(height: 15),

                                  SwitchListTile(
                                    title: const Text('Active Status'),

                                    value: editedActive,

                                    activeColor: Colors.teal,

                                    onChanged: (value) {
                                      setDialogState(() {
                                        editedActive = value;
                                      });
                                    },
                                  ),
                                ],
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },

                                  child: const Text('Cancel'),
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      student['active'] = editedActive;
                                    });

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '$name updated successfully!',
                                        ),
                                      ),
                                    );
                                  },

                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },

                  icon: const Icon(Icons.edit),

                  label: const Text('Edit'),
                ),

                const SizedBox(width: 10),


                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      students.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$name has been deleted.',
                        ),
                      ),
                    );
                  },

                  icon: const Icon(Icons.delete),

                  label: const Text('Delete'),
                ),
              ],
            ),


            if (student['favorite'] == true) ...[
              const SizedBox(height: 12),

              Center(
                child: Text(
                  'FAVORITE STUDENT',

                  style: TextStyle(
                    color: Colors.amber[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
