import 'package:mysql1/mysql1.dart';

class DBConnection {
  static Future<MySqlConnection> getConnection() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'root',
      db: 'leilão',
      password: '1312',
    ));
    return conn;
  }
}