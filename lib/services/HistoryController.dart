import 'package:sampleproject/server/AppServer.dart';

class HistoryController {
  AppServer server = AppServer();

  void insertHistory(destination, source, place, img) async {
    await server.serverConnect();
    server.insertHistory(destination, source, place, img);
  }

  getHistoryList() async {
    await server.serverConnect();
    return await server.getHistory();
  }

  void deleteHistory(id) async {
    await server.serverConnect();
    server.deleteHistory(id);
  }
}
