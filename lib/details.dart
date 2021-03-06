import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'measurement.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';

class DetailView extends StatelessWidget {
  final Measurement measurement;

  //Konstruktor
  DetailView({Key key, @required this.measurement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[800],
      /*title: Text(
        'Details',
        //measurement.name,
        style: TextStyle(
            color: Colors.green, decoration: TextDecoration.underline),
        textAlign: TextAlign.center,
      ),*/
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: Container(
        width: MediaQuery.of(context).size.width, //Breit AlertDialog
        height: MediaQuery.of(context).size.height * 0.6, //Länge AlertDialog
        //popup view scrollable
        child: SingleChildScrollView(
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
            //SizedBox(height: 5.0),
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
              'ID Device: ' + measurement.idDevice,
              style: stl,
            ),
            Text(
              'Manufacturer: ' + measurement.manufacturer,
              style: stl,
            ),
            Text(
              'Model: ' + measurement.model,
              style: stl,
            ),
            Text(
              Platform.isAndroid
                  ? 'sdk Version: ' + measurement.sdkVersion
                  : 'os Version: ' + measurement.osVersion,
              style: stl,
            ),
            /*Text(
              'sdk Version: ' + measurement.sdkVersion,
              style: stl,
            ),*/
          ],
        ),
      ],
    );
  }
}

//StatefulWidget + device Infos
/*
class DetailView extends StatefulWidget {

  final Measurement measurement;
  //Konstruktor
  DetailView({Key key, @required this.measurement}) : super(key: key);

  @override
  _DetailViewState createState() => _DetailViewState(measurement);
}

class _DetailViewState extends State<DetailView> {

  Measurement measurement;

  _DetailViewState(this.measurement); //Konstruktor


  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin(); // instantiate device info plugin
  AndroidDeviceInfo androidDeviceInfo;
  IosDeviceInfo iosDeviceInfo;

  String manuf, mod, idDev, osVers;
  int sdkVers;


  @override
  void initState() {
    super.initState();
    getDeviceInfoAndroid();
    getDeviceInfoIos();
  }

  void getDeviceInfoAndroid() async {
    androidDeviceInfo =
    await deviceInfo.androidInfo; // instantiate Android Device Information
    setState(() {
      sdkVers = androidDeviceInfo.version.sdkInt;
      //osVers = androidDeviceInfo.version.baseOS;
      mod = androidDeviceInfo.model;
      manuf = androidDeviceInfo.manufacturer;
      idDev = androidDeviceInfo.id;
    });
  }

  void getDeviceInfoIos() async {
    iosDeviceInfo =
    await deviceInfo.iosInfo; // instantiate ios Device Information
    setState(() {
      //sdkVers = iosDeviceInfo.version.sdkInt;
      osVers = iosDeviceInfo.systemVersion;
      mod = iosDeviceInfo.model;
      manuf = iosDeviceInfo.name;
      idDev = iosDeviceInfo.utsname.version;
    });
  }


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
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.6,
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
              'ID Device: $idDev',
              //'ID Device: ' + measurement.idDevice.toString(),
              style: stl,
            ),
            Text(
              'Manufacturer: $manuf',
              //'Manufacturer: ' + measurement.Manufacturer,
              style: stl,
            ),
            Text(
              'Model: $mod',
              //'Model: ' + measurement.Model,
              style: stl,
            ),
            Text(
              'sdk Version: $sdkVers',
              //'sdk Version: ' + measurement.sdkVersion,
              style: stl,
            ),
            Text(
              'os Version: $osVers',
              //'sdk Version: ' + measurement.osVersion,
              style: stl,
            ),
          ],
        ),
      ],
    );
  }
}
*/
