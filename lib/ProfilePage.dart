import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/services/UserController.dart';
import 'package:http/http.dart' as http;

var name;
var count;
UserController userController = new UserController();

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key) {
    initProfile();
  }

  initProfile() async {
    var response = await http.get('http://10.0.2.2:3000/profile/Kurt Barrioga');
    var body = jsonDecode(response.body);
    name = body[0][1];
    if (response.statusCode == 200) {
      response = await http.get('http://10.0.2.2:3000/count');
      body = jsonDecode(response.body);
      count = body[0][0];
    }
  }

  final String title;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Profile'),
        ),
        body: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.red, Colors.red[300]],
                  begin: Alignment(-1.0, -2.0),
                  end: Alignment(1.0, 2.0),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 2.0)),
                        padding: EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://miro.medium.com/max/2048/0*0fClPmIScV5pTLoE.jpg"),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15),
                    child: Text(name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white)),
                  )
                ]),
              ),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 200),
                  child:
                      Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(24),
                              topRight: const Radius.circular(24)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  "Hi, $name! This is your profile."),
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child:
                                      Text("You had travelled $count times so far")),
                            ],
                          ))),
            ],
          ),
        ));
  }
}
