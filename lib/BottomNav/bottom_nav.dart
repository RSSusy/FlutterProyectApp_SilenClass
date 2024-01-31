// @dart = 2.3

import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key key, this.actualIndex}) : super(key: key);
  final Function actualIndex;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int numIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: numIndex,
      onTap: (int nIndex) {
        setState(() {
          numIndex = nIndex;
          widget.actualIndex(nIndex);
        });
      },
      items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
              semanticLabel: 'Home Button',
            ),
          ),
          BottomNavigationBarItem(
            label: 'Reportes',
            icon: Icon(Icons.assignment),
          ),
          BottomNavigationBarItem(
            label: 'Ajustes',
            icon: Icon(Icons.settings),
          ),
        ],
    );
  }
}
