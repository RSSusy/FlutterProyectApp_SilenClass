// @dart = 2.3

import 'dart:async';
import 'dart:convert' show utf8;
import '../conf_page_mode.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_blue/flutter_blue.dart';

const String serviceUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
const String characteristicUUIDrx = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
const String characteristicUUIDtx = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";

int pressMode = 0;
BluetoothDevice device;
bool isReady = false;
bool pressedUpload = false;

double sizeIconTop = 60;
Color colorModeClase = Color.fromARGB(255, 157, 217, 185);
Color colorModeExamen = Color.fromARGB(255, 157, 217, 185);
Color colorModeEquipo = Color.fromARGB(255, 157, 217, 185);

double dBverde = 64;
double dBambar = 70;

Color sinColor = Colors.green;
//Color cosColor = Colors.amber;
Color cosColor = Color.fromARGB(255, 170, 168, 57);
Color tanColor = Color.fromARGB(255, 200, 70, 70);
//Color tanColor = Colors.red;


class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile(
    {Key key,
      this.service,
      this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.isNotEmpty) {
      return Column(
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: const Text('Service'),
        subtitle:
        Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
      );
    }
  }
}

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;

  const CharacteristicTile(
      {Key key,
        this.characteristic,
        this.onReadPressed,
        this.onWritePressed,
        this.onNotificationPressed})
      : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: widget.characteristic.value,
      initialData: widget.characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        if (widget.characteristic.uuid.toString().toUpperCase().substring(4, 8) == characteristicUUIDrx.substring(4, 8)) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: sizeIconTop,
                    height: sizeIconTop,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          const BorderSide(
                              color: Color.fromARGB(255, 19, 113, 63),
                              width: 1.4,
                              style: BorderStyle.solid),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(colorModeClase),
                        shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder(),
                        ),
                      ),
                      child: const Icon(Icons.interpreter_mode),
                      onPressed: () {
                        (pressMode == 0 || pressMode == 1)
                          ? setState(() {
                              colorModeClase = Color.fromARGB(255, 19, 113, 63);
                              colorModeExamen = Color.fromARGB(255, 157, 217, 185);
                              colorModeEquipo = Color.fromARGB(255, 157, 217, 185);
                              dBverde = 64;
                              dBambar = 70;
                            })
                          : null;
                        widget.characteristic.write(utf8.encode('MODO CLASE'));
                        //widget.characteristic.write(utf8.encode('1'));
                        print('MODO CLASE');
                      },
                    ),
                  ),
                  const Text(
                    "Clase",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: sizeIconTop,
                    height: sizeIconTop,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          const BorderSide(
                              color: Color.fromARGB(255, 19, 113, 63),
                              width: 1.4,
                              style: BorderStyle.solid),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(colorModeExamen),
                        shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder(),
                        ),
                      ),
                      child: const Icon(Icons.pending_actions),
                      onPressed: () {
                        (pressMode == 0 || pressMode == 2)
                            ? setState(() {
                                colorModeClase = Color.fromARGB(255, 157, 217, 185);
                                colorModeExamen = Color.fromARGB(255, 19, 113, 63);
                                colorModeEquipo = Color.fromARGB(255, 157, 217, 185);
                                /*dBverde = 60;
                                dBambar = 62;*/
                                dBverde = 58;
                                dBambar = 62;
                              })
                            : null;
                        widget.characteristic.write(utf8.encode('MODO EXAMEN'));
                        //widget.characteristic.write(utf8.encode('2'));
                        print('MODO EXAMEN');
                      },
                    ),
                  ),
                  const Text(
                    "Examen",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: sizeIconTop,
                    height: sizeIconTop,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          const BorderSide(
                              color: Color.fromARGB(255, 19, 113, 63),
                              width: 1.4,
                              style: BorderStyle.solid),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(colorModeEquipo),
                        shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder(),
                        ),
                      ),
                      child: const Icon(Icons.groups),
                      onPressed: () {
                        (pressMode == 0 || pressMode == 3)
                            ? setState(() {
                                colorModeClase = Color.fromARGB(255, 157, 217, 185);
                                colorModeExamen = Color.fromARGB(255, 157, 217, 185);
                                colorModeEquipo = Color.fromARGB(255, 19, 113, 63);
                                dBverde = 68;
                                dBambar = 76;
                              })
                            : null;
                        widget.characteristic.write(utf8.encode('MODO TRABAJO EN EQUIPO'));
                        //widget.characteristic.write(utf8.encode('3'));
                        print('MODO TRABAJO EN EQUIPO');
                      },
                    ),
                  ),
                  const Text(
                    "Trabajo\nen equipo",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  int numIndex = 0;
  
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '07:00';
        break;
      case 1:
        text = '';
        //text = '08:00';
        break;
      case 2:
        text = '09:00';
        break;
      case 3:
        text = '';
        //text = '10:00';
        break;
      case 4:
        text = '11:00';
        break;
      case 5:
        text = '';
        //text = '12:00';
        break;
      case 6:
        text = '13:00';
        break;
      case 7:
        text = '';
        //text = '14:00';
        break;
      case 8:
        text = '15:00';
        break;
      case 9:
        text = '';
        //text = '16:00';
        break;
      case 10:
        text = '17:00';
        break;
      /*case 11:
        text = 'Dec';
        break;*/
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services.where((e) => e.uuid.toString().toUpperCase() == serviceUUID)
      .map((s) => ServiceTile(
        service: s,
        characteristicTiles: s.characteristics
          .map((c) => CharacteristicTile(
            characteristic: c,
            onWritePressed: () => c.uuid.toString().toUpperCase() == characteristicUUIDrx
              ? c.write(utf8.encode(pressMode.toString())) : null,
          ),
        ).toList(),
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 157, 217, 185),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: GestureDetector(
                          onTap: () async {
                            final BluetoothDevice connectDevice = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const FlutterBlueApp()));
                            setState(() {
                              colorModeClase = colorModeClase == Color.fromARGB(255, 157, 217, 185)
                                ? Color.fromARGB(255, 19, 113, 63)
                                : Color.fromARGB(255, 157, 217, 185);
                              isReady = true;
                              device = connectDevice;
                            });
                          },
                          child: const Icon(Icons.settings),
                        ),
                      ),
                    ],
                  ),
                  (isReady) ? StreamBuilder<List<BluetoothService>>(
                  //(isReady && device != null) ? StreamBuilder<List<BluetoothService>>(
                    stream: device.services,
                    initialData: const [],
                    builder: (c, snapshot) {
                      return Column(
                        children: _buildServiceTiles(snapshot.data),
                      );
                    },
                  ) : Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: sizeIconTop,
                                height: sizeIconTop,
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                      const BorderSide(
                                          color: Color.fromARGB(255, 19, 113, 63),
                                          width: 1.4,
                                          style: BorderStyle.solid),
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(colorModeClase),
                                    shape: MaterialStateProperty.all<CircleBorder>(
                                      const CircleBorder(),
                                    ),
                                  ),
                                  child: const Icon(Icons.interpreter_mode),
                                  onPressed: () {
                                    print('MODO CLASE');
                                  },
                                ),
                              ),
                              const Text(
                                "Clase",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: sizeIconTop,
                                height: sizeIconTop,
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                      const BorderSide(
                                          color: Color.fromARGB(255, 19, 113, 63),
                                          width: 1.4,
                                          style: BorderStyle.solid),
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(colorModeExamen),
                                    shape: MaterialStateProperty.all<CircleBorder>(
                                      const CircleBorder(),
                                    ),
                                  ),
                                  child: const Icon(Icons.pending_actions),
                                  onPressed: () {
                                    print('MODO EXAMEN');
                                  },
                                ),
                              ),
                              const Text(
                                "Examen",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: sizeIconTop,
                                height: sizeIconTop,
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                      const BorderSide(
                                          color: Color.fromARGB(255, 19, 113, 63),
                                          width: 1.4,
                                          style: BorderStyle.solid),
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(colorModeEquipo),
                                    shape: MaterialStateProperty.all<CircleBorder>(
                                      const CircleBorder(),
                                    ),
                                  ),
                                  child: const Icon(Icons.groups),
                                  onPressed: () {
                                    print('MODO TRABAJO EN EQUIPO');
                                  },
                                ),
                              ),
                              const Text(
                                "Trabajo\nen equipo",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // BORRAR PORQUE NO SE USA
                      /*(isReady && !pressedUpload) ? StreamBuilder<List<BluetoothService>>(
                        stream: device.services,
                        initialData: const [],
                        builder: (c, snapshot) {
                          return Column(
                            children: _buildServiceTiles(snapshot.data),
                          );
                        },
                      ) : Container(),*/
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,  // vertical: 4,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 157, 217, 185)
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child:
                  isReady ? SensorPage(device: device) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'Conecta un dispositivo',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      /*Text(
                        'x:',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'sin:',
                        style: TextStyle(
                          color: sinColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'cos:',
                        style: TextStyle(
                          color: cosColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'tan:',
                        style: TextStyle(
                          color: tanColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),*/
                      const SizedBox(
                        height: 12,
                      ),
                      AspectRatio(
                        aspectRatio: 1.5,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: LineChart(
                            LineChartData(
                              minY: 40,
                              maxY: 120,
                              minX: 0,
                              maxX: 50,
                              lineTouchData:  LineTouchData(enabled: false),
                              clipData:  FlClipData.all(),
                              gridData:  FlGridData(
                                show: true,
                                drawVerticalLine: false,
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  //spots: points,
                                  dotData:  FlDotData(
                                    show: false,
                                  ),
                                  color: sinColor,
                                  barWidth: 4,
                                ),
                              ],
                              titlesData:  FlTitlesData(
                                show: false,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
              ),
            ),
          ),
        ],
      ),
    );
    return scaffold;
  }
}

