import 'package:flutter/material.dart';
import 'package:sampleproject/services/HistoryController.dart';

// List<History> history = List();

List searched = List();
List results = List();

HistoryController historyController = new HistoryController();

class NewScreen extends StatelessWidget {
  String appBarTitle = "";

  NewScreen(title) {
    initHistory();
    this.appBarTitle = title;
  }

  initHistory() async {
    results = await historyController.getHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  State<StatefulWidget> createState() {
    return NewScreenPageState();
  }
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
        await historyController.deleteHistory(results.elementAt(index)[0]);
        await NewScreen('');
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
