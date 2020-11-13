import 'package:at/Weighting.dart';
import 'package:at/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsMeasurementState createState() => _SettingsMeasurementState();
}

class _SettingsMeasurementState extends State<SettingsScreen> {
  int threshold;
  String dropdownValue = 'A-Weighting';
  int calib1;
  int calib2;
  int calib3;
  int calib4;
  int calib5;
  String weighting;

  getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    threshold = prefs.getInt("threshold") ?? 0;
    calib1 = prefs.getInt('calib1') ?? 0;
    calib2 = prefs.getInt('calib2') ?? 0;
    calib3 = prefs.getInt('calib3') ?? 0;
    calib4 = prefs.getInt('calib4') ?? 0;
    calib5 = prefs.getInt('calib5') ?? 0;
    weighting = prefs.getString('weighting') ?? 'A';
    setState(() {});
  }

  setValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("threshold", threshold);
    await prefs.setInt('calib1', calib1);
    await prefs.setInt('calib2', calib2);
    await prefs.setInt('calib3', calib3);
    await prefs.setInt('calib4', calib4);
    await prefs.setInt('calib5', calib5);
    await prefs.setString('weighting', weighting);
  }




  @override
  void initState() {
    threshold = 0;
    calib1 = 0;
    calib2 = 0;
    calib3 = 0;
    calib4 = 0;
    calib5 = 0;
    weighting = 'A';
    getValues();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0), // here the desired height
        child: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(color: Colors.green),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[850],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //---------------- Threshold Value------------------
            Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      'Set threshold:',
                      style: TextStyle(color: Colors.green),
                    )),
                Container(
                  decoration: containerBorder(),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //  Expanded(
                      //child:
                      Text('Threshold:', style: TextStyle(color: Colors.green)),
                      //  ),

                      /*

                      Expanded(

                        child: TextField(
                          controller: thresholdValueController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            enabledBorder: UnderlineInputBorder(// Warum 2 mal?
                                // borderSide: BorderSide(color: Colors.green),
                                ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            hintText: "$thresholdValue dB",
                            labelStyle: new TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),

*/
                      Text(
                        threshold.toString() + " dB",
                        textAlign: TextAlign.center,
                        style: calibTextBold(),
                      ),

                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            threshold += 5;
                            setValues();
                          });
                        },
                        child: Text(
                          '+5%',
                          style: btnText(),
                        ),
                        color: Colors.white24,
                      ),

                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            if (threshold >= 5) {
                              threshold -= 5;
                              setValues();
                            }
                          });
                        },
                        child: Text(
                          '-5%',
                          style: btnText(),
                        ),
                        color: Colors.white24,
                      ),

                      /*

                      RaisedButton(
                        onPressed: () {
                          if (double.tryParse(thresholdValueController.text) !=
                              null) {
                            if (double.tryParse(thresholdValueController.text) <
                                0) {
                              setState(() {
                                //ACHTUNG WICHTIG! Die setState funktion triggert die build funktion des gesamten screens!
                                thresholdValue = 0;
                              });
                            } else {
                              setState(() {
                                thresholdValue = double.tryParse(
                                    thresholdValueController.text);
                                // print('Threshold set to ' '$thresholdValue' ' dB');
                              });
                            }
                          } else {
                            setState(() {
                              // default wert wenn zB ein buchstabe eingetippt wird
                              thresholdValue = 70;
                            });
                          }
                          print('Threshold set to ' '$thresholdValue' ' dB');
                          //addThreshold();

                          addValue();
                          //getThresholdValue();
                          thresholdValueController.clear();
                        },
                        child: Text('Set',
                            style: TextStyle(color: Colors.grey[800])),
                        color: Colors.green,
                      ),

                      */
                    ],
                  ),
                ),
              ],
            ),

            Divider(
              color: Colors.grey[850],
              //height: 30,
              thickness: 2,
              //indent: 0,
              //endIndent: 0,
            ),

//---------------- Calibration Offset------------------

            /*
            Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      'Set calibration offset:',
                      style: TextStyle(color: Colors.green),
                    )),
                Container(
                  decoration: containerBorder(),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Calibrate:',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: calibValueController,
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                enabledBorder: UnderlineInputBorder(
                                    // Warum 2 mal?
                                    // borderSide: BorderSide(color: Colors.green),
                                    ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                hintText: "$calibValue dB",
                                labelStyle: new TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {
                              if (double.tryParse(calibValueController.text) !=
                                  null) {
                                setState(() {
                                  calibValue = double.tryParse(
                                      calibValueController.text);
                                });
                              } else {
                                setState(() {
                                  calibValue = 0;
                                });
                              }
                              print('Calib set to ' '$calibValue' ' dB');
                              addValue();
                              // getDoubleValuesSF();
                              calibValueController.clear();
                            },
                            child: Text(
                              'Set',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        calibValue += 1;
                        print('Calib set to ' '$calibValue' ' dB');
                      });
                    },
                    child: Text(
                      '+1 dB',
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Merriweather"),
                    ),
                    color: Colors.grey[800],
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        calibValue -= 1;
                        print('Calib set to ' '$calibValue' ' dB');
                      });
                    },
                    child: Text(
                      '-1 dB',
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Merriweather"),
                    ),
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),






            Divider(
              color: Colors.grey[850],
              //height: 20,
              thickness: 2,
              //indent: 0,
              //endIndent: 0,
            ),



*/

