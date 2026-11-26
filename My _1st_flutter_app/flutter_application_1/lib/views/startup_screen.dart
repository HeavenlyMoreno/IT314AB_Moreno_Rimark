import 'package:flutter/material.dart';

import '../core/app_exception.dart';
import '../core/db_connection.dart';
import '../core/migrations.dart';
import 'widgets/common.dart';

/// Connects to Neon, runs a test query, then opens the app.
/// Shows connecting / failed (with Retry) states.
class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  String? error;
  String status = 'Connecting to database...';

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    setState(() {
      error = null;
      status = 'Connecting to database...';
    });
    try {
      final dbName = await DbConnection.test();
      if (!mounted) return;
      setState(() => status = 'Checking database updates...');
      final applied = await Migrations.run(await DbConnection.get());
      if (!mounted) return;
      showSnack(
        context,
        applied == 0
            ? 'Connected to "$dbName". Database is up to date.'
            : 'Connected to "$dbName". Applied $applied migration(s).',
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      setState(() => error = friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: error == null
          ? LoadingView(status)
          : CenteredMessage(
              icon: Icons.cloud_off,
              title: 'Database setup failed',
              subtitle: '$error\n\nCheck your .env file and internet connection.',
              action: ElevatedButton.icon(
                onPressed: _connect,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ),
    );
  }
}
