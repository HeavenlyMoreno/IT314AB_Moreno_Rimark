import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter Application',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String todayDate =
        "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";
    return Scaffold(
      appBar: AppBar(
        title: const Text('My First Flutter Application'),
        backgroundColor: Colors.teal,
      ),

      backgroundColor: Colors.teal[50],

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ---------------- CARD 1: PROFILE (top) ----------------
              Container(
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
                        'assets/mn.jpg',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 18),

                    const Text(
                      'Rimark Rafael Moreno',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    const Text(
                      'BSIT-3',
                      style: TextStyle(
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

                    const Text(
                      'Hobby: Sleeping ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Center(
                      child: Text('😤', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      todayDate,
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
                        children: const [
                          Text(
                            'Age : 22',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Birth date : April 19,2004',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Divider(
                thickness: 2,
                indent: 40,
                endIndent: 40,
                color: Colors.teal,
              ),

              const SizedBox(height: 24),


              Container(
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

                    const Center(
                      child: Text(
                        'My Favorites',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Favorite Game:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'ML',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Favorite Food:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'LUMPIA',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Favorite Movie:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'spider man',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}