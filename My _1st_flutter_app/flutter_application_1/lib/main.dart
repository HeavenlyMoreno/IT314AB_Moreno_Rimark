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

    final String name1 = "Rimark Rafael Moreno";
    final String course1 = "BSIT-3";
    final int age1 = 22;
    final String hobby1 = "Sleeping";
    final double height1 = 5.2;
    final bool active1 = true;
    final String img1 = "assets/daddy.jpg";
    final String bday1 = "April 19, 2004";
    final String emo1 = "😤";

    final String name2 = "";
    final String course2 = "BSIT-2";
    final int age2 = 21;
    final String hobby2 = "Role Play";
    final double height2 = 4.2;
    final bool active2 = true;
    final String img2 = "assets/mom.jpg";
    final String bday2 = "May 12, 2004";
    final String emo2 = "😎";

    final String name3 = "John Kevin Villacorte";
    final String course3 = "BSIT-2";
    final int age3 = 20;
    final String hobby3 = "Painting";
    final double height3 = 4.3;
    final bool active3 = true;
    final String img3 = "assets/b.jpg";
    final String bday3 = "October 8, 2006";
    final String emo3 = "";

    final String name4 = "James Neil";
    final String course4 = "";
    final int age4 = 22;
    final String hobby4 = "Guitar";
    final double height4 = 4.7;
    final bool active4 = true;
    final String img4 = "assets/Lover.jpg";
    final String bday4 = "February 14, 2004";
    final String emo4 = "🎸";

    final String name5 = "Keith Frances";
    final String course5 = "BSIT-3";
    final int age5 = 23;
    final String hobby5 = "Joke Purpose";
    final double height5 = 5.4;
    final bool active5 = true;
    final String img5 = "assets/m1.jpg";
    final String bday5 = "July 25, 2003";
    final String emo5 = "🎤";

    final String name6 = "Wilken Nobetnom";
    final String course6 = "BSIT-3";
    final int age6 = 23;
    final String hobby6 = "";
    final double height6 = 5.4;
    final bool active6 = true;
    final String img6 = "assets/a1.jpg";
    final String bday6 = "July 25, 2003";
    final String emo6 = "🎥";

    String currentDate = "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('My First Flutter Application'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.teal[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            buildCard(img1, name1, course1, hobby1, emo1, currentDate, age1, bday1, height1, active1),
            const SizedBox(height: 24),
            buildCard(img2, name2, course2, hobby2, emo2, currentDate, age2, bday2, height2, active2),
            const SizedBox(height: 24),
            buildCard(img3, name3, course3, hobby3, emo3, currentDate, age3, bday3, height3, active3),
            const SizedBox(height: 24),
            buildCard(img4, name4, course4, hobby4, emo4, currentDate, age4, bday4, height4, active4),
            const SizedBox(height: 24),
            buildCard(img5, name5, course5, hobby5, emo5, currentDate, age5, bday5, height5, active5),
            const SizedBox(height: 24),
            buildCard(img6, name6, course6, hobby6, emo6, currentDate, age6, bday6, height6, active6),
          ],
        ),
      ),
    );
  }

  Widget buildCard(
      String img, String name, String course, String hobby, String? emo,
      String date, int age, String bday, double height, bool active
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal, width: 2),
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
          if (emo != null) ...[
            const SizedBox(height: 14),
            Center(
              child: Text(emo, style: const TextStyle(fontSize: 20)),
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
                Text(
                  'Birth date : ${fallback(bday)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
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
        ],
      ),
    );
  }
}