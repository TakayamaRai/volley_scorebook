import 'package:flutter/material.dart';
import 'package:volley_scorebook/main.dart';
import 'package:volley_scorebook/utils/Grobal.dart';

class BottomNavigationBarPage extends StatefulWidget {
  @override
  _BottomNavigationBarPageState createState() => _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  final _iconSize = 30.0;
  final _fontSize = 8.0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentPage,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,size: _iconSize,),
            title: Text((languageJa) ? 'チーム管理' : 'Manage team',style: TextStyle(fontSize: _fontSize),)
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.restore,size: _iconSize),
            title: Text((languageJa) ? '試合履歴' : 'Game history',style: TextStyle(fontSize: _fontSize))
        )
      ],
      onTap: (_pageIndex) {
        currentPage = _pageIndex;
        setState(() {});
        selectPageKey.currentState.setState(() {});
      }
    );
  }
}