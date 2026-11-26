// Command-line migration runner (no Flutter needed).
//
// Run from the folder that has pubspec.yaml and .env:
//   dart run lib/core/migrate.dart           -> apply pending migrations
//   dart run lib/core/migrate.dart status    -> show applied / pending
import 'dart:io';

import 'package:postgres/postgres.dart';

import 'migrations.dart';

Map<String, String> _readEnv(File file) {
  final values = <String, String>{};
  for (final raw in file.readAsLinesSync()) {
    final line = raw.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final i = line.indexOf('=');
    if (i <= 0) continue;
    var value = line.substring(i + 1).trim();
    if (value.length >= 2 &&
        ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'")))) {
      value = value.substring(1, value.length - 1);
    }
    values[line.substring(0, i).trim()] = value;
  }
  return values;
}

Future<void> main(List<String> args) async {
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    stderr.writeln('.env not found. Run this from the project folder '
        '(the one with pubspec.yaml) and create .env from .env.example.');
    exit(1);
  }

  final env = _readEnv(envFile);
  for (final key in ['DB_HOST', 'DB_NAME', 'DB_USER', 'DB_PASS']) {
    if ((env[key] ?? '').isEmpty) {
      stderr.writeln('Missing $key in .env');
      exit(1);
    }
  }

  Connection? conn;
  try {
    stdout.writeln('Connecting to ${env['DB_NAME']} ...');
    conn = await Connection.open(
      Endpoint(
        host: env['DB_HOST']!,
        database: env['DB_NAME']!,
        username: env['DB_USER']!,
        password: env['DB_PASS']!,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.require),
    );
    stdout.writeln('Connected.');

    if (args.contains('status')) {
      final exists = await conn.execute(
          "SELECT to_regclass('public.schema_migrations') IS NOT NULL");
      final applied = <int>{};
      if (exists.first.first == true) {
        final rows = await conn.execute('SELECT version FROM schema_migrations');
        applied.addAll(rows.map((r) => r.first as int));
      }
      for (final m in Migrations.all) {
        final mark = applied.contains(m.version) ? 'applied' : 'PENDING';
        stdout.writeln('  [$mark] ${m.version} - ${m.name}');
      }
    } else {
      final count = await Migrations.run(conn);
      stdout.writeln(count == 0
          ? 'Database is already up to date.'
          : 'Applied $count migration(s).');
    }
  } catch (e) {
    stderr.writeln('Migration failed: $e');
    exitCode = 1;
  } finally {
    await conn?.close();
  }
}
