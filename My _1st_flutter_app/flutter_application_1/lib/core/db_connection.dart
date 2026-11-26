import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

/// One shared connection to Neon PostgreSQL, reused by every repository.
class DbConnection {
  DbConnection._();

  static Connection? _conn;

  static Future<Connection> get() async {
    final existing = _conn;
    if (existing != null && existing.isOpen) return existing;

    _conn = await Connection.open(
      Endpoint(
        host: dotenv.env['DB_HOST']!,
        database: dotenv.env['DB_NAME']!,
        username: dotenv.env['DB_USER']!,
        password: dotenv.env['DB_PASS']!,
      ),
      // SSL is required by Neon. Parameters are sent separately from the SQL.
      settings: const ConnectionSettings(sslMode: SslMode.require),
    );
    return _conn!;
  }

  /// Opens the connection and runs a test query.
  /// Returns the database name on success, throws on failure.
  static Future<String> test() async {
    final conn = await get();
    final result = await conn.execute('SELECT current_database()');
    return result.first.first as String;
  }
}
