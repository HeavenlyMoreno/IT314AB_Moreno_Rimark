
import 'package:flutter/material.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> student;

  const StudentDetailsScreen({
    required this.student,
  });

  @override
  State<StudentDetailsScreen> createState() =>
      _StudentDetailsScreenState();
}

class _StudentDetailsScreenState
    extends State<StudentDetailsScreen> {

  void editStudent() {
    TextEditingController nameController =
    TextEditingController(text: widget.student['name']);

    TextEditingController emailController =
    TextEditingController(text: widget.student['email']);

    TextEditingController hobbyController =
    TextEditingController(text: widget.student['hobby']);

    bool editedActive = widget.student['active'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Student'),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Student Name',
                      ),
                    ),

                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),

                    TextField(
                      controller: hobbyController,
                      decoration: const InputDecoration(
                        labelText: 'Hobby',
                      ),
                    ),

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
                      widget.student['name'] =
                          nameController.text;

                      widget.student['email'] =
                          emailController.text;

                      widget.student['hobby'] =
                          hobbyController.text;

                      widget.student['active'] =
                          editedActive;
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Student information updated.',
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
    ).then((value) {
      nameController.dispose();
      emailController.dispose();
      hobbyController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: Colors.teal,
      ),

      backgroundColor: Colors.teal[50],

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Center(
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage(
                      student['image'],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    student['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Divider(height: 30),

                detailRow('Student ID', student['studentId']),
                detailRow('Course', student['course']),
                detailRow('Year Level', student['year'].toString()),
                detailRow('Age', student['age'].toString()),
                detailRow('Birthday', student['bday']),
                detailRow('Height', '${student['height']} ft'),
                detailRow('Hobby', student['hobby']),
                detailRow('Email', student['email']),
                detailRow(
                  'Favorite Subject',
                  student['favoriteSubject'],
                ),

                detailRow(
                  'Status',
                  student['active'] == true
                      ? 'Active'
                      : 'Inactive',
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: editStudent,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Student'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
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

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 125,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value.isEmpty ? 'Not provided' : value,
            ),
          ),
        ],
      ),
    );
  }
}
