import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volley_scorebook/page/ManageTeamPage.dart';
import 'package:volley_scorebook/utils/DataBaseUtil.dart';
import 'package:volley_scorebook/utils/Grobal.dart';
import 'package:volley_scorebook/utils/PlayerTable.dart';

final editTeamPageKey = GlobalKey<_EditTeamPageState>();

class EditTeamPage extends StatefulWidget {
  final Mode pageMode;
  final int titleIndex;

  EditTeamPage(this.pageMode, [this.titleIndex]);

  @override
  _EditTeamPageState createState() => _EditTeamPageState();
}

class _EditTeamPageState extends State<EditTeamPage> {
  static final int _limitPlayerNum = 14;
  int initEditTeamPageCount = 0;
  int selectCount = 0;
  static List<int> listTeamId = [];
  static List<int> listPlayerId = [];
  static List<String> listPlayerNum = [];
  static List<String> listPlayerName = [];
  List<Map<String, List<dynamic>>> listMapTeamInfo = [];
  List<PlayerTable> listDataBase = [];

  static Map<String, List<dynamic>> mapPlayerInfo = {
    'teamId': listTeamId,
    'playerId': listPlayerId,
    'playerNum': listPlayerNum,
    'playerName': listPlayerName,
  };

  TextEditingController _controllerTeamName = TextEditingController();
  List<TextEditingController> _listControllerPlayerNum = List(_limitPlayerNum);
  List<TextEditingController> _listControllerPlayerName = List(_limitPlayerNum);

  @override
  void initState() {
    //選手情報の初期値の取得数をリセット
    selectCount = 0;
    //Controllerを初期化
    _controllerTeamName = TextEditingController();
    for (int i = 0; i < _limitPlayerNum; i++) {
      _listControllerPlayerNum[i] = TextEditingController();
      _listControllerPlayerName[i] = TextEditingController();
    }
    super.initState();
  }

  Future<bool> initEditTeamPage() async {
    //選手情報の初期値を設定
    if (widget.pageMode == Mode.edit) {
      if (selectCount == 0) {
        _controllerTeamName.text =
            manageTeamPageKey.currentState.listTeamName[widget.titleIndex];
        listDataBase = await DataBaseUtil.selectPlayerTablePlayerInfo(
            manageTeamPageKey.currentState.listTeamName[widget.titleIndex]);
        for (int i = 0; i < _limitPlayerNum; i++) {
          _listControllerPlayerNum[i].text = listDataBase[i].playerNum;
          _listControllerPlayerName[i].text = listDataBase[i].playerName;
        }
        selectCount++;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initEditTeamPage(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title:
                    Text((widget.pageMode == Mode.add) ? (languageJa) ? 'チーム新規追加' : 'Add new team' : (languageJa) ? 'チーム編集' : 'Edit team'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      _pushSave();
                    },
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _displayTextFieldTeamName(_controllerTeamName, (languageJa) ? 'チーム名(※必須)' : 'Team Name')
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: buildList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  //チーム名のTextFieldを表示
  Widget _displayTextFieldTeamName(_controller, _hintText) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: TextField(
        maxLines: 1,
        maxLength: 20,
        controller: _controller,
        style: TextStyle(height: 1),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
            hintText: _hintText,
            labelText: (languageJa) ? 'チーム名' : 'Team name',
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
      ),
    );
  }

  //選手情報の設定
  Widget _displayPlayerInfo(
      TextEditingController _controllerPlayerNum,
      TextEditingController _controllerPlayerName,
      int i) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //背番号のTextFieldを表示
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              width: 60,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: TextFormField(
                  inputFormatters: [LengthLimitingTextInputFormatter(3)],
                  maxLines: 1,
                  controller: _controllerPlayerNum,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  style: TextStyle(height: 1.5),
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                      hintText: (languageJa) ? '背番号' : 'Num',
                      labelText: (languageJa) ?'背番号' : 'Num',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: TextField(
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    maxLines: 1,
                    controller: _controllerPlayerName,
                    style: TextStyle(height: 1.5),
                    decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                        hintText: (languageJa) ? '選手名' : 'Player name',
                        labelText: (languageJa) ? '選手名' : 'Player name',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                )
                ,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //「背番号」「選手名」「ポジション」を表示
  List<Widget> buildList() {
    List<Widget> _list = [];
    for (int i = 0; i < _limitPlayerNum; i++) {
      _list.add(_displayPlayerInfo(_listControllerPlayerNum[i],
          _listControllerPlayerName[i], i));
    }
    return _list;
  }
  //選手情報をDBに登録
  void _pushSave() async {
    switch (_chkInput()) {
      case InputFormat.formatOK:
        await _savePlayerInfo();
        break;

      case InputFormat.duplicateTeamName:
        await _disCupertinoAlertDialog((languageJa) ? '既に登録しているチーム名は登録できません。' : 'The same team name cannot be registered.');
        break;

      case InputFormat.emptyTeamName:
        await _disCupertinoAlertDialog((languageJa) ? 'チーム名が空白です。' : 'Blank team name');
        break;

      case InputFormat.emptyPlayerNum:
        await _disCupertinoAlertDialog((languageJa) ? '背番号が入力されていない選手は登録できません。' : 'Players without a player number cannot be registered');
        break;

      case InputFormat.duplicatePlayerNum:
        await _disCupertinoAlertDialog((languageJa) ? '重複した背番号は登録できません。' : 'Duplicate player numbers cannot be registered');
        break;
    }
  }

  void _forInsertPlayerTable(
      List<Map<String, List<dynamic>>> listPlayer, String teamName) async {
    for (int i = 0; i < _limitPlayerNum; i++) {
      await DataBaseUtil.insertPlayerTablePlayerInfo(
          teamName,
          listPlayer[0]['teamId'][i],
          listPlayer[0]['playerId'][i],
          listPlayer[0]['playerNum'][i],
          listPlayer[0]['playerName'][i]);
    }
  }
  InputFormat _chkInput(){
    if(manageTeamPageKey.currentState.listTeamName.contains(_controllerTeamName.text)){
      if(widget.pageMode == Mode.edit && manageTeamPageKey.currentState.listTeamName[widget.titleIndex] == _controllerTeamName.text){
      }else{
        return InputFormat.duplicateTeamName;
      }
    }
    if(_controllerTeamName.text.isEmpty) {
      return InputFormat.emptyTeamName;
    }else{
      List<String> _listChkPlayerNum = [];
      _listControllerPlayerNum.forEach((TextEditingController _value) {
        _listChkPlayerNum.add(_value.text);
      });
      for(int i = 0; i < _listControllerPlayerNum.length; i++){
        if(_listControllerPlayerNum[i].text.isEmpty && _listControllerPlayerName[i].text.isNotEmpty){
          return InputFormat.emptyPlayerNum;
        }else if(_listChkPlayerNum.indexOf(_listControllerPlayerNum[i].text) != _listChkPlayerNum.lastIndexOf(_listControllerPlayerNum[i].text)){
          if(_listChkPlayerNum[i].isNotEmpty){
            return InputFormat.duplicatePlayerNum;
          }
        }
      }
    }
    return InputFormat.formatOK;
  }

  Future<void> _savePlayerInfo() async{
    mapPlayerInfo['teamId'] = [];
    mapPlayerInfo['playerId'] = [];
    mapPlayerInfo['playerNum'] = [];
    mapPlayerInfo['playerName'] = [];

    for (int i = 0; i < _limitPlayerNum; i++) {
      mapPlayerInfo['playerId'].add(i + 1);
      mapPlayerInfo['playerNum'].add(_listControllerPlayerNum[i].text);
      mapPlayerInfo['playerName'].add(_listControllerPlayerName[i].text);
    }
    if (widget.pageMode == Mode.edit) {
      //タイトルと選手情報を編集
      manageTeamPageKey.currentState.listTeamName[widget.titleIndex] =
          _controllerTeamName.text;
      listMapTeamInfo.add(mapPlayerInfo);
      for (int i = 0; i < _limitPlayerNum; i++) {
        mapPlayerInfo['teamId'].add(listDataBase[i].teamId);
        await DataBaseUtil.updatePlayerTablePlayerInfo(
            _controllerTeamName.text,
            listMapTeamInfo[0]['teamId'][i],
            listMapTeamInfo[0]['playerId'][i],
            listMapTeamInfo[0]['playerNum'][i],
            listMapTeamInfo[0]['playerName'][i]);
      }
      Navigator.of(context).pop();
    } else if (widget.pageMode == Mode.add) {
      //TeamIdを取得
      int getTeamId = await DataBaseUtil.selectPlayerTableMaxTeamId();
      for (int i = 0; i < _limitPlayerNum; i++) {
        mapPlayerInfo['teamId'].add(getTeamId);
      }
      //タイトルと選手情報を追加
      manageTeamPageKey.currentState.listTeamName
          .add(_controllerTeamName.text);
      listMapTeamInfo.add(mapPlayerInfo);
      _forInsertPlayerTable(
          listMapTeamInfo,
          manageTeamPageKey.currentState.listTeamName[
          manageTeamPageKey.currentState.listTeamName.length - 1]);
      Navigator.of(context).pop();
    }
  }
  Future<void> _disCupertinoAlertDialog(String message) async{
    await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text((languageJa) ? '入力エラー' : 'Input error'),
          content: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(message),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
