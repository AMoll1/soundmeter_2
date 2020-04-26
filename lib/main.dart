// Within this view the user can take a measurement

import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';
import 'dart:io' show Platform;

final AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;

// --- Main program ------------------------------------------------------------
void main() => runApp(
      MaterialApp(
        home: HomeMeasurement(),
      ),
    );

// --- Statefull widget to use hot reload, a statefull widget can change its state over time and it can use dynamic data --------------------------------------
class HomeMeasurement extends StatefulWidget {
  _HomeMeasurementState createState() => _HomeMeasurementState(
        textColor: TextStyle(
          color: Colors.green,
        ),
      );
}

// --- Create a state that can be updated every time a user makes an input -----
class _HomeMeasurementState extends State<HomeMeasurement> {
  _HomeMeasurementState({this.textColor});

  final TextStyle textColor; // Please comment
  Stream<List<int>> stream;
  StreamSubscription<List<int>> listener;
  List<int> currentSamples;
  bool isRecording = false;
  DateTime startTime;
  double actualValue;
  double minValue;
  double maxValue;
  double averageValue;
  double tempMaxPositive;
  double tempMinNegative;
  int ThresholdValue;
  String recFilename;
  bool high;
  double tempAverage;
  AnimationController controller;
  bool threshold;
  double tempMin;

  @override
  void initState() {
    super.initState();
    isRecording = false;
    actualValue = 0.0;
    minValue = double.infinity;
    maxValue = 0.0;
    averageValue = 0.0;
    ThresholdValue = 70;
    high = false;
    recFilename = 'default';
    tempAverage = 0.0;
    threshold = false;
    tempMin = 0;
  }

  void _changeListening() =>
      !isRecording ? _startListening() : _stopListening();

  bool _startListening() {
    if (isRecording) return false;
    stream = microphone(
        sampleRate: 44100,
        audioSource: AudioSource.MIC,
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AUDIO_FORMAT); //16 bit pcm => max.value = 2^16/2

    setState(() {
      isRecording = true;
    });

    print("measuring started");
    //listener = stream.listen((samples) => currentSamples = samples);
    listener = stream.listen((samples) {
      // print (samples);
      // samples = samples.where((x) => x > (20.0 * log(ThresholdValue.toDouble()) * log10e)).toList();

      currentSamples = samples;
      calculate(currentSamples);
    });
    return true;
  }

  double calcActualValue(List<int> input) {
    return calcDb(input.first.abs().toDouble());
  }

  bool checkThreshold(List<int> input) {
    return input.any((x) => (calcDb(x.toDouble())) > ThresholdValue);
  }

  double calcDb(double input) {
    return 20 * log(input) * log10e;
  }

  void calcMax(List<int> input) {
    tempMaxPositive = calcDb(input.reduce(max).abs().toDouble());
    tempMinNegative = calcDb(input.reduce(min).abs().toDouble());

    if (tempMaxPositive > tempMinNegative) {
      high = true;
    } else {
      high = false;
    }

    if (high && (tempMaxPositive > maxValue)) {
      maxValue = tempMaxPositive;
    } else if (!high && (tempMinNegative > maxValue)) {
      maxValue = tempMinNegative;
    }
  }

  void calcMin(List<int> input) {
    //min value, ist natürlich immer - unendlich....
    tempMin = calcDb(input
        .reduce((a, b) => a.abs() <= b.abs() ? a.abs() : b.abs())
        .toDouble());
    if (tempMin < minValue) {
      minValue = tempMin;
    }
  }

// moving average implementieren !!!
  double calcAvg(List<int> input) {
    tempAverage = calcDb(
        input.reduce((a, b) => a.abs() + b.abs()).toDouble() / input.length);
    return ((tempAverage + averageValue) / 2);
  }

  void calculate(List<int> input) {
    if (!threshold) {
      threshold = checkThreshold(input);

      if (threshold) {
        print("threshold überschritten =" + threshold.toString());
        startTime = DateTime.now();
      }
    }
    if (input.isNotEmpty && threshold) {
      actualValue = calcActualValue(input);
      calcMax(input);
      calcMin(input);
      averageValue = calcAvg(input);
    }
    setState(() {});
  }

  bool _stopListening() {
    if (!isRecording) return false;
    print("measuring stopped");
    listener.cancel();
    setState(() {
      isRecording = false;
      threshold = false;
      currentSamples = null;
      startTime = null;
      actualValue = 0.0;
      minValue = double.infinity;
      maxValue = 0.0;
      averageValue = 0.0;
      tempMin = 0;
    });
    return true;
  }

  final ThresholdValueController =
      TextEditingController(); // Um text einzulesen und auf den eingegebenen wert zuzugreifen braucht man einen controller
  final FileNameController = TextEditingController();

  @override
  void dispose() {
    listener.cancel();
    ThresholdValueController.dispose();
    FileNameController.dispose();
    super.dispose();
  }

  Color _getBgColor() => (isRecording) ? Colors.red : Colors.green;

  @override
  Widget build(BuildContext context) {
    // Der widget tree der hier erstellt wird kann jedesmal neu gebaut werden wenn sich eine variable von oben ändert
    return Scaffold(
      // Das Scaffold widget ist der beginn unseres widget-trees ab hier verästeln sich die widgets nach unten

      // --- App Bar at the top ------------------------------------------------
      appBar: AppBar(
        title: Text(
          'Measurement',
          style: textColor,
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),

      // --- The Body ----------------------------------------------------------
      // --- Zeilen erstellen --------------------------------------------------
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // --- Zeile 1: Input section ----------------------------------------
          Container(
              padding: EdgeInsets.all(
                  3.0), //NICHT MEHR ALS 3.0 SONST KONFLIKT MIT EINGABETASTATUR!
              color: Colors.grey[800],
              child: Column(
                children: <Widget>[
                  Text(
                    'INPUT',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text('Set threshold value:', style: textColor),
                      ),
                      Expanded(
                        child: TextField(
                          controller: ThresholdValueController,
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
                            hintText: "$ThresholdValue dB",
                            labelStyle: new TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (int.tryParse(ThresholdValueController.text) !=
                              null) {
                            if (int.tryParse(ThresholdValueController.text) <
                                0) {
                              setState(() {
                                //ACHTUNG WICHTIG! Die setState funktion triggert die build funktion des gesamten screens!
                                ThresholdValue = 0;
                              });
                            } else {
                              setState(() {
                                ThresholdValue =
                                    int.tryParse(ThresholdValueController.text);
                                // print('Threshold set to ' '$ThresholdValue' ' dB');
                              });
                            }
                          } else {
                            setState(() {
                              // default wert wenn zB ein buchstabe eingetippt wird
                              ThresholdValue = 20;
                            });
                          }
                          print('Threshold set to ' '$ThresholdValue' ' dB');
                          ThresholdValueController.clear();
                        },
                        child: Text('Set',
                            style: TextStyle(color: Colors.grey[800])),
                        color: Colors.green,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Set file name: ', style: textColor),
                      Expanded(
                        child: TextField(
                          controller: FileNameController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
//                            fillColor: Colors.grey[400],
//                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            hintText: recFilename + '.csv',
                            labelStyle: new TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      //Text('meas_1 '),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            if (FileNameController.text.isNotEmpty) {
                              if (FileNameController.text.contains('.') ||
                                  FileNameController.text.contains(',') ||
                                  FileNameController.text.contains('#') ||
                                  FileNameController.text.contains('-') ||
                                  FileNameController.text.contains('+')) {
                                //Das muss einfacher gehn um sonderzeichen in der benennung auszuschließen
                                recFilename = 'default';
                              } else {
                                recFilename = FileNameController.text;
                              }
                            } else {
                              recFilename = 'default';
                            }
                          });
                          print('Measurement name set to ' + recFilename);
                          FileNameController.clear();
                        },
                        child: Text(
                          'Set',
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              )),

          // --- Zeile 2: Icon button ------------------------------------------

          //IDEE ZUM BUTTON
          //Wenn man auf den IconButton drückt soll darunter in einem TextLabel
          // "RECORDING" bzw. "Bitte drücken Sie!" oder sowas stehen..
          // sodass man weiß, ob gerade aufgenommen wird.
          //vielleicht könnte man direkt unter dem "Start Measurement"-Container
          //noch einen Container einblenden, wo das Frequenzspekturm abgebildet wird? --> Schwierigkeit: next level?

          Container(
            decoration: containerBorder(),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  isRecording ? 'RECORDING...' : 'START MEASUREMENT',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                        width: 2,
                        color: isRecording ? Colors.redAccent : Colors.green),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _changeListening();
                      setState(() {});
                      /*setState(() {                                            // comment bitte
                        thresholdvalue += 1;
                        //code hier einfügen
                      });*/
                    },
                    icon: Icon(Icons.mic,
                        color: isRecording ? Colors.redAccent : Colors.green),
                    color: Colors.green,
                    iconSize: 100.0,
                  ),
                ),
                Text(
                  'Tap the mic icon to start/stop the measurement',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // --- Zeile 3: Output -----------------------------------------------
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              color: Colors.grey[800],
              child: Column(children: <Widget>[
                Text(
                  'OUTPUT',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    //color: Colors.cyanAccent[700],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text('Time:', style: textColor),
                      ),
                      Text(
                          isRecording && threshold
                              ? DateTime.now().difference(startTime).toString()
                              : "Not recording",
                          style: textColor),
                      Text(' s', style: textColor),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text('Average value:', style: textColor),
                      ),
                      Text(
                          isRecording && threshold
                              ? averageValue.toString()
                              : "Not recording",
                          style: textColor),
                      Text(' dB', style: textColor),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text('Max value:', style: textColor),
                      ),
                      Text(isRecording && threshold ? maxValue.toString() : "0",
                          style: textColor),
                      Text(' dB', style: textColor),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text('Min value:', style: textColor),
                      ),
                      Text(isRecording && threshold ? minValue.toString() : "0",
                          style: textColor),
                      Text(' dB', style: textColor),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text('Actual value:', style: textColor),
                      ),
                      Text(
                          isRecording && threshold
                              ? actualValue.toString()
                              : "0",
                          style: textColor),
                      Text(' dB', style: textColor),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: CustomPaint(
                              painter: WavePainter(
                                  currentSamples, _getBgColor(), context))),
                    ]

                    //CustomPaint(painter: WavePainter(currentSamples, _getBgColor(), context))

                    )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget myWidget() {
    return Container(
      margin: const EdgeInsets.all(30.0),
      padding: const EdgeInsets.all(10.0),
      decoration: containerBorder(),
    );
  }

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

