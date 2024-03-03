import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volley_scorebook/page/GameScoreEditPage.dart';
import 'package:volley_scorebook/page/ManageTeamPage.dart';
import 'package:volley_scorebook/utils/DataBaseUtil.dart';
import 'package:volley_scorebook/utils/PlayerTable.dart';
import 'package:volley_scorebook/utils/Grobal.dart';

class GameSettingPage extends StatefulWidget {
  @override
  _GameSettingPageState createState() => _GameSettingPageState();
}

class _GameSettingPageState extends State<GameSettingPage> {
  int test = 0;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<String> _listDropdownValue = List(2);
  List<PlayerTable> listMyTeamInfo = [];
  List<PlayerTable> listEnemyTeamInfo = [];
  static List<String> listPositionMyPlayerNum = List.filled(7, ' ');
  static List<String> listPositionMyPlayerName = List.filled(7, ' ');
  static List<String> listPositionEnemyPlayerNum = List.filled(7, ' ');
  static List<String> listPositionEnemyPlayerName = List.filled(7, ' ');

  Map<String, List<String>> listMapMyPosition = {
    'playerNum': listPositionMyPlayerNum,
    'playerName': listPositionMyPlayerName,
  };
  Map<String, List<String>> listMapEnemyPosition = {
    'playerNum': listPositionEnemyPlayerNum,
    'playerName': listPositionEnemyPlayerName,
  };

