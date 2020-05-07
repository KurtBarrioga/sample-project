import 'package:sampleproject/server/AppServer.dart';

class UserController {
  AppServer server = AppServer();

  getUser() async {
    await server.serverConnect();
    return await server.getUser();
  }

  getHistoryCount() async {
    await server.serverConnect();
    return await server.getHistoryCount();
  }
}
