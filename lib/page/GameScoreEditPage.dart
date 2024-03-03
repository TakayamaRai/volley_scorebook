import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volley_scorebook/main.dart';
import 'package:volley_scorebook/utils/BottomNavigationBarUtil.dart';
import 'package:volley_scorebook/utils/DataBaseUtil.dart';
import 'package:volley_scorebook/utils/PlayerTable.dart';
import 'package:volley_scorebook/utils/Grobal.dart';

class GameScoreEditPage extends StatefulWidget {
  final String _myTeamName;
  final String _enemyTeamName;
  final Map<String,List<String>> listMapSettingMyPosition;
  final Map<String,List<String>> listMapSettingEnemyPosition;
  final List<PlayerTable> listMyTeamInfo;
  final List<PlayerTable> listEnemyTeamInfo;
  final int _setPoint;
  final bool _boolDeuce;
  final bool _boolSettingMyServe;
  GameScoreEditPage(this._myTeamName, this._enemyTeamName, this.listMyTeamInfo, this.listEnemyTeamInfo, this.listMapSettingMyPosition, this.listMapSettingEnemyPosition, this._setPoint, this._boolDeuce, this._boolSettingMyServe);

  @override
  _GameScoreEditPageState createState() => _GameScoreEditPageState();
}

class _GameScoreEditPageState extends State<GameScoreEditPage> {
  int _myPoint = 0;
  int _enemyPoint = 0;
  static int _limitPoint = 80;
  int _scoreInputCount = 0;
  bool _boolMyServe;
  bool _boolChangeCoat = false;
  TextEditingController _controllerGameName = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final int _crossAxisCount= 8; //スコアブックの表示項目数
  final double _childAspectRatio = 0.7;
  final int _flexPosition = 6;
  final int _flexScoreBook = 4;

  static List<String> _listMyServerNum = List.filled(_limitPoint, ' ');
  static List<String> _listMyPointSymbol = List.filled(_limitPoint, ' ');
  static List<String> _listMyPointType = List.filled(_limitPoint, ' ');
  static List<String> _listMyPlayerNum = List.filled(_limitPoint, ' ');
  static List<int> _listMyPoint =List.filled(_limitPoint, 0);
  static List<String> _listEnemyServerNum =List.filled(_limitPoint, ' ');
  static List<String> _listEnemyPointSymbol = List.filled(_limitPoint, ' ');
  static List<String> _listEnemyPointType = List.filled(_limitPoint, ' ');
  static List<String> _listEnemyPlayerNum = List.filled(_limitPoint, ' ');
  static List<int> _listEnemyPoint = List.filled(_limitPoint, 0);
  static Map<String,List<dynamic>> mapScoreInfo = {
    'myServerNum' : _listMyServerNum,
    'myPointSymbol' : _listMyPointSymbol,
    'myPointType' : _listMyPointType,
    'myPlayerNum' : _listMyPlayerNum,
    'myPoint' : _listMyPoint,
    'enemyServerNum' : _listEnemyServerNum,
    'enemyPointSymbol' : _listEnemyPointSymbol,
    'enemyPointType' : _listEnemyPointType,
    'enemyPlayerNum' : _listEnemyPlayerNum,
    'enemyPoint' : _listEnemyPoint,
  };
  static List<String> listPositionMyPlayerNum = List.filled(7, ' ');
  static List<String> listPositionMyPlayerName = List.filled(7, ' ');
  static List<String> listPositionEnemyPlayerNum = List.filled(7, ' ');
  static List<String> listPositionEnemyPlayerName = List.filled(7, ' ');
  Map<String,List<String>> listMapMyPosition ={
    'playerNum': listPositionMyPlayerNum,
    'playerName': listPositionMyPlayerName,
  };
  Map<String,List<String>> listMapEnemyPosition ={
    'playerNum': listPositionEnemyPlayerNum,
    'playerName': listPositionEnemyPlayerName,
  };

  @override
  void initState() {
    //広告のロード
    interstitialAd.load();
    //画面を縦に固定
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //変数初期化
    _boolMyServe = widget._boolSettingMyServe;
    _listMyServerNum = List.filled(_limitPoint, ' ');
    _listMyPointSymbol = List.filled(_limitPoint, ' ');
    _listMyPointType = List.filled(_limitPoint, ' ');
    _listMyPlayerNum = List.filled(_limitPoint, ' ');
    _listMyPoint = List.filled(_limitPoint, 0);
    _listEnemyServerNum =List.filled(_limitPoint, ' ');
    _listEnemyPointSymbol = List.filled(_limitPoint, ' ');
    _listEnemyPointType = List.filled(_limitPoint, ' ');
    _listEnemyPlayerNum = List.filled(_limitPoint, ' ');
    _listEnemyPoint = List.filled(_limitPoint, 0);
    mapScoreInfo = {
      'myServerNum' : _listMyServerNum,
      'myPointSymbol' : _listMyPointSymbol,
      'myPointType' : _listMyPointType,
      'myPlayerNum' : _listMyPlayerNum,
      'myPoint' : _listMyPoint,
      'enemyServerNum' : _listEnemyServerNum,
      'enemyPointSymbol' : _listEnemyPointSymbol,
      'enemyPointType' : _listEnemyPointType,
      'enemyPlayerNum' : _listEnemyPlayerNum,
      'enemyPoint' : _listEnemyPoint,
    };
    //試合設定画面の目玉が変わらないようにStringで受け取る
    for(int i = 0; i < widget.listMapSettingMyPosition['playerNum'].length; i++){
      listMapMyPosition['playerNum'][i] = widget.listMapSettingMyPosition['playerNum'][i];
      listMapEnemyPosition['playerNum'][i] = widget.listMapSettingEnemyPosition['playerNum'][i];
      listMapMyPosition['playerName'][i] = widget.listMapSettingMyPosition['playerName'][i];
      listMapEnemyPosition['playerName'][i] = widget.listMapSettingEnemyPosition['playerName'][i];
    }
    //試合名のデフォルト値取得
    _controllerGameName.text = DateTime.now().toString().substring(0,10) + ' ' + widget._myTeamName + ' VS ' + widget._enemyTeamName;
        super.initState();
  }
  //画面の固定を解除
  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text((_boolChangeCoat == true) ? '$_enemyPoint - $_myPoint':'$_myPoint - $_enemyPoint'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.swap_horiz),
              onPressed: (){
                _boolChangeCoat = !_boolChangeCoat;
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.restore),
              onPressed: () => _backScore()
            ),
          ],
        ),
        body: Column(
            children: <Widget>[
              //ポジション
              Expanded(
                flex: _flexPosition,
                child: Padding(
                  padding: const EdgeInsets.only(left : 8.0,right: 8.0,top: 2.0,bottom: 2.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.top,
                          children: [
                            //自のレフト
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                  )
                              ),
                              children: [
                                _disPosition(Position.backLeft.index,(_boolChangeCoat == true) ? SelectTeam.enemyTeam : SelectTeam.myTeam),
                                _disPosition(Position.frontLeft.index,(_boolChangeCoat == true) ? SelectTeam.enemyTeam : SelectTeam.myTeam),
                              ]
                            ),
                            //自のセンター
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    left: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                  )
                              ),
                              children: [
                                _disPosition(Position.backCenter.index,(_boolChangeCoat == true) ? SelectTeam.enemyTeam : SelectTeam.myTeam),
                                _disPosition(Position.frontCenter.index,(_boolChangeCoat == true) ? SelectTeam.enemyTeam : SelectTeam.myTeam),
                              ]
                            ),
                            //自のライト
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                  )
                              ),
                              children: [
                                _disPosition(Position.backRight.index,(_boolChangeCoat == true) ? SelectTeam.enemyTeam : SelectTeam.myTeam,_boolMyServe),
                                _disPosition(Position.frontRight.index,(_boolChangeCoat == true) ? SelectTeam.enemyTeam : SelectTeam.myTeam),
                              ]
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.top,
                          children: [
                            //敵のライト
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                  )
                              ),
                              children: [
                                _disPosition(Position.frontRight.index,(_boolChangeCoat == true) ? SelectTeam.myTeam : SelectTeam.enemyTeam),
                                _disPosition(Position.backRight.index,(_boolChangeCoat == true) ? SelectTeam.myTeam : SelectTeam.enemyTeam,_boolMyServe),
                              ]
                            ),
                            //敵のセンター
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    left: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                  )
                              ),
                              children: [
                                _disPosition(Position.frontCenter.index,(_boolChangeCoat == true) ? SelectTeam.myTeam : SelectTeam.enemyTeam),
                                _disPosition(Position.backCenter.index,(_boolChangeCoat == true) ? SelectTeam.myTeam : SelectTeam.enemyTeam),
                              ]
                            ),
                            //敵のレフト
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                  )
                              ),
                              children: [
                                _disPosition(Position.frontLeft.index,(_boolChangeCoat == true) ? SelectTeam.myTeam : SelectTeam.enemyTeam),
                                _disPosition(Position.backLeft.index,(_boolChangeCoat == true) ? SelectTeam.myTeam : SelectTeam.enemyTeam),
                              ]
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //スコアブック
              Expanded(
                flex: _flexScoreBook,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 1.0,top: 1.0),
                  child: Row(
                    children: <Widget>[
                     Column(
                        children: [
                          Expanded(child: _borderAllContainerTitle((languageJa) ? 'サーバー' : 'Server')),
                          Expanded(child: _borderAllContainerTitle((languageJa) ? '得点記号' : 'Symbol')),
                          Expanded(child: _borderAllContainerTitle((languageJa) ? '選手番号' : 'PlayerNum')),
                          Expanded(child: _borderAllContainerTitle((languageJa) ? '自　得点' : 'My Point')),
                          Expanded(child: _borderAllContainerTitle((languageJa) ? '敵　得点' : 'Ene Point')),
                          Expanded(child: _borderAllContainerTitle((languageJa) ? '選手番号' : 'PlayerNum')),
                          Expanded(child: _borderAllContainerTitle((languageJa) ? '得点記号' : 'Symbol')),
                          Expanded(child: _borderAllContainerTitle((languageJa) ? 'サーバー' : 'Server')),
                        ],
                      ),
                      Expanded(
                        child: GridView.count(
                          childAspectRatio: _childAspectRatio,
                          mainAxisSpacing: 0,
                          crossAxisCount: _crossAxisCount,
                          children: buildList(),
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
  //スコアブックの情報を表示
  List<Widget> buildList() {
    List<Widget> _list = [];
    for(int i = 0; i < _limitPoint; i++) {
      _list.add(_borderAllContainer(mapScoreInfo['myServerNum'][i], mapScoreInfo['myPointType'][i]));
      _list.add(_borderAllContainer(mapScoreInfo['myPointSymbol'][i], mapScoreInfo['myPointType'][i]));
      _list.add(_borderAllContainer(mapScoreInfo['myPlayerNum'][i], mapScoreInfo['myPointType'][i]));
      _list.add(_disPoint(mapScoreInfo['myPoint'][i], SelectTeam.myTeam));
      _list.add(_disPoint(mapScoreInfo['enemyPoint'][i], SelectTeam.enemyTeam));
      _list.add(_borderAllContainer(mapScoreInfo['enemyPlayerNum'][i], mapScoreInfo['enemyPointType'][i]));
      _list.add(_borderAllContainer(mapScoreInfo['enemyPointSymbol'][i], mapScoreInfo['enemyPointType'][i]));
      _list.add(_borderAllContainer(mapScoreInfo['enemyServerNum'][i], mapScoreInfo['enemyPointType'][i]));
    }
    return _list;
  }
  //Containerの全周を枠線で囲う
  Widget _borderAllContainer(String _value,String _pointType){
    return Container(
      decoration: BoxDecoration(
          color: (_pointType == 'Get') ? Colors.red.withOpacity(0.1) : (_pointType == 'Lost') ? Colors.blue.withOpacity(0.1) : Colors.white,
          border: Border.all(color: Colors.black45)
      ),
      child: Align(alignment: Alignment.center, child: Text(_value,style: TextStyle(fontSize: 13),)),
    );
  }
  //スコアブックのタイトルを表示
  Widget _borderAllContainerTitle(String _value){
    return Container(
      width: 75,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black45)
      ),
      child: Align(alignment: Alignment.center,child: Text(_value,style: TextStyle(fontSize: 13),)),
    );
  }
  //スコアブックの得点を表示
  Widget _disPoint(int _point, SelectTeam _selectTeam){
    return Container(
      decoration: BoxDecoration(
        color: (_point == 0) ? Colors.grey.withOpacity(0.5) : Colors.redAccent.withOpacity(0.5),
        shape: BoxShape.circle,
        border: Border.all(
          color: (_point == 0) ? Colors.grey : Colors.redAccent,
        )
      ),
      child: Align(alignment: Alignment.center, child:Text((_point == 0) ? " " : _point.toString())),
    );
  }
  //各ポジションの選手を表示
  Widget _disPosition(int _positionNum, SelectTeam _selectTeam, [bool _myServe]){
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: RaisedButton(
              child: Text((_selectTeam ==  SelectTeam.myTeam) ? listMapMyPosition['playerNum'][_positionNum] : listMapEnemyPosition['playerNum'][_positionNum]),
              color: (_myServe == true && _selectTeam == SelectTeam.myTeam) ? Colors.red :
              (_myServe == false && _selectTeam == SelectTeam.enemyTeam) ? Colors.red : Colors.white,
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
              onPressed: (){
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return _listBottomSheet(_positionNum, _selectTeam);
                  },
                );
              },
            ),
            onLongPress: (){
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return _listBottomSheetLong(_positionNum, _selectTeam);
                  });
            },
          ),
          Text(
            (_selectTeam ==  SelectTeam.myTeam) ? listMapMyPosition['playerName'][_positionNum] + '\n' : listMapEnemyPosition['playerName'][_positionNum] + '\n',
            style: TextStyle(
              color: Colors.grey,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
  //選手が押されたときにBottomSheetを表示
  Widget _listBottomSheet(int _positionNum, SelectTeam _selectTeam) {
    return ListView.builder(
      itemCount: PointName.listMap.length,
      itemBuilder: (BuildContext context, int i) {
        return _disPointBottomSheet(i, _positionNum, _selectTeam);
      }
    );
  }
  //BottomSheetの内容
  Widget _disPointBottomSheet(int i, int _positionNum, SelectTeam _selectTeam){
    var _padding = MediaQuery.of(context).padding;
    final double _height = MediaQuery.of(context).size.height -
        _padding.top - kToolbarHeight;
    final double _widthScreen = MediaQuery.of(context).size.width;
    // スクリーンの縦 * (スコアブックの高さ比) / スコアブックの項目数 / GridViewの高さと横の比
    final double _widthScoreBook = _height * (_flexScoreBook / (_flexPosition + _flexScoreBook)) / _crossAxisCount / _childAspectRatio;
    //ポジションごとに表示する項目を厳選
    String _pointName = '';
    if(_positionNum == Position.backRight.index){
      if(PointName.listMap[i]['position'] == 'server'){
        _pointName = PointName.listMap[i]['pointName'];
      }
    }
    if(_positionNum == Position.backRight.index || _positionNum == Position.backCenter.index || _positionNum == Position.backLeft.index){
      if(PointName.listMap[i]['position'] == 'back' || PointName.listMap[i]['position'] == 'all' ){
        _pointName = PointName.listMap[i]['pointName'];
      }
    }else if(_positionNum == Position.frontRight.index || _positionNum == Position.frontCenter.index || _positionNum == Position.frontLeft.index){
      if(PointName.listMap[i]['position'] == 'front' || PointName.listMap[i]['position'] == 'all' ){
        _pointName = PointName.listMap[i]['pointName'];
      }
    }
    if(_pointName == ''){
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        color: (PointName.listMap[i]['pointType'] == 'Get') ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: ListTile(
        title: Text(_pointName),
        onTap: () async{
          //サブ権があるチームにサーバーの背番号を入力
          if(_boolMyServe == true){
            mapScoreInfo['myServerNum'][_scoreInputCount] = listMapMyPosition['playerNum'][Position.backRight.index];
          }else if(_boolMyServe == false){
            mapScoreInfo['enemyServerNum'][_scoreInputCount] = listMapEnemyPosition['playerNum'][Position.backRight.index];
          }
          if(_selectTeam == SelectTeam.myTeam){
            mapScoreInfo['myPointSymbol'][_scoreInputCount] = PointName.listMap[i]['pointSymbol'];
            mapScoreInfo['myPointType'][_scoreInputCount] = PointName.listMap[i]['pointType'];
            mapScoreInfo['myPlayerNum'][_scoreInputCount] = listMapMyPosition['playerNum'][_positionNum];
            mapScoreInfo['enemyPlayerNum'][_scoreInputCount] = ' ';
            mapScoreInfo['enemyPointSymbol'][_scoreInputCount] = ' ';
            if(PointName.listMap[i]['pointType'] == 'Get'){
              _getPointMyTeam();
            }else if(PointName.listMap[i]['pointType'] == 'Lost'){
              _getPointEnemyTeam();
            }
          }
          else if(_selectTeam == SelectTeam.enemyTeam){
            mapScoreInfo['enemyPointSymbol'][_scoreInputCount] = PointName.listMap[i]['pointSymbol'];
            mapScoreInfo['enemyPointType'][_scoreInputCount] = PointName.listMap[i]['pointType'];
            mapScoreInfo['enemyPlayerNum'][_scoreInputCount] = listMapEnemyPosition['playerNum'][_positionNum];
            mapScoreInfo['myPlayerNum'][_scoreInputCount] = ' ';
            mapScoreInfo['myPointSymbol'][_scoreInputCount] = ' ';

            if(PointName.listMap[i]['pointType'] == 'Get'){
              _getPointEnemyTeam();
            }else if(PointName.listMap[i]['pointType'] == 'Lost'){
              _getPointMyTeam();
            }
          }
          _scoreInputCount++;
          //勝敗が決したときにダイアログを表示
          if(widget._setPoint <= _myPoint || widget._setPoint <= _enemyPoint){
            if(widget._boolDeuce == false || (widget._boolDeuce == true && 2 <= (_myPoint - _enemyPoint).abs())){
              setState(() {});
              int result = await showDialog<int>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text((_enemyPoint < _myPoint) ? (languageJa) ? widget._myTeamName + 'の勝ち' : widget._myTeamName + ' Win' : (languageJa) ? widget._enemyTeamName + 'の勝ち' :  widget._enemyTeamName + ' Win' ),
                    content: Card(
                      color: Colors.transparent,
                      elevation: 0.0,
                      child: Column(
                        children: <Widget>[
                          Text((languageJa) ? '試合結果を保存しますか？' : 'Do you want to save the match results?'),
                          TextField(
                            inputFormatters: [LengthLimitingTextInputFormatter(100)],
                            maxLines: 1,
                            controller: _controllerGameName,
                            textAlign: TextAlign.left,
                            style: TextStyle(height: 1.5),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left:6.0,right: 6.0,top:10.0),
                                hintText: (languageJa) ? '試合名を入力してください' : 'Please enter a match name',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(0),
                      ),
                      CupertinoDialogAction(
                        isDefaultAction:true,
                        child: Text('Save'),
                        onPressed: ()async{
                          await _saveGameInfo();
                          //GameScoreViewPageへ遷移
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            }
          }
          if(_widthScreen - _widthScoreBook * 2 <= _widthScoreBook * _scoreInputCount){
            _scrollController.jumpTo(_widthScoreBook * (_scoreInputCount + 1) - (_widthScreen - _widthScoreBook));
          }
          setState(() {});
          Navigator.of(context).pop();
        },
      ),
    );
  }
  void _getPointMyTeam(){
    _myPoint++;
    mapScoreInfo['myPoint'][_scoreInputCount] = _myPoint;
    mapScoreInfo['enemyPoint'][_scoreInputCount] = 0;
    //サーブ権が敵チームだった場合、自チームをローテーション
    if(_boolMyServe == false){
      _rotationMyTeam();
    }
    _boolMyServe = true;
  }
  void _getPointEnemyTeam(){
    _enemyPoint++;
    mapScoreInfo['enemyPoint'][_scoreInputCount] = _enemyPoint;
    mapScoreInfo['myPoint'][_scoreInputCount] = 0;
    //サーブ権が自チームだった場合、敵チームをローテーション
    if(_boolMyServe == true){
      _rotationEnemyTeam();
    }
    _boolMyServe = false;
  }
  void _rotationMyTeam(){
    listMapMyPosition['playerNum'].last = listMapMyPosition['playerNum'].first;
    listMapMyPosition['playerName'].last = listMapMyPosition['playerName'].first;
    for(int i = 1; i < listMapMyPosition['playerNum'].length; i++){
      listMapMyPosition['playerNum'][i - 1] = listMapMyPosition['playerNum'][i];
      listMapMyPosition['playerName'][i - 1] = listMapMyPosition['playerName'][i];
    }
  }
  void _rotationEnemyTeam(){
    listMapEnemyPosition['playerNum'].last = listMapEnemyPosition['playerNum'].first;
    listMapEnemyPosition['playerName'].last = listMapEnemyPosition['playerName'].first;
    for(int i = 1; i < listMapEnemyPosition['playerNum'].length; i++){
      listMapEnemyPosition['playerNum'][i - 1] = listMapEnemyPosition['playerNum'][i];
      listMapEnemyPosition['playerName'][i - 1] = listMapEnemyPosition['playerName'][i];
    }
  }
  //選手が長押しされたときにBottomSheetを表示
  Widget _listBottomSheetLong(int _positionNum, SelectTeam _selectTeam) {
    return ListView.builder(
        itemCount: (_selectTeam == SelectTeam.myTeam)
            ? widget.listMyTeamInfo.length
            : widget.listMyTeamInfo.length,
        itemBuilder: (BuildContext context, int i) {
          return _disPlayerInfo(i, _positionNum, _selectTeam);
        });
  }
  //選手が長押しされたときにBottomSheetを表示する内容
  Widget _disPlayerInfo(int i, int _positionNum, SelectTeam _selectTeam) {
    String playerNum = '';
    String playerName = '';
    //一度選択した選手はBottomSheetから除外
    if (_selectTeam == SelectTeam.myTeam) {
      if (listMapMyPosition['playerNum']
          .contains(widget.listMyTeamInfo[i].playerNum) == false) {
        playerNum = widget.listMyTeamInfo[i].playerNum;
        playerName = widget.listMyTeamInfo[i].playerName;
      }
    } else if (_selectTeam == SelectTeam.enemyTeam) {
      if (listMapEnemyPosition['playerNum']
          .contains(widget.listEnemyTeamInfo[i].playerNum) ==
          false) {
        playerNum = widget.listEnemyTeamInfo[i].playerNum;
        playerName = widget.listEnemyTeamInfo[i].playerName;
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
                    title: Text((languageJa) ? '入力エラー' : 'Inpot erro'),
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
                    title: Text((languageJa) ? '入力エラー' : 'Inpot erro'),
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
  Future<void>_saveGameInfo() async{
    interstitialAd.show();
    int gameId = await DataBaseUtil.selectGameNameTableMaxGameId();
    //ゲームID、試合名、自チーム名、敵チーム名の登録
    await DataBaseUtil.insertGameNameGameInfo(gameId, _controllerGameName.text, widget._myTeamName, widget._enemyTeamName);
    //ゲームID、自チームの選手登録
    for(int i = 0; i < widget.listMyTeamInfo.length; i++ ){
      await DataBaseUtil.insertGamePlayerPlayerInfo(gameId, widget._myTeamName, widget.listMyTeamInfo[i].playerNum, widget.listMyTeamInfo[i].playerName);
    }
    //ゲームID、敵チームの選手登録
    for(int i = 0; i < widget.listEnemyTeamInfo.length; i++ ){
      await DataBaseUtil.insertGamePlayerPlayerInfo(gameId, widget._enemyTeamName, widget.listEnemyTeamInfo[i].playerNum, widget.listEnemyTeamInfo[i].playerName);
    }
    //ゲームID、自チームのポジションを登録
    for(int i = 0; i < widget.listMapSettingMyPosition['playerNum'].length - 1; i++ ){
      await DataBaseUtil.insertGamePositionPlayerInfo(gameId, widget._myTeamName, (i+1).toString(), widget.listMapSettingMyPosition['playerNum'][i], widget.listMapSettingMyPosition['playerName'][i]);
    }
    //ゲームID、敵チームのポジションを登録
    for(int i = 0; i < widget.listMapSettingEnemyPosition['playerNum'].length - 1; i++ ){
      await DataBaseUtil.insertGamePositionPlayerInfo(gameId, widget._enemyTeamName, (i+1).toString(), widget.listMapSettingEnemyPosition['playerNum'][i], widget.listMapSettingEnemyPosition['playerName'][i]);
    }
    //スコアブックの情報を登録
    for(int i = 0; i < _scoreInputCount; i++ ){
      await DataBaseUtil.insertGamePointHistory(gameId, mapScoreInfo['myServerNum'][i], mapScoreInfo['myPointSymbol'][i],mapScoreInfo['myPointType'][i], mapScoreInfo['myPlayerNum'][i], mapScoreInfo['myPoint'][i], mapScoreInfo['enemyServerNum'][i], mapScoreInfo['enemyPointSymbol'][i], mapScoreInfo['enemyPointType'][i], mapScoreInfo['enemyPlayerNum'][i], mapScoreInfo['enemyPoint'][i]);
    }
  }
  Future<bool> _onWillPop() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text((languageJa) ? '前のページへ戻りますか？' : 'Return to previous page?'),
          content: Text((languageJa) ? '戻ると試合内容を保存できません。' : 'Unable to save match when returning'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop(true);
              }
            ),
          ],
        );
      },

    );
  }
  void _backScore() async{
    if(0 < _scoreInputCount){
      _scoreInputCount--;
      //サーブ権を戻す、ローテーションを戻す
      if(mapScoreInfo['myServerNum'][_scoreInputCount] != ' ' && mapScoreInfo['myPoint'][_scoreInputCount] == 0 && _boolMyServe == false){
        _boolMyServe = true;
        _rotationBackEnemyTeam();
      }else if(mapScoreInfo['enemyServerNum'][_scoreInputCount] != ' ' && mapScoreInfo['enemyPoint'][_scoreInputCount] == 0 && _boolMyServe == true){
        _boolMyServe = false;
        _rotationBackMyTeam();
      }
      //得点を戻す
      if(mapScoreInfo['myPoint'][_scoreInputCount] != 0){
        _myPoint--;
      }else if(mapScoreInfo['enemyPoint'][_scoreInputCount] != 0){
        _enemyPoint--;
      }
      //スコアブックの削除
      mapScoreInfo['myServerNum'][_scoreInputCount] = '';
      mapScoreInfo['myPointSymbol'][_scoreInputCount] = '';
      mapScoreInfo['myPointType'][_scoreInputCount] = '';
      mapScoreInfo['myPlayerNum'][_scoreInputCount] = '';
      mapScoreInfo['myPoint'][_scoreInputCount] = 0;
      mapScoreInfo['enemyPoint'][_scoreInputCount] = 0;
      mapScoreInfo['enemyPlayerNum'][_scoreInputCount] = '';
      mapScoreInfo['enemyPointSymbol'][_scoreInputCount] = '';
      mapScoreInfo['enemyPointType'][_scoreInputCount] = '';
      mapScoreInfo['enemyServerNum'][_scoreInputCount] = '';
      setState(() {});
    }else{
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text((languageJa) ? '得点を戻す' : 'Reclaim points'),
            content: Text((languageJa) ? '得点が０－０の時は戻せません。' : 'If the score is 0-0, it cannot be returned.'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  void _rotationBackMyTeam(){
    for(int i = listMapMyPosition['playerNum'].length - 1; i > 0; i--){
      listMapMyPosition['playerNum'][i] = listMapMyPosition['playerNum'][i - 1];
      listMapMyPosition['playerName'][i] = listMapMyPosition['playerName'][i - 1];
    }
    listMapMyPosition['playerNum'].first = listMapMyPosition['playerNum'].last;
    listMapMyPosition['playerName'].first = listMapMyPosition['playerName'].last;
  }
  void _rotationBackEnemyTeam(){
    for(int i = listMapEnemyPosition['playerNum'].length - 1 ; i > 0; i--){
      listMapEnemyPosition['playerNum'][i] = listMapEnemyPosition['playerNum'][i - 1];
      listMapEnemyPosition['playerName'][i] = listMapEnemyPosition['playerName'][i - 1];
    }
    listMapEnemyPosition['playerNum'].first = listMapEnemyPosition['playerNum'].last;
    listMapEnemyPosition['playerName'].first = listMapEnemyPosition['playerName'].last;
  }
}
