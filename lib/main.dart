import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:volley_scorebook/page/GameScoreViewPage.dart';
import 'package:volley_scorebook/page/ManageTeamPage.dart';
import 'package:volley_scorebook/utils/DataBaseUtil.dart';
import 'package:volley_scorebook/utils/Grobal.dart';
import 'package:volley_scorebook/utils/SharedPreferences.dart';

final selectPageKey = GlobalKey<_SelectPageState>();
int currentPage = 0;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: iniApp(),
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Colors.blue,
              scaffoldBackgroundColor: Colors.grey.shade200,
              fontFamily: 'GenShinGothic',
            ),
            home: SelectPage(key: selectPageKey),
          );
        } else {
          return Container();
        }
      }
    );
  }

  Future<bool> iniApp() async {
    await DataBaseUtil.createTable();
    Admob.initialize(appId);
    await SharedPreferencesUtil.initialize();
    return true;
  }
}

class SelectPage extends StatefulWidget {
  SelectPage({Key key}) : super(key: key);
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  final pageList = [
    ManageTeamPage(key: manageTeamPageKey),
    GameScoreViewPage()
  ];
  @override
  Widget build(BuildContext context) {
    return pageList[currentPage];
  }
}


