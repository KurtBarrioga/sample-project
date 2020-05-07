import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sampleproject/HomePage.dart';
import 'package:sampleproject/ProfilePage.dart';
import 'package:sampleproject/services/Constants.dart';
import 'package:flushbar/flushbar.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(title: 'Uber for Hospitals'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String destination;
  String source;
  String place;
  String img;

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.settings.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice, child: Text(choice));
              }).toList();
            },
          )
        ],
      ),
      body: Center(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(10.673883, 122.975485),
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {riversideMarker, doctorsMarker, regionalMarker, myMarker},
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _boxes(
                        "https://lh5.googleusercontent.com/p/AF1QipNQWfVK6mFls6xvw114NcDekMsOy4HaDadENrRk=w480-h240-k-no",
                        10.683240,
                        122.958096,
                        "Riverside Medical Center"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _boxes(
                        "https://lh5.googleusercontent.com/p/AF1QipOjb7XWvIirN9tupHzFPZiKyawhRDFAMVYTiUoe=w408-h306-k-no",
                        10.672410,
                        122.951010,
                        "Corazon Locsin Reg. Hospital"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _boxes(
                        "https://lh5.googleusercontent.com/p/AF1QipOrWOosLQY9XhlxJvQZN2T3HGVt9a4xOEQDUHw=w408-h306-k-no",
                        10.678325,
                        122.960390,
                        "The Doctors Hospital"),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 90,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _meBox(
                    "https://static.thenounproject.com/png/17241-200.png",
                    10.673883,
                    122.975485,
                    "Where  Am I"),
              ),
            ),
          ),
        ]),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          source = "10.673883 : 122.975485";
          showAlertDialog(context);
        },
        tooltip: 'Add Destination',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void choiceAction(String choice) async {
    if (choice == "History") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NewScreen('History');
      }));
    } else if (choice == "Profile") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ProfilePage();
      }));
    } else if (choice == "Exit") {
      SystemNavigator.pop();
    }
  }

  Future<void> _gotoLocation(double lat, double long) async {
    destination = lat.toString() + " : " + long.toString();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
    )));
  }

  Widget _boxes(String _image, double lat, double long, String hospitalName) {
    return GestureDetector(
      onTap: () {
        place = hospitalName;
        img = _image;
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _detailsContainer(hospitalName),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _meBox(String _image, double lat, double long, String me) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _detailsContainer(String hospitalName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            hospitalName,
            style: TextStyle(
                color: Colors.indigoAccent,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Icon(
                FontAwesomeIcons.phone,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
                child: Text(
              " (034) 433 2697",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
          ],
        )),
        SizedBox(height: 5.0),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Icon(
                FontAwesomeIcons.locationArrow,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
                child: Text(
              " Bacolod City, Philippines",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
          ],
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "Open 24 hrs",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    Widget _okButton = FlatButton(
      child: Text("CANCEL"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget _continueButton = FlatButton(
        child: Text(
          "CONTINUE",
          style: TextStyle(color: Colors.green),
        ),
        onPressed: () async {
          // await historyController.insertHistory(destination, source, place, img);
          // NewScreen('');
          // ProfilePage();
          // Navigator.of(context, rootNavigator: true).pop();
          // Flushbar(
          //   message: "Added Successfully",
          //   duration: Duration(seconds: 3),
          // )..show(context);

          String url = 'http://10.0.2.2:3000/addHistory';
          Map<String, String> headers = {"Content-type": "application/json"};
          var json =
              '{"destination": "$destination", "source":"$source","place":"$place", "img":"$img"}';
          var response = await http.post(url, headers: headers, body: json);
          if (response.statusCode == 200) {
            NewScreen('');
            ProfilePage();
            Navigator.of(context, rootNavigator: true).pop();
            Flushbar(
              message: "Added Successfully",
              duration: Duration(seconds: 3),
            )..show(context);
          }
        });

    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text(
        "Go to Location?",
        textAlign: TextAlign.center,
      ),
      actions: [_okButton, _continueButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

Marker riversideMarker = Marker(
  markerId: MarkerId('Riverside Medical Center'),
  position: LatLng(10.683240, 122.958096),
  infoWindow: InfoWindow(title: 'Riverside Medical Center'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueCyan,
  ),
);

Marker regionalMarker = Marker(
  markerId: MarkerId('Corazon Locsin Regional Hospital'),
  position: LatLng(10.672410, 122.951010),
  infoWindow: InfoWindow(title: 'Corazon Locsin Regional Hospital'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueCyan,
  ),
);
Marker doctorsMarker = Marker(
  markerId: MarkerId('The Doctors Hospital'),
  position: LatLng(10.678325, 122.960390),
  infoWindow: InfoWindow(title: 'The Doctors Hospital'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueCyan,
  ),
);
Marker myMarker = Marker(
  markerId: MarkerId('You are Here'),
  position: LatLng(10.673883, 122.975485),
  infoWindow: InfoWindow(title: 'You are Here'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);
