import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:volley_scorebook/main.dart';
import 'package:volley_scorebook/page/pdf_view_page.dart';
import 'package:volley_scorebook/utils/BottomNavigationBarUtil.dart';
import 'package:volley_scorebook/utils/DataBaseUtil.dart';
import 'package:volley_scorebook/utils/GameNameTable.dart';
import 'package:volley_scorebook/utils/GamePlayerTable.dart';
import 'package:volley_scorebook/utils/GamePointTable.dart';
import 'package:volley_scorebook/utils/GamePositionTable.dart';
import 'package:volley_scorebook/utils/Grobal.dart';
import 'package:volley_scorebook/utils/PdfUtil.dart';

class GameScoreViewPage extends StatefulWidget {
  @override
  _GameScoreViewPageState createState() => _GameScoreViewPageState();
}

class _GameScoreViewPageState extends State<GameScoreViewPage> {
  List<GameNameTable> _listGameName = [];
  int dspGameScoreViewCount = 0;
  TextEditingController _controllerGameName = TextEditingController();

  Future<bool> initGameScoreViewPage() async {
    if (dspGameScoreViewCount == 0) {
      List<GameNameTable> listDataBase =
          await DataBaseUtil.selectGameNameTableAll();
      if (1 < listDataBase.length) {
        _listGameName.clear();
        for (int i = 1; i < listDataBase.length; i++) {
          _listGameName.add(listDataBase[i]);
        }
      }
    }
    dspGameScoreViewCount++;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initGameScoreViewPage(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text((languageJa) ? '試合履歴' : 'Match history'),
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: _listGameName.length,
                        itemBuilder: (BuildContext context, int i) {
                          return _disListGameResult(context, i);
                        }),
                  ),
                  AdmobBanner(
                    adUnitId: bannerAdUnitId,
                    adSize: AdmobBannerSize(
                      height: ((MediaQuery.of(context).size.height * 0.06).toInt() < 50) ? 50 : (MediaQuery.of(context).size.height * 0.06).toInt(),
                      width: MediaQuery.of(context).size.width.toInt(),
                      name: 'SMART_BANNER'
                    )),
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

  _disListGameResult(BuildContext context, int i) {
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
          title: Text(_listGameName[i].gameName),
          leading: Icon(Icons.picture_as_pdf),
          onTap: () async {
            List<GameNameTable> _resultSelectGameName =
                await DataBaseUtil.selectGameNameTableAll();
            List<GamePlayerTable> _resultSelectGamePlayer =
                await DataBaseUtil.selectGamePlayerTableAll(
                    _listGameName[i].gameId);
            List<GamePointTable> _resultSelectGamePoint =
                await DataBaseUtil.selectGamePointTableAll(
                    _listGameName[i].gameId);
            List<GamePositionTable> _resultSelectGamePosition =
                await DataBaseUtil.selectGamePositionTableAll(
                    _listGameName[i].gameId);
            String path = await PDF.createAndView(
                i + 1,
                _resultSelectGameName,
                _resultSelectGamePlayer,
                _resultSelectGamePoint,
                _resultSelectGamePosition);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PdfViewerPage(path: path)));
          },
          onLongPress: () async {
            _controllerGameName.text = _listGameName[i].gameName;
            int result = await showDialog<int>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text((languageJa) ? '試合名を変更しますか？' : 'Do you want to change the game name'),
                  content: Card(
                    color: Colors.transparent,
                    elevation: 0.0,
                    child: TextField(
                      inputFormatters: [LengthLimitingTextInputFormatter(100)],
                      maxLines: 1,
                      controller: _controllerGameName,
                      textAlign: TextAlign.left,
                      style: TextStyle(height: 1.5),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                          hintText: (languageJa) ? '試合名を入力してください' : 'Please enter a game name',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(1),
                    ),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text('Update'),
                      onPressed: () async {
                        await DataBaseUtil.updateGameNameGameName(
                            _listGameName[i].gameId, _controllerGameName.text);
                        dspGameScoreViewCount = 0;
                        currentPage = 0;
                        BottomNavigationBarPage();
                        selectPageKey.currentState.setState(() {});
                        currentPage = 1;
                        BottomNavigationBarPage();
                        selectPageKey.currentState.setState(() {});
                        Navigator.of(context).pop(1);
                      },
                    ),
                  ],
                );
              },
            );
            if(result == 1){
              setState(() {});
            }
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
                DataBaseUtil.deleteGameNameTable(_listGameName[i].gameId);
                DataBaseUtil.deleteGamePlayerTable(_listGameName[i].gameId);
                DataBaseUtil.deleteGamePointTable(_listGameName[i].gameId);
                DataBaseUtil.deleteGamePositionTable(_listGameName[i].gameId);
                _listGameName.removeAt(i);
                setState(() {});
              }
            })
      ],
    );
  }
}