class SensorPage extends StatefulWidget {
  const SensorPage({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  SensorPageState createState() => SensorPageState();
}

class SensorPageState extends State<SensorPage> {
  final String serviceUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
  final String characteristicUUIDrx = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
  final String characteristicUUIDtx = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
  BluetoothCharacteristic rxCharacteristic;
  BluetoothCharacteristic txCharacteristic;
  bool isReady;
  Stream<List<int>> stream;
  List<double> traceDust = [];

  final limitCount = 50;
  final List<FlSpot> sinPoints = [];
  final List<FlSpot> cosPoints = [];
  final List<FlSpot> tanPoints = [];

  double xValue = 0;
  double step = 0.1;


  @override
  void initState() {
    super.initState();
    isReady = false;
    print('########### START ###########');
    print(widget.device);
    print('#############################');
    connectToDevice();
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData:  FlDotData(
        show: false,
      ),
      color: sinColor,
      barWidth: 4,
    );
  }

  LineChartBarData cosLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData:  FlDotData(
        show: false,
      ),
      color: cosColor,
      barWidth: 4,
    );
  }

  LineChartBarData tanLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData:  FlDotData(
        show: false,
      ),
      color: tanColor,
      barWidth: 4,
    );
  }

  connectToDevice() async {
    print('###### connectToDevice ######');
    print(widget.device);
    print('#############################');
    if (widget.device == null) {
      return;
    }

    Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      return;
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    for (var service in services) {
      if (service.uuid.toString().toUpperCase() == serviceUUID) {
        for (var characteristic in service.characteristics) {
          //if (characteristic.uuid.toString().toUpperCase() == characteristicUUIDrx || characteristic.uuid.toString().toUpperCase() == characteristicUUIDtx) {
            if (characteristic.uuid.toString().toUpperCase() == characteristicUUIDtx) {   // ADDED
              characteristic.setNotifyValue(!characteristic.isNotifying);
              stream = characteristic.value;
              txCharacteristic = characteristic;

              setState(() {
                isReady = true;
              });
            }
        }
      }
    }

    if (!isReady) {
    }
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  writeData(String data) async {
    if (rxCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    await rxCharacteristic.write(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            child: !isReady
                ? const Center(
                    child: Text(
                      "Waiting...",
                      style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 209, 70, 70)),
                    ),
                  )
                : Container(
                    child: StreamBuilder<List<int>>(
                      stream: stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<int>> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.active) {
                          var currentValue = _dataParser(snapshot.data);
                          if (sinPoints.length > limitCount*3) {
                            if (!sinPoints.getRange(sinPoints.length - (limitCount + 0), sinPoints.length).contains(FlSpot.nullSpot)) {
                              print('#####################');
                                print('DATA GRAPH WAS ERASE - SIN');
                                sinPoints.removeRange(0, sinPoints.length - (limitCount + 0));
                                cosPoints.removeRange(0, cosPoints.length);
                                tanPoints.removeRange(0, tanPoints.length);
                              print('#####################');
                            }
                          }
                          if (cosPoints.length > limitCount*3) {
                            if (!cosPoints.getRange(cosPoints.length - (limitCount + 0), cosPoints.length).contains(FlSpot.nullSpot)) {
                              print('#####################');
                              print('DATA GRAPH WAS ERASE - COS');
                              sinPoints.removeRange(0, sinPoints.length);
                              cosPoints.removeRange(0, cosPoints.length - (limitCount + 0));
                              tanPoints.removeRange(0, tanPoints.length);
                              print('#####################');
                            }
                          }
                          if (tanPoints.length > limitCount*3) {
                            if (!tanPoints.getRange(tanPoints.length - (limitCount + 0), tanPoints.length).contains(FlSpot.nullSpot)) {
                              print('#####################');
                              print('DATA GRAPH WAS ERASE - TAN');
                              sinPoints.removeRange(0, sinPoints.length);
                              cosPoints.removeRange(0, cosPoints.length);
                              tanPoints.removeRange(0, tanPoints.length - (limitCount + 0));
                              print('#####################');
                            }
                          }
                          
                          if ((double.tryParse(currentValue) ?? 0) <= dBverde) {
                            if (cosPoints.isNotEmpty ? !cosPoints.last.x.isNaN : false) {
                              sinPoints.removeLast();
                              sinPoints.add(cosPoints.last);
                            } else if (tanPoints.isNotEmpty ? !tanPoints.last.x.isNaN : false) {
                              sinPoints.removeLast();
                              sinPoints.add(tanPoints.last);
                            }
                            sinPoints.add(FlSpot(xValue, double.tryParse(currentValue) ?? 0));
                            cosPoints.add(FlSpot.nullSpot);
                            tanPoints.add(FlSpot.nullSpot);
                          } else if ((double.tryParse(currentValue) ?? 0) <= dBambar) {
                            if (sinPoints.isNotEmpty ? !sinPoints.last.x.isNaN : false) {
                              cosPoints.removeLast();
                              cosPoints.add(sinPoints.last);
                            } else if (tanPoints.isNotEmpty ? !tanPoints.last.x.isNaN : false) {
                              cosPoints.removeLast();
                              cosPoints.add(tanPoints.last);
                            }
                            sinPoints.add(FlSpot.nullSpot);
                            cosPoints.add(FlSpot(xValue, double.tryParse(currentValue) ?? 0));
                            tanPoints.add(FlSpot.nullSpot);
                          } else if ((double.tryParse(currentValue) ?? 0) > dBambar) {
                            if (sinPoints.isNotEmpty ? !sinPoints.last.x.isNaN : false) {
                              tanPoints.removeLast();
                              tanPoints.add(sinPoints.last);
                            } else if (cosPoints.isNotEmpty ? !cosPoints.last.x.isNaN : false) {
                              tanPoints.removeLast();
                              tanPoints.add(cosPoints.last);
                            }
                            sinPoints.add(FlSpot.nullSpot);
                            cosPoints.add(FlSpot.nullSpot);
                            tanPoints.add(FlSpot(xValue, double.tryParse(currentValue) ?? 0));
                          }
                          xValue += step;

                          return sinPoints.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 12),
                                Text(
                                  !sinPoints.last.y.isNaN
                                    ? '${sinPoints.last.y.toStringAsFixed(2)} dB'
                                    : !cosPoints.last.y.isNaN
                                      ? '${cosPoints.last.y.toStringAsFixed(2)} dB'
                                      : !tanPoints.last.y.isNaN
                                        ? '${tanPoints.last.y.toStringAsFixed(2)} dB'
                                        : null,
                                  style: TextStyle(
                                    color: !sinPoints.last.y.isNaN
                                    ? sinColor
                                    : !cosPoints.last.y.isNaN
                                      ? cosColor
                                      : !tanPoints.last.y.isNaN
                                        ? tanColor
                                        : Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                /*Text(
                                  'x: ${xValue.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'sin: ${sinPoints.last.y.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: sinColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'cos: ${cosPoints.last.y.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: cosColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'tan: ${tanPoints.last.y.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: tanColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),*/
                                const SizedBox(
                                  height: 12,
                                ),
                                AspectRatio(
                                  aspectRatio: 1.5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 24.0),
                                    child: LineChart(
                                      LineChartData(
                                        minY: 40,
                                        maxY: 120,
                                        minX: (xValue - (limitCount*step)),
                                        maxX: xValue,
                                        lineTouchData:  LineTouchData(enabled: false),
                                        clipData:  FlClipData.all(),
                                        gridData:  FlGridData(
                                          show: true,
                                          drawVerticalLine: false,
                                        ),
                                        borderData: FlBorderData(show: false),
                                        lineBarsData: [
                                          sinLine(sinPoints),
                                          cosLine(cosPoints),
                                          tanLine(tanPoints),
                                        ],
                                        titlesData:  FlTitlesData(
                                          show: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Container();
                        } else {
                          return const Text('Check the stream');
                        }
                      },
                    ),
                  ));
  }
}