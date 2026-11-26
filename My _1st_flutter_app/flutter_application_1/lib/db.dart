import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

class Db {
  static Connection? _conn;

  static Future<Connection> get() async {
    if (_conn != null && _conn!.isOpen) return _conn!;
    _conn = await Connection.open(
      Endpoint(
        host: dotenv.env['DB_HOST']!,
        database: dotenv.env['DB_NAME']!,
        username: dotenv.env['DB_USER']!,
        password: dotenv.env['DB_PASS']!,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.require,
        queryMode: QueryMode.simple,
      ),
    );
    return _conn!;
  }
}