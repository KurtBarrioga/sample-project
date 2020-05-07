import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:postgres/postgres.dart';

main() async {
  var app = Angel();
  var http = AngelHttp(app);
  var connection;
  var port = 3000;
  var url = '127.0.0.1';

  await http.startServer(url, port);
  print('listening to port $port');

  serverConnect() async {
    connection = new PostgreSQLConnection("127.0.0.1", 5432, "DemoApp",
        username: "postgres", password: "icedragon1");
    await connection.open();
  }

  app.get("/", (req, res) {
    res.write('New Server Test');
  });

  app.post("/addHistory", (req, res) async {
    await serverConnect();
    await req.parseBody();
    var query =
        "INSERT INTO history(destination, source, place, img) VALUES( '${req.bodyAsMap['destination']}', '${req.bodyAsMap['source']}', '${req.bodyAsMap['place']}', '${req.bodyAsMap['img']}')";
    await connection.query(query);
  });

  app.get("/getHistory", (req, res) async{
    await serverConnect();
    var query = "SELECT * FROM history";
    List<List<dynamic>> results = await connection.query(query);
    return results;
  });

  app.get("/profile/:name", (req, res) async {
    await serverConnect();
    var query = "SELECT * from users WHERE name = '${req.params['name']}'";
    List<List<dynamic>> results = await connection.query(query);
    return results;
  });

  app.get("/count", (req, res) async {
    await serverConnect();
    var query = "SELECT COUNT(*) FROM history";
    List<List<dynamic>> results = await connection.query(query);
    return results;
  });

  app.delete("/deleteHistory/:id", (req, res) async{
    await serverConnect();
    var query = "DELETE FROM history WHERE id = ${req.params['id']}";
    await connection.query(query);
  });


}
