//import 'dart:html';

import 'package:at/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'FileIO.dart';
import 'measurement.dart';

class DetailView extends StatelessWidget {
  final Measurement measurement;

  //Konstruktor
  DetailView({Key key, @required this.measurement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[800],
      title: Text(
        measurement.name,
        style: TextStyle(
            color: Colors.green, decoration: TextDecoration.underline),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          //popup view scrollable
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildDetailView(),
              //_buildLogoAttribution(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          //color: Colors.grey[850],
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.green,
          child: const Text('Return'),
        ),
      ],
    );
  }

  Widget _buildDetailView() {
    TextStyle stl = new TextStyle(
      fontSize: 15.0,
      color: Colors.green,
    );

    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 5.0),
            Card(
              color: Colors.grey[850],
              child: Text(
                'Measurement Data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'ID Device: ' + measurement.idDevice,
              style: stl,
            ),
            Text(
              'DateTime: ' + measurement.dateTime.toString(),
              style: stl,
            ),
            Text(
              'Latitude: ' + measurement.latitude.toString(),
              style: stl,
            ),
            Text(
              'Longitude: ' + measurement.longitude.toString(),
              style: stl,
            ),
            Text(
              'Sound min: ' + measurement.soundMin.toString(),
              style: stl,
            ),
            Text(
              'Sound max: ' + measurement.soundMax.toString(),
              style: stl,
            ),
            Text(
              'Sound avg: ' + measurement.soundAvg.toString(),
              style: stl,
            ),
            Text(
              'Sound duration: ' + measurement.soundDuration.toString(),
              style: stl,
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              color: Colors.grey[850],
              child: Text(
                'Device Data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'Manufacturer: ' + measurement.Manufacturer,
              style: stl,
            ),
            Text(
              'Model: ' + measurement.Model,
              style: stl,
            ),
            Text(
              'os Version: ' + measurement.osVersion,
              style: stl,
            ),
            Text(
              'sdk Version: ' + measurement.sdkVersion,
              style: stl,
            ),
          ],
        ),
      ],
    );
  }
}

/*

class DetailView extends StatefulWidget {

  @override
  _DetailViewState createState() => _DetailViewState();

  final Measurement measurement;

  DetailView({Key key, @required this.measurement}) : super(key: key);

}

class _DetailViewState extends State<DetailView> {
  //String titelmeasurement = 'asdf';



  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      backgroundColor: Colors.grey[800],
      title: /*const */ Text(
       'test',
        //meas.name,
        style: TextStyle(
            color: Colors.green, decoration: TextDecoration.underline),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          //popup view scrollable
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildDetailView(),
              //_buildLogoAttribution(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          //color: Colors.grey[850],
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.green,
          child: const Text('Return'),
        ),
      ],
    );
  }

  Widget _buildDetailView() {
    String a = 'test';

    TextStyle stl = new TextStyle(
      fontSize: 15.0,
      color: Colors.green,
    );

    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 5.0),
            Card(
              color: Colors.grey[850],
              child: Text(
                'Measurement Data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'ID Device: $a',
              style: stl,
            ),
            Text(
              'DateTime: $a',
              style: stl,
            ),
            Text(
              'Latitude: $a',
              style: stl,
            ),
            Text(
              'Longitude: $a',
              style: stl,
            ),
            Text(
              'Sound min: $a',
              style: stl,
            ),
            Text(
              'Sound max: $a',
              style: stl,
            ),
            Text(
              'Sound avg: $a',
              style: stl,
            ),
            Text(
              'Sound duration: $a',
              style: stl,
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              color: Colors.grey[850],
              child: Text(
                'Device Data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'Manufacturer: $a',
              style: stl,
            ),
            Text(
              'Model: $a',
              style: stl,
            ),
            Text(
              'os Version: $a',
              style: stl,
            ),
            Text(
              'sdk Version: $a',
              style: stl,
            ),
          ],
        ),

        //TEST ob popup view scrollbar, kann dann gelöscht werden
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 5.0),
            Card(
              color: Colors.grey[850],
              child: Text(
                'TEST',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
            Text(
              'test: $a',
              style: stl,
            ),
          ],
        ),
      ],
    );
  }
}

*/

/*
//------------------------NORMALER VIEW----------------------------------------
/*
void main() => runApp(MaterialApp(
  home: DetailView(),
));
*/
class DetailView extends StatefulWidget {
  @override
  _DetailViewState createState() => _DetailViewState();

    DetailView(Measurement m){}
}

class _DetailViewState extends State<DetailView> {
  String a = 'jhghjg';



  TextStyle stl = new TextStyle(
    fontSize: 20.0,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        //centerTitle: true,
        backgroundColor: Colors.green,
        title: Text('Measurement 1'),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 10.0),
              Card(
                color: Colors.green,
                child: Text(
                  'Measurement Data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'ID Device: $a',
                style: stl,
              ),
              SizedBox(height: 5.0),
              Text(
                'DateTime: $a',
                style: stl,
              ),
              SizedBox(height: 5.0),
              Text(
                'Latitude: $a',
                style: stl,
              ),
              SizedBox(height: 5.0),
              Text(
                'Longitude: $a',
                style: stl,
              ),
              SizedBox(height: 5.0),
              Text(
                'Sound min: $a',
                style: stl,
              ),
              SizedBox(height: 5.0),
              Text(
                'Sound max: $a',
                style: stl,
              ),
              SizedBox(height: 5.0),
              Text(
                'Sound avg: $a',
                style: stl,
              ),
              SizedBox(height: 5.0),
              Text(
                'Sound duration: $a',
                style: stl,
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                color: Colors.green,
                child: Text(
                  'Device Data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Manufacturer: $a',
                style: stl,
              ),
              SizedBox(height: 5.0),
              Text(
                'Model: $a',
                style: stl,
              ),
              SizedBox(height: 5.0),
              Text(
                'os Version: $a',
                style: stl,
              ),
              SizedBox(height: 5.0),
              Text(
                'sdk Version: $a',
                style: stl,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
