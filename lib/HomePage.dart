import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sampleproject/ProfilePage.dart';
import 'package:sampleproject/services/HistoryController.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

// void main() {
//   testWidgets('NewScreen has title History', (WidgetTester tester) async {

//     // Create the Finders.
//     final titleFinder = find.text('History');

//     await tester.runAsync(() async {
//     await tester.pumpWidget(NewScreen('History'));

//     expect(titleFinder, findsOneWidget);
//     });

//   });
// }

List results = List();

HistoryController historyController = new HistoryController();

class NewScreen extends StatelessWidget {
  String appBarTitle = "";

  NewScreen(title) {
    initHistory();
    this.appBarTitle = title;
  }

  initHistory() async {
    //results = await historyController.getHistoryList();
    var response = await http.get("http://10.0.2.2:3000/getHistory");
    var body = jsonDecode(response.body);
    results = body;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: NewScreenPage(title: this.appBarTitle),
    );
  }
}

class NewScreenPage extends StatefulWidget {
  NewScreenPage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => NewScreenPageState();
}

class NewScreenPageState extends State<NewScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                onLongPress: () {
                  showAlertDialog(context, index);
                },
                title: Text(results.elementAt(index)[3].toString()),
                leading: Container(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image:
                          NetworkImage(results.elementAt(index)[4].toString()),
                    ),
                  ),
                ),
              ));
            }));
  }

  showAlertDialog(BuildContext context, index) {
    Widget _okButton = FlatButton(
      child: Text("CANCEL"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget _delButton = FlatButton(
      child: Text(
        "DELETE",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () async {
        //await historyController.deleteHistory(results.elementAt(index)[0]);
        var response = await http.delete(
            "http://10.0.2.2:3000/deleteHistory/${results.elementAt(index)[0]}");
        if (response.statusCode == 200) {
          NewScreen('');
          ProfilePage();
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              final snackBar = SnackBar(
                content: Text('Succesfully Deleted!'),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {},
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);

              Navigator.of(context, rootNavigator: true).pop();
            });
          });
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(results.elementAt(index)[3]),
      content: Text(
        "${results.elementAt(index)[1]}",
        textAlign: TextAlign.center,
      ),
      actions: [_okButton, _delButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