class WavePainter extends CustomPainter {
  List<int> samples;
  List<Offset> points;
  Color color;
  BuildContext context;
  Size size;

  final int absMax =
      (AUDIO_FORMAT == AudioFormat.ENCODING_PCM_8BIT) ? 127 : 32767;

  WavePainter(this.samples, this.color, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = context.size;
    size = this.size;

    Paint paint = new Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    points = toPoints(samples);

    Path path = new Path();
    path.addPolygon(points, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldPainting) => true;

  List<Offset> toPoints(List<int> samples) {
    List<Offset> points = [];
    if (samples == null)
      samples =
          // List<int>.filled(size.width.toInt(), (0.5 * size.height).toInt());
          List<int>.filled(size.width.toInt(), (0.5 * size.height).toInt());

    for (int i = 0; i < min(size.width, samples.length).toInt(); i++) {
      points.add(
          new Offset(i.toDouble(), project(samples[i], absMax, size.height)));
    }
    return points;
  }

  double project(int val, int max, double height) {
    double waveHeight =
        (max == 0) ? val.toDouble() : (val / max) * 0.5 * height;
    // return waveHeight + 0.5 * height;
    return waveHeight +
        0.2 * height; //offset geändert kann man vl verbessern !!!
  }
}

// --- Backup code ----------------------------------------------------------
/*child: Image(),*/

/*CircleAvatar(
backgroundImage: AssetImage('asstes/thum.jpg'),
radius: 40.0,
),*/

/*Divider(
height: 60.0,
)*/

/*body: Center()*/

/*child: Icon(
          Icons.speaker,
          color: Colors.cyanAccent[700],
        ),'*/

/*child: Text(
          'Threshold value:',
          style: TextStyle(
            fontSize: 12.0,
            //fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.grey[800],
          ),
        ),*/

/*SizedBox(height: 30.0),*/

/*
floatingActionButton: FloatingActionButton(
child: Text('Start Measurement'),
backgroundColor: Colors.cyanAccent[700],
),*/

/*
child: RaisedButton.icon(
onPressed: () {
print('Measurement started');
},
icon: Icon(
Icons.adjust
),
label: Text('Start measurement'),
color: Colors.cyanAccent[700],
),*/

/*
child: IconButton(
onPressed: () {
print('Measurement started');
},
icon: Icon(Icons.adjust),
color: Colors.cyanAccent[700],
iconSize: 50.0,
)*/

/*body: Container(
padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
margin: EdgeInsets.all(0),
color: Colors.grey[700],
child: Text('Hello'),
),*/

/*body: Padding(
padding: EdgeInsets.all(10),
child: Text('Hello'),
),*/

/*      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: <Widget>[
          Text('Set threshold value:'),

          RaisedButton(
            onPressed: () {
              print('Threshold set');
            },
            child: Text('Set'),
            color: Colors.cyanAccent[700],
          ),
        ],
      ),*/
