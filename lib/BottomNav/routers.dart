// @dart = 2.3

import '../BottomNav/home.dart';
import '../BottomNav/reports.dart';
import 'package:flutter/material.dart';

class Routes extends StatelessWidget {
  const Routes({Key key, this.numIndex}) : super(key: key);
  final int numIndex;

  @override
  Widget build(BuildContext context) {
    List<Widget> pagesList = [
      HomePage(title: 'SilenClass',),
      ReportsPage(title: 'Reportes',),
      Container(),
    ];
    return pagesList[numIndex];
  }
}