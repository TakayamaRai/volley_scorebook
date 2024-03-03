import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:volley_scorebook/page/EditTeamPage.dart';
import 'package:volley_scorebook/page/GameSettingPage.dart';
import 'package:volley_scorebook/utils/BottomNavigationBarUtil.dart';
import 'package:volley_scorebook/utils/DataBaseUtil.dart';
import 'package:volley_scorebook/utils/Grobal.dart';
import 'package:volley_scorebook/utils/PlayerTable.dart';
import 'package:volley_scorebook/utils/SharedPreferences.dart';

final manageTeamPageKey = GlobalKey<_ManageTeamPageState>();

class ManageTeamPage extends StatefulWidget {
  ManageTeamPage({Key key}) : super(key: key);

  @override
  _ManageTeamPageState createState() => _ManageTeamPageState();
}

class _ManageTeamPageState extends State<ManageTeamPage> {
  List<String> listTeamName = [];
  int dspManageTeamCount = 0;

  Future<bool> initManageTeamPage() async {
    languageJa = SharedPreferencesUtil.loadBoolLanguageType();
    if (dspManageTeamCount == 0) {
      List<PlayerTable> listDataBase =
          await DataBaseUtil.selectPlayerTableTeamName();
      if (1 < listDataBase.length) {
        for (int i = 1; i < listDataBase.length; i++) {
          listTeamName.add(listDataBase[i].teamName);
        }
      }
    }
    dspManageTeamCount++;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initManageTeamPage(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text((languageJa) ? 'チーム管理' : 'Manage team'),
                leading: IconButton(
                  icon: Icon(Icons.g_translate,color: Colors.white,),
                  onPressed: ()async{
                    languageJa = !languageJa;
                    await SharedPreferencesUtil.saveBoolLanguageType(languageJa);
                    setState(() {});
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.group_add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditTeamPage(Mode.add)));
                    },
                  ),
                ],
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: listTeamName.length,
                        itemBuilder: (BuildContext context, int i) {
                          return _displayTeam(context, i);
                        }),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: FlatButton(
                      child: Text(
                        (languageJa) ? 'ゲーム作成' : 'Create game',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        if (listTeamName.length < 2) {
                          await showDialog<int>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text((languageJa) ? '登録エラー' : 'Registration error'),
                                content: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text((languageJa) ?'敵チームを含めて２チーム以上の登録が必要です。':'You need to register at least two teams including the enemy team.'),
                                ),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    child: Text('OK'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => GameSettingPage()));
                        }
                      },
                    ),
                  ),
//                  AdmobBanner(
//                    adUnitId: bannerAdUnitId,
//                    adSize: AdmobBannerSize(
//                        height: ((MediaQuery.of(context).size.height * 0.06).toInt() < 50) ? 50 : (MediaQuery.of(context).size.height * 0.06).toInt(),
//                        width: MediaQuery.of(context).size.width.toInt(),
//                        name: 'SMART_BANNER'
//                    ),
//                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBarPage(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
              ),
              body: Container(
                color:Theme.of(context).scaffoldBackgroundColor,
              ),
            );
          }
        });
  }

  Widget _displayTeam(BuildContext context, int i) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
        ),
        child: ListTile(
          title: Text(listTeamName[i]),
          leading: Icon(Icons.supervisor_account),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditTeamPage(Mode.edit, i)));
          },
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
            color: Colors.red,
            icon: IconData(59506, fontFamily: 'MaterialIcons'),
            onTap: () async {
              int result = await showDialog<int>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text((languageJa) ? '削除しますか？' : 'Delete?'),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text((languageJa) ? '削除すると復元できません。' : 'Deleted and cannot be restored'),
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(0),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text('Delete'),
                        onPressed: () => Navigator.of(context).pop(1),
                      ),
                    ],
                  );
                },
              );
              if (result == 1) {
                DataBaseUtil.deletePlayerTable(listTeamName[i]);
                listTeamName.removeAt(i);
                setState(() {});
              }
            })
      ],
    );
  }
}
