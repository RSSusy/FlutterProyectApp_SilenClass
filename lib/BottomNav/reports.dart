// @dart = 2.3

import '../conf_page_mode.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
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
              //color: Color.fromARGB(255, 9, 98, 134),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 157, 217, 185),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromARGB(255, 157, 217, 185)
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                width: 400,
                height: 260,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 3),
                          FlSpot(2.6, 2),
                          FlSpot(4.9, 5),
                          FlSpot(6.8, 2.5),
                          FlSpot(8, 4),
                          FlSpot(9.5, 3),
                          FlSpot(10, 4),
                        ],
                        gradient: const LinearGradient(
                          colors: [
                            Colors.green,
                            Colors.yellow,
                            Colors.red,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.1, 0.6, 0.9],
                        ),
                        dotData: FlDotData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: bottomTitleWidgets,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
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
