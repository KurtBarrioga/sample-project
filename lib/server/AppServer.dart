import 'package:postgres/postgres.dart';

class AppServer {
  var connection;

  serverConnect() async {
    connection = new PostgreSQLConnection("10.0.2.2", 5432, "DemoApp",
        username: "postgres", password: "icedragon1");
    await connection.open();
  }

  insertHistory(destination, source, place, img) async {
    var query =
        "INSERT INTO history(destination, source, place, img) VALUES('${destination}', '${source}', '${place}', '${img}')";
    await connection.query(query);
    print(query);
  }

  getHistory() async {
    var query = "SELECT * FROM history";
    List<List<dynamic>> results = await connection.query(query);

    return results;
  }

  deleteHistory(id) async {
    var query = "DELETE FROM history WHERE id = ${id}";
    await connection.query(query);
  }
}