//von hier

            Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      'Calibration',
                      style: TextStyle(color: Colors.green),
                    )),
                Container(
                  decoration: containerBorder(),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  calib1++;
                                  setValues();
                                });
                              },
                              child: Text(
                                '+1%',
                                style: btnText(),
                              ),
                              color: Colors.white24,
                            ),
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  calib2++;
                                  setValues();
                                });
                              },
                              child: Text(
                                '+1%',
                                style: btnText(),
                              ),
                              color: Colors.white24,
                            ),
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  calib3++;
                                  setValues();
                                });
                              },
                              child: Text(
                                '+1%',
                                style: btnText(),
                              ),
                              color: Colors.white24,
                            ),
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  calib4++;
                                  setValues();
                                });
                              },
                              child: Text(
                                '+1%',
                                style: btnText(),
                              ),
                              color: Colors.white24,
                            ),
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  calib5++;
                                  setValues();
                                });
                              },
                              child: Text(
                                '+1%',
                                style: btnText(),
                              ),
                              color: Colors.white24,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              calib1.toString() + "%",
                              textAlign: TextAlign.center,
                              style: calibTextBold(),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              calib2.toString() + "%",
                              textAlign: TextAlign.center,
                              style: calibTextBold(),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              calib3.toString() + "%",
                              textAlign: TextAlign.center,
                              style: calibTextBold(),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              calib4.toString() + "%",
                              textAlign: TextAlign.center,
                              style: calibTextBold(),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              calib5.toString() + "%",
                              textAlign: TextAlign.center,
                              style: calibTextBold(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  calib1--;
                                  setValues();
                                });
                              },
                              child: Text(
                                '-1%',
                                style: btnText(),
                              ),
                              color: Colors.white24,
                            ),
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  calib2--;
                                  setValues();
                                });
                              },
                              child: Text(
                                '-1%',
                                style: btnText(),
                              ),
                              color: Colors.white24,
                            ),
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  calib3--;
                                  setValues();
                                });
                              },
                              child: Text(
                                '-1%',
                                style: btnText(),
                              ),
                              color: Colors.white24,
                            ),
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  calib4--;
                                  setValues();
                                });
                              },
                              child: Text(
                                '-1%',
                                style: btnText(),
                              ),
                              color: Colors.white24,
                            ),
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  calib5--;
                                  setValues();
                                });
                              },
                              child: Text(
                                '-1%',
                                style: btnText(),
                              ),
                              color: Colors.white24,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text("-440Hz",
                                textAlign: TextAlign.center,
                                style: calibText()),
                          ),
                          Expanded(
                            child: Text(
                              "440-880Hz",
                              textAlign: TextAlign.center,
                              style: calibText(),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "880-3520Hz",
                              textAlign: TextAlign.center,
                              style: calibText(),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "3520-7000Hz",
                              textAlign: TextAlign.center,
                              style: calibText(),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "7000- Hz",
                              textAlign: TextAlign.center,
                              style: calibText(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Divider(
              color: Colors.grey[850],
              //height: 20,
              thickness: 2,
              //indent: 0,
              //endIndent: 0,
            ),

            /*

            Container(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ButtonTheme(
                          minWidth: 100.0,
                          height: 100.0,
                          child: RaisedButton(
                              color: Colors.grey[700],
                              child: Text(
                                'A-Weighting',
                                style: buttonText,
                              ),
                              onPressed: () {}),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ButtonTheme(
                          minWidth: 100.0,
                          height: 100.0,
                          child: RaisedButton(
                              color: Colors.grey[700],
                              child: Text(
                                'B-Weighting',
                                style: buttonText,
                              ),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ButtonTheme(
                          minWidth: 100.0,
                          height: 100.0,
                          child: RaisedButton(
                              color: Colors.grey[700],
                              child: Text(
                                'C-Weighting',
                                style: buttonText,
                              ),
                              onPressed: () {}),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ButtonTheme(
                          minWidth: 100.0,
                          height: 100.0,
                          child: RaisedButton(
                              color: Colors.grey[700],
                              child: Text(
                                'D-Weighting',
                                style: buttonText,
                              ),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
*/
//---------------- Weighting------------------
            Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      'Select weighting:',
                      style: TextStyle(color: Colors.green),
                    )),
                Container(
                  decoration: containerBorder(),
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.green,
                    ),
                    iconSize: 30,
                    style: TextStyle(color: Colors.green),
                    underline: Container(
                      height: 1,
                      color: Colors.green,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;

                        switch (dropdownValue) {
                          case 'A-Weighting':
                            print(dropdownValue);
                            weighting = 'A';
                            print(weighting);
                            break;
                          case 'B-Weighting':
                            print(dropdownValue);
                            weighting = 'B';
                            print(weighting);
                            break;
                          case 'C-Weighting':
                            print(dropdownValue);
                            weighting = 'C';
                            print(weighting);
                            break;
                          case 'D-Weighting':
                            print(dropdownValue);
                            weighting = 'D';
                            print(weighting);
                            break;
                        }
                        setValues();
                      });
                    },
                    items: <String>[
                      'A-Weighting',
                      'B-Weighting',
                      'C-Weighting',
                      'D-Weighting'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle calibTextBold() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.green,
    );
  }

  TextStyle calibText() {
    return TextStyle(
      fontWeight: FontWeight.w100,
      color: Colors.green,
    );
  }

  TextStyle btnText() {
    return new TextStyle(
        fontSize: 15.0,
        color: Colors.green,
        fontWeight: FontWeight.w500,
        fontFamily: "Merriweather");
  }

/*
  Widget myWidget() {
    return Container(
      margin: const EdgeInsets.all(30.0),
      padding: const EdgeInsets.all(10.0),
      decoration: containerBorder(),
    );
  }
*/
  BoxDecoration containerBorder() {
    return BoxDecoration(
      color: Colors.grey[800],
      border: Border.all(
        width: 2,
        color: Colors.green,
      ),
    );
  }
}