  TextEditingController _controller = TextEditingController(text: '25');
  bool _switchDeuceValue = true;
  bool _switchMyServe = true;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _listDropdownValue[SelectTeam.myTeam.index] =
        manageTeamPageKey.currentState.listTeamName[0];
    _listDropdownValue[SelectTeam.enemyTeam.index] =
        manageTeamPageKey.currentState.listTeamName[1];
    listPositionMyPlayerNum = List.filled(7, ' ');
    listPositionMyPlayerName = List.filled(7, ' ');
    listPositionEnemyPlayerNum = List.filled(7, ' ');
    listPositionEnemyPlayerName = List.filled(7, ' ');
    super.initState();
  }

  Future<bool> initGameSettingPage() async {
    listMyTeamInfo = await DataBaseUtil.selectPlayerTablePlayerInfo(
        _listDropdownValue[SelectTeam.myTeam.index]);
    listEnemyTeamInfo = await DataBaseUtil.selectPlayerTablePlayerInfo(
        _listDropdownValue[SelectTeam.enemyTeam.index]);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initGameSettingPage(),
        builder: (context, AsyncSnapshot snapshot) {
          // スクリーンの高さと幅を取得
          var _padding = MediaQuery.of(context).padding;
          final double _height = MediaQuery.of(context).size.height -
              _padding.top -
              kToolbarHeight;
          final double _containerHeight = _height / 12;

          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text((languageJa) ? '試合設定' : 'Setting match'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: _containerHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.withOpacity(0.2)),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text((languageJa) ? '  セットポイント' : '  SetPoint'),
                          Container(
                            width: _containerHeight,
                              child:GestureDetector(
                                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                                child: TextField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(2)
                                  ],
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  style: TextStyle(height: 1),
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 6.0, right: 6.0, top: 10.0),
                                  ),
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: _containerHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.withOpacity(0.2)),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text((languageJa) ? '  デュース有' : '  Deuce'),
                          Switch(
                            value: _switchDeuceValue,
                            onChanged: (bool value) {
                              setState(() {
                                _switchDeuceValue = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: _containerHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.withOpacity(0.2)),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text((languageJa) ? '  自チームサーブ権' : 'Have a serve right'),
                          Switch(
                            value: _switchMyServe,
                            onChanged: (bool value) {
                              setState(() {
                                _switchMyServe = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: _displayTeamCommBo(SelectTeam.myTeam,
                                _listDropdownValue[SelectTeam.myTeam.index]),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: _displayTeamCommBo(SelectTeam.enemyTeam,
                                _listDropdownValue[SelectTeam.enemyTeam.index]),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black45)),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      _positionTitle('Ⅳ'),
                                      _positionTitle('Ⅲ'),
                                      _positionTitle('Ⅱ'),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _positionInfo(Position.frontLeft.index,
                                          SelectTeam.myTeam),
                                      _positionInfo(Position.frontCenter.index,
                                          SelectTeam.myTeam),
                                      _positionInfo(Position.frontRight.index,
                                          SelectTeam.myTeam),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _positionTitle('Ⅴ'),
                                      _positionTitle('Ⅵ'),
                                      _positionTitle('Ⅰ'),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _positionInfo(Position.backLeft.index,
                                          SelectTeam.myTeam),
                                      _positionInfo(Position.backCenter.index,
                                          SelectTeam.myTeam),
                                      _positionInfo(Position.backRight.index,
                                          SelectTeam.myTeam),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black45)),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      _positionTitle('Ⅳ'),
                                      _positionTitle('Ⅲ'),
                                      _positionTitle('Ⅱ'),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _positionInfo(Position.frontLeft.index,
                                          SelectTeam.enemyTeam),
                                      _positionInfo(Position.frontCenter.index,
                                          SelectTeam.enemyTeam),
                                      _positionInfo(Position.frontRight.index,
                                          SelectTeam.enemyTeam),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _positionTitle('Ⅴ'),
                                      _positionTitle('Ⅵ'),
                                      _positionTitle('Ⅰ'),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _positionInfo(Position.backLeft.index,
                                          SelectTeam.enemyTeam),
                                      _positionInfo(Position.backCenter.index,
                                          SelectTeam.enemyTeam),
                                      _positionInfo(Position.backRight.index,
                                          SelectTeam.enemyTeam),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width -50,
                          child: FlatButton(
                            child: Text(
                              (languageJa) ? '設定完了' : 'Setting completed',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              if (_chkPositionEmpty(SelectTeam.myTeam)) {
                                if (_chkPositionEmpty(SelectTeam.enemyTeam)) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GameScoreEditPage(
                                                  _listDropdownValue[0],
                                                  _listDropdownValue[1],
                                                  listMyTeamInfo,
                                                  listEnemyTeamInfo,
                                                  listMapMyPosition,
                                                  listMapEnemyPosition,
                                                  int.parse(_controller.text),
                                                  _switchDeuceValue,
                                                  _switchMyServe)));
                                } else {
                                  await showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: Text((languageJa) ? '入力エラー' : 'Input Erro'),
                                        content: Text((languageJa) ? '敵チームのポジションを埋めてください。' : 'Set the position of the enemy team'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('OK'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {
                                await showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text((languageJa) ? '入力エラー' : 'Input Erro'),
                                      content: Text((languageJa) ? '自チームのポジションを埋めてください。': 'Set the position of the my team'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  //ポジションのコンボボックス値を設定
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> comboItems = List();
    comboItems.add(DropdownMenuItem(value: ' ', child: Text(' ')));
    for (String playerInfo in manageTeamPageKey.currentState.listTeamName) {
      comboItems
          .add(DropdownMenuItem(value: playerInfo, child: Text(playerInfo)));
    }
    return comboItems;
  }

//チーム名のコンボボックス
  Widget _displayTeamCommBo(SelectTeam _selectTeam, String _dropdownValue) {
    return Padding(
      padding: const EdgeInsets.only(left: 1.0, top: 8.0, right: 1.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: DropdownButton<String>(
          elevation: 1,
          value: _dropdownValue,
          icon: Icon(Icons.expand_more),
          hint: Text(
            (languageJa) ? 'チーム選択' : 'Select Team',
            style: TextStyle(color: Colors.grey),
          ),
          isExpanded: true,
          underline: Container(
            color: Colors.black,
            height: 1,
          ),
          style: TextStyle(height: 1, color: Colors.black),
          onChanged: (String newValue) async {
            //同じチームを選択できないようにチェック
            if (_listDropdownValue.contains(newValue) &&
                _listDropdownValue[_selectTeam.index] != newValue) {
              await showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text((languageJa) ? '入力エラー' : 'Input Erro'),
                    content: Text((languageJa) ? '同じチームは選択できません' : 'Same team cannot be selected'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                },
              );
            } else if (_listDropdownValue[_selectTeam.index] != newValue) {
              _listDropdownValue[_selectTeam.index] = newValue;
              if (_selectTeam == SelectTeam.myTeam) {
                listMapMyPosition['playerNum'] = List.filled(7, ' ');
                listMapMyPosition['playerName'] = List.filled(7, ' ');
              } else if (_selectTeam == SelectTeam.enemyTeam) {
                listMapEnemyPosition['playerNum'] = List.filled(7, ' ');
                listMapEnemyPosition['playerName'] = List.filled(7, ' ');
              }
              setState(() {});
            }
          },
          items: _dropDownMenuItems,
        ),
      ),
    );
  }

  //ポジションのタイトル
  Widget _positionTitle(String title) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: Colors.black45)),
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  //ポジションの情報
  Widget _positionInfo(int _positionNum, SelectTeam _selectTeam) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: Colors.black45)),
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text((_selectTeam == SelectTeam.myTeam)
                  ? listMapMyPosition['playerNum'][_positionNum]
                  : listMapEnemyPosition['playerNum'][_positionNum]),
              color: Colors.white,
              shape: CircleBorder(
                side: BorderSide(color: Colors.black, style: BorderStyle.solid),
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return _listBottomSheet(_positionNum, _selectTeam);
                    });
              },
            ),
            Text(
              (_selectTeam == SelectTeam.myTeam)
                  ? listMapMyPosition['playerName'][_positionNum] + '\n'
                  : listMapEnemyPosition['playerName'][_positionNum] + '\n',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 9,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _listBottomSheet(int _positionNum, SelectTeam _selectTeam) {
    return ListView.builder(
        itemCount: (_selectTeam == SelectTeam.myTeam)
            ? listMyTeamInfo.length
            : listMyTeamInfo.length,
        itemBuilder: (BuildContext context, int i) {
          return _disPlayerInfo(i, _positionNum, _selectTeam);
        });
  }

//目玉選択時にBottomSheetを表示
  Widget _disPlayerInfo(int i, int _positionNum, SelectTeam _selectTeam) {
    String playerNum = '';
    String playerName = '';
    //一度選択した選手はBottomSheetから除外
    if (_selectTeam == SelectTeam.myTeam) {
      if (listMapMyPosition['playerNum']
              .contains(listMyTeamInfo[i].playerNum) == false) {
        playerNum = listMyTeamInfo[i].playerNum;
        playerName = listMyTeamInfo[i].playerName;
      }
    } else if (_selectTeam == SelectTeam.enemyTeam) {
      if (listMapEnemyPosition['playerNum']
              .contains(listEnemyTeamInfo[i].playerNum) ==
          false) {
        playerNum = listEnemyTeamInfo[i].playerNum;
        playerName = listEnemyTeamInfo[i].playerName;
      }
    }
    if (playerNum == '' && playerName == '') {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: ListTile(
        title: Text('$playerNum : $playerName'),
        onTap: () async {
          //同じ選手は入力できないようにチェック
          if (_selectTeam == SelectTeam.myTeam) {
            if (listMapMyPosition['playerNum'].contains(playerNum) &&
                listMapMyPosition['playerNum'][_positionNum] != playerNum) {
              await showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text((languageJa) ? '入力エラー' : 'Input Erro'),
                    content: Text((languageJa) ? '同じ選手は選択できません' : 'Same team cannot be selected'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                },
              );
            } else {
              listMapMyPosition['playerNum'][_positionNum] = playerNum;
              listMapMyPosition['playerName'][_positionNum] = playerName;
            }
          } else if (_selectTeam == SelectTeam.enemyTeam) {
            if (listMapEnemyPosition['playerNum'].contains(playerNum) &&
                listMapEnemyPosition['playerNum'][_positionNum] != playerNum) {
              await showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text((languageJa) ? '入力エラー' : 'Inpot Erro'),
                    content: Text((languageJa) ? '同じ選手は選択できません' : 'Same team cannot be selected'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                },
              );
            } else {
              listMapEnemyPosition['playerNum'][_positionNum] = playerNum;
              listMapEnemyPosition['playerName'][_positionNum] = playerName;
            }
          }
          setState(() {});
          Navigator.of(context).pop();
        },
      ),
    );
  }

  bool _chkPositionEmpty(SelectTeam _selectTeam) {
    bool result = true;
    if (_selectTeam == SelectTeam.myTeam) {
      for (int i = 0; i < 6; i++) {
        result &= listMapMyPosition['playerNum'][i] != ' ';
      }
    } else if (_selectTeam == SelectTeam.enemyTeam) {
      for (int i = 0; i < 6; i++) {
        result &= listMapEnemyPosition['playerNum'][i] != ' ';
      }
    }
    return result;
  }
}
