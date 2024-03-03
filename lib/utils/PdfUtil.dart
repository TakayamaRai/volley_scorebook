import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:volley_scorebook/utils/GameNameTable.dart';
import 'package:volley_scorebook/utils/GamePlayerTable.dart';
import 'package:volley_scorebook/utils/GamePointTable.dart';
import 'package:volley_scorebook/utils/GamePositionTable.dart';
import 'package:volley_scorebook/utils/Grobal.dart';

class PDF{
  static int disScoreCount = 0;
  static final double heightScore = 15.0;
  static final double weightScore = 20.0;
  static final double heightPlayer = 16.0;
  static final double weightPlayerNum = 20.0;
  static final double weightPlayerName = 75.0;
  static final double weightGameDetail = 50.0;
  static final double weightPlayerDetail = 10.0;
  static final double weightPlayerTitle = weightPlayerNum + weightPlayerName;
  static final double defFontSize = 7.0;

  static Future<String> createAndView(int gameId, List<GameNameTable> _selectGameName, List<GamePlayerTable> _selectGamePlayer, List<GamePointTable> _selectGamePoint, List<GamePositionTable> _selectGamePosition) async{
    final String myTeamName = _selectGameName[gameId].myTeamName;
    final String enemyTeamName = _selectGameName[gameId].enemyTeamName;
    disScoreCount = 0;
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final font = await rootBundle.load("fonts/GenShinGothic-Light.ttf");
    final ttf = Font.ttf(font);
    final Document pdf = Document();
    List<List<String>> gamePlayerData = List.generate(_selectGamePlayer.length, (i)=>[]);
    for(int i=0; i<_selectGamePlayer.length; i++){
      gamePlayerData[i].add(_selectGamePlayer[i].teamName);
      gamePlayerData[i].add(_selectGamePlayer[i].playerNum);
      gamePlayerData[i].add(_selectGamePlayer[i].playerName);
    }

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          decoration: const BoxDecoration(
            border: BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)
          ),
          child: Text(_selectGameName[gameId].gameName,
              style: TextStyle(font:ttf)
          )
        );
      },
      footer: (Context context) {
        return Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
              style: TextStyle(font: ttf).copyWith(color: PdfColors.grey)
          )
        );
      },
      build: (Context context) => <Widget>[
        Header(
          level: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(_selectGameName[gameId].gameName, textScaleFactor: 1.5, style: TextStyle(font: ttf)),
              PdfLogo()
            ]
          )
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Header(level: 1, text: (languageJa) ? 'スコアブック(前半)' : 'Scorebook(first half)', textStyle: TextStyle(font:ttf).copyWith(color: PdfColors.black)),
                  Table(
                      children: tableRowListScore(_selectGamePoint, ttf)
                  ),
                ]
              )
            ),
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                    children: [
                      Header(level: 1, text: (languageJa) ? 'スコアブック(後半)' : 'Scorebook(second half)', textStyle: TextStyle(font:ttf).copyWith(color: PdfColors.black)),
                      Table(
                          children: tableRowListScore(_selectGamePoint, ttf)
                      ),
                    ]
                )
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Header(level: 1, text: (languageJa) ? 'ベンチメンバー' : 'Member', textStyle: TextStyle(font:ttf).copyWith(color: PdfColors.black)),
                  Table(
                      border: TableBorder(color: PdfColors.black),
                      children: [
                        TableRow(
                          children: [
                            Container(width: weightPlayerTitle,child: Padding(padding: const EdgeInsets.all(2.0), child: Align(alignment: Alignment.center, child:Text((languageJa) ? '自チーム' : 'My Team',style: TextStyle(fontSize: defFontSize + 2,font: ttf))))),
                            Container(width: weightPlayerTitle,child: Padding(padding: const EdgeInsets.all(2.0), child: Align(alignment: Alignment.center, child:Text((languageJa) ? '敵チーム' : 'Enemy Team',style: TextStyle(fontSize: defFontSize + 2,font: ttf))))),
                          ]
                        )
                      ]
                  ),
                  Table(
                      border: TableBorder(color: PdfColors.black),
                      children: tableRowListPlayerInfo(_selectGamePlayer, myTeamName, enemyTeamName, ttf)
                  ),
                  Paragraph(text: ''),
                  Header(level: 1, text: (languageJa) ? 'スターティングメンバー' : 'Starting member', textStyle: TextStyle(font:ttf).copyWith(color: PdfColors.black)),
                  _disPosition(_selectGamePosition, myTeamName, enemyTeamName, ttf),

                  Paragraph(text: ''),
                  Header(level: 1, text: (languageJa) ? 'スコア記号' : 'Score symbol', textStyle: TextStyle(font:ttf).copyWith(color: PdfColors.black)),
                  Table(
                      border: TableBorder(color: PdfColors.black),
                      children: _tableRowScoreSymbol(ttf),
                  ),
                ]
              ),
            ),
          ]
        ),
        Header(level: 1, text: (languageJa) ? '点数内訳' : 'Breakdown of points', textStyle: TextStyle(font:ttf).copyWith(color: PdfColors.black)),
        Row(children: [
          Table(
            border: TableBorder(color: PdfColors.black),
            children: _tableRowGameDetail(_selectGamePoint, ttf),
          ),
          Container(width: 100),
        ]),
        Paragraph(text: ''),
        Header(level: 1, text: (languageJa) ? '選手評価(自チーム)' : 'Breakdown of Player(My Team)', textStyle: TextStyle(font:ttf).copyWith(color: PdfColors.black)),
        Table(
          border: TableBorder(color: PdfColors.black),
          children: _tableRowPlayerDetail(_selectGamePoint, _selectGamePlayer, myTeamName, SelectTeam.myTeam, ttf),
        ),
        Paragraph(text: ''),
        Header(level: 1, text: (languageJa) ? '選手評価(敵チーム)' : 'Breakdown of Player(Enemy Team)', textStyle: TextStyle(font:ttf).copyWith(color: PdfColors.black)),
        Table(
          border: TableBorder(color: PdfColors.black),
          children: _tableRowPlayerDetail(_selectGamePoint, _selectGamePlayer, enemyTeamName, SelectTeam.enemyTeam, ttf),
        ),
      ]
    ));
    final String path = '$dir/baseball_teams.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    return path;
  }

//ベンチメンバーの表示　列の要素をList<String>に再分配してからわたす
  static List<TableRow> tableRowListPlayerInfo(List<GamePlayerTable> _selectGamePlayer, String myTeamName, String enemyTeamName, ttf){
    List<TableRow> _list = [];
    List<String> listMyPlayerNum = [];
    List<String> listMyPlayerName = [];
    List<String> listEnemyPlayerNum = [];
    List<String> listEnemyPlayerName = [];

    for(int i = 0; i < _selectGamePlayer.length; i++) {
      if(_selectGamePlayer[i].teamName == myTeamName){
        listMyPlayerNum.add(_selectGamePlayer[i].playerNum);
        listMyPlayerName.add(_selectGamePlayer[i].playerName);
      }else if(_selectGamePlayer[i].teamName == enemyTeamName){
        listEnemyPlayerNum.add(_selectGamePlayer[i].playerNum);
        listEnemyPlayerName.add(_selectGamePlayer[i].playerName);
      }
    }
    for(int i = 0; i < listMyPlayerNum.length; i++) {
      _list.add(TableRow(children: buildListMyPlayerNum(listMyPlayerNum[i], listMyPlayerName[i], listEnemyPlayerNum[i], listEnemyPlayerName[i], ttf)));
    }
    return _list;
  }
  //列：自チームの背番号、自チームの名前、敵チームの背番号、敵チームの名前に分けて表示
  static List<Widget> buildListMyPlayerNum(String myPlayerNum, String myPlayerName, String enemyPlayerNum, String enemyPlayerName, ttf) {
    List<Widget> _list = [];
    _list.add(_disPlayerInfo(myPlayerNum,'Num', ttf));
    _list.add(_disPlayerInfo(myPlayerName,'Name', ttf));
    _list.add(_disPlayerInfo(enemyPlayerNum,'Num', ttf));
    _list.add(_disPlayerInfo(enemyPlayerName,'Name', ttf));
    return _list;
  }
  //スコアブックの表示　列の要素をList<String>に再分配してからわたす
  static List<TableRow> tableRowListScore(List<GamePointTable> _selectGamePoint, ttf){
    List<TableRow> _list = [];
    int disFirstCount = disScoreCount;
    disScoreCount += 35;
    _list.add(TableRow(children:_scoreTitle(ttf)));
    for(int i = disFirstCount; i < disScoreCount; i++) {
      _list.add(TableRow(children:
      (_selectGamePoint.length <= i) ?
      buildListScore('', '', '','', 0,
                      0, '', '', '', '') :
      buildListScore(_selectGamePoint[i].myServerNum, _selectGamePoint[i].myPointSymbol, _selectGamePoint[i].myPointType,_selectGamePoint[i].myPlayerNum, _selectGamePoint[i].myPoint,
                      _selectGamePoint[i].enemyPoint, _selectGamePoint[i].enemyPlayerNum, _selectGamePoint[i].enemyPointSymbol, _selectGamePoint[i].enemyPointType, _selectGamePoint[i].enemyServerNum)
      ));
    }
    return _list;
  }

  static Widget _disPlayerInfo(String _value, String mode, ttf) {
    return Container(
      width: (mode == 'Num') ? weightPlayerNum : weightPlayerName,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(_value, style: TextStyle(fontSize: defFontSize, font: ttf)),
      ),
    );
  }
  static List<Widget> _scoreTitle(ttf){
    List<Widget> _list = [];
    _list.add(_disScoreTitle((languageJa) ? 'サー\nバー' : 'Server', ttf));
    _list.add(_disScoreTitle((languageJa) ? '得点\n記号' : 'Get\nPoint', ttf));
    _list.add(_disScoreTitle((languageJa) ? '選手\n番号' : 'Player\nNum', ttf));
    _list.add(_disScoreTitle((languageJa) ? '自\n得点' : 'My\nPoint', ttf));
    _list.add(_disScoreTitle((languageJa) ? '敵\n得点' : 'Enemy\nPoint', ttf));
    _list.add(_disScoreTitle((languageJa) ? '選手\n番号' : 'Player\nNum', ttf));
    _list.add(_disScoreTitle((languageJa) ? '得点\n記号' : 'Get\nPoint', ttf));
    _list.add(_disScoreTitle((languageJa) ? 'サー\nバー' : 'Server', ttf));
    return _list;
  }
  static List<Widget> buildListScore(String myServerNum, String myPointSymbol, String myPointType, String myPlayerNum, int myPoint, int enemyPoint,String enemyPlayerNum, String enemyPointSymbol, String enemyPointType, String enemyServerNum) {
    List<Widget> _list = [];
    _list.add(_disScoreValue(myServerNum, myPointType));
    _list.add(_disScoreValue(myPointSymbol, myPointType));
    _list.add(_disScoreValue(myPlayerNum, myPointType));
    _list.add(_disScorePointValue(myPoint.toString()));
    _list.add(_disScorePointValue(enemyPoint.toString()));
    _list.add(_disScoreValue(enemyPlayerNum, enemyPointType));
    _list.add(_disScoreValue(enemyPointSymbol, enemyPointType));
    _list.add(_disScoreValue(enemyServerNum, enemyPointType));
    return _list;
  }
  static Widget _disScoreTitle(String _value, ttf){
    return Container(
      decoration: BoxDecoration(
          border: BoxBorder(left: true,right: true,top: true,bottom: true,color: PdfColors.black)
      ),
      height: heightScore,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Align(
            alignment: Alignment.center,
            child: Text(_value ,style: TextStyle(fontSize: 7,font: ttf))),
      ),
    );
  }
  static Widget _disScoreValue(String _value, String _pointType){
    return Container(
      decoration: BoxDecoration(
          color: (_pointType == 'Get') ? PdfColors.red50 : (_pointType == 'Lost') ? PdfColors.blue50 : PdfColors.white,
          border: BoxBorder(left: true,right: true,top: true,bottom: true,color: PdfColors.black)
      ),
      width: weightScore,
      height: heightScore,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Align(
          alignment: Alignment.center,
            child: Text(_value ,style: TextStyle(fontSize: 10))),
      ),
    );
  }
  static Widget _disScorePointValue(String _value){
    return Padding(
        padding: EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: (_value != '0') ? PdfColors.red50 : PdfColors.white,
              shape: BoxShape.circle,
              border: BoxBorder(left: true,
                  right: true,
                  top: true,
                  bottom: true,
                  color: PdfColors.grey)
          ),
          width: heightScore - 2.0,
          height: heightScore - 2.0,
          child: Padding(
            padding: const EdgeInsets.all(0.2),
            child: Align(
                alignment: Alignment.center,
                child: Text(_value, style: TextStyle(fontSize: 10))),
          ),
        )
    );
  }
  static Widget _disPosition(List<GamePositionTable> _selectGamePosition, String myTeamName, String enemyTeamName, ttf){
    List<String> listMyPlayerNum = [];
    List<String> listMyPlayerName = [];
    List<String> listEnemyPlayerNum = [];
    List<String> listEnemyPlayerName = [];

    for(int i = 0; i < _selectGamePosition.length; i++) {
      if(_selectGamePosition[i].teamName == myTeamName){
        listMyPlayerNum.add(_selectGamePosition[i].playerNum);
        listMyPlayerName.add(_selectGamePosition[i].playerName);
      }else if(_selectGamePosition[i].teamName == enemyTeamName){
        listEnemyPlayerNum.add(_selectGamePosition[i].playerNum);
        listEnemyPlayerName.add(_selectGamePosition[i].playerName);
      }
    }
    return Row(
      children: [
        //自チーム
        Container(
        width: weightPlayerTitle,
        decoration: BoxDecoration(
            border: BoxBorder(left: true,right: true,top: true,bottom: true,color: PdfColors.black)
        ),
        child: Column(
            children: [
              //自チームのレフト
              Row(
                children: [
                  _disPositionPersonal(listMyPlayerNum[Position.backLeft.index],listMyPlayerName[Position.backLeft.index], ttf),
                  _disPositionPersonal(listMyPlayerNum[Position.frontLeft.index],listMyPlayerName[Position.frontLeft.index], ttf),
                ]
              ),
              //自チームのセンター
              Row(
                children: [
                  _disPositionPersonal(listMyPlayerNum[Position.backCenter.index],listMyPlayerName[Position.backCenter.index], ttf),
                  _disPositionPersonal(listMyPlayerNum[Position.frontCenter.index],listMyPlayerName[Position.frontCenter.index], ttf),
                ]
              ),
              //自チームのライト
              Row(
                children: [
                  _disPositionPersonal(listMyPlayerNum[Position.backRight.index],listMyPlayerName[Position.backRight.index], ttf),
                  _disPositionPersonal(listMyPlayerNum[Position.frontRight.index],listMyPlayerName[Position.frontRight.index], ttf),
                ]
              ),
            ]
          )
        ),
        //敵チーム
        Container(
            width: weightPlayerTitle,
            decoration: BoxDecoration(
                border: BoxBorder(left: true,right: true,top: true,bottom: true,color: PdfColors.black)
            ),
            child: Column(
                children: [
                  //敵チームのレフト
                  Row(
                    children: [
                      _disPositionPersonal(listEnemyPlayerNum[Position.frontRight.index],listEnemyPlayerName[Position.frontRight.index], ttf),
                      _disPositionPersonal(listEnemyPlayerNum[Position.backRight.index],listEnemyPlayerName[Position.backRight.index], ttf),
                    ]
                  ),
                  //敵チームのセンター
                  Row(
                    children: [
                      _disPositionPersonal(listEnemyPlayerNum[Position.frontCenter.index],listEnemyPlayerName[Position.frontCenter.index], ttf),
                      _disPositionPersonal(listEnemyPlayerNum[Position.backCenter.index],listEnemyPlayerName[Position.backCenter.index], ttf),
                    ]
                  ),
                  //敵チームのライト
                  Row(
                    children: [
                      _disPositionPersonal(listEnemyPlayerNum[Position.frontLeft.index],listEnemyPlayerName[Position.frontLeft.index], ttf),
                      _disPositionPersonal(listEnemyPlayerNum[Position.backLeft.index],listEnemyPlayerName[Position.backLeft.index], ttf),
                    ]
                  ),
                ]
            )
        ),
      ]
    );

  }
  static Widget _disPositionPersonal(String playerNum, String playerName, ttf){
    final double _paddingPlayerNum = 8.0;
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(left: _paddingPlayerNum,right: _paddingPlayerNum, top: 3.0, bottom: 3.0),
            child: Container(
                width: weightPlayerTitle / 2 - (_paddingPlayerNum * 2),
                height: weightPlayerTitle / 2 - (_paddingPlayerNum * 2),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(playerNum,style: TextStyle(fontSize: defFontSize + 2,font: ttf)),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: BoxBorder(left: true,right: true,top: true,bottom: true,color: PdfColors.black)
                ),
            ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 3.0),
          child: Container(
            width: weightPlayerTitle / 2 - (_paddingPlayerNum * 2),
            height: 15,
            child: Align(
                alignment: Alignment.center,
                child: Text(playerName, maxLines: 2,
                  style: TextStyle(fontSize: defFontSize, font: ttf,),)
            ),
          ),
        )
      ]
    );
  }

  static List<TableRow> _tableRowScoreSymbol(ttf) {
    List<TableRow> list = [];
    List<String> _listTypeGet = [];
    List<String> _listTypeLost = [];
    int _listLength = 0;
    for (int i = 0; i < PointName.listMap.length; i++) {
      if (PointName.listMap[i]['pointType'] == 'Get') {
        _listTypeGet.add((languageJa) ? PointName.listMap[i]['pointName'] : PointName.listMap[i]['pointNameEn']);
      } else if (PointName.listMap[i]['pointType'] == 'Lost') {
        _listTypeLost.add((languageJa) ? PointName.listMap[i]['pointName'] : PointName.listMap[i]['pointNameEn']);
      }
    }
    _listLength = (_listTypeGet.length < _listTypeLost.length)
        ? _listTypeLost.length
        : _listTypeGet.length;

    for (int i = 0; i < _listLength; i++) {
      list.add(
        TableRow(children: [
            Container(
                width: weightPlayerTitle - 10,
                child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text((_listTypeGet.length <= i) ? '' : _listTypeGet[i],
                        style: TextStyle(font: ttf, fontSize: defFontSize))
                )
            ),
            Container(
                width: weightPlayerTitle + 10,
                child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text((_listTypeLost.length < i) ? '' : _listTypeLost[i],
                        style: TextStyle(font: ttf, fontSize: defFontSize))
                )
            ),
        ]),
      );
    }
    return list;
  }

  static List<TableRow> _tableRowGameDetail(List<GamePointTable> _selectGamePoint, ttf) {
    List<TableRow> list = [];
    int myGetPointCount = 0;
    int enemyGetPointCount = 0;
    int myLostPointCount = 0;
    int enemyLostPointCount = 0;

    for(int i = 0; i < _selectGamePoint.length; i++){
      if(_selectGamePoint[i].myPointType == 'Get') myGetPointCount++;
      if(_selectGamePoint[i].enemyPointType == 'Get') enemyGetPointCount++;
      if(_selectGamePoint[i].myPointType == 'Lost') enemyLostPointCount++;
      if(_selectGamePoint[i].enemyPointType == 'Lost') myLostPointCount++;
    }
    list.add(
      TableRow(children: [
        _gameDetailContainer('', ttf),
        _gameDetailContainer((languageJa) ? '自チーム' : 'My Team', ttf),
        _gameDetailContainer((languageJa) ? '敵チーム' : 'Enemy Team', ttf),
      ]),
    );
    list.add(
      TableRow(children: [
        _gameDetailContainer((languageJa) ? '得点' : 'Get Point', ttf),
        _gameDetailContainerRow('$myGetPointCount', (myGetPointCount + myLostPointCount == 0) ? '(0%)' : '(${(myGetPointCount / (myGetPointCount + myLostPointCount) * 100).round()}%)', ttf ),
        _gameDetailContainerRow('$enemyGetPointCount', (enemyGetPointCount + enemyLostPointCount == 0) ? '(0%)' : '(${(enemyGetPointCount / (enemyGetPointCount + enemyLostPointCount) * 100).round()}%)',ttf),
      ]),
    );
    list.add(
      TableRow(children: [
        _gameDetailContainer((languageJa) ? '相手の失点' : 'Lost Point', ttf),
        _gameDetailContainerRow('$myLostPointCount', (myGetPointCount + myLostPointCount == 0) ? '(0%))' : '(${(myLostPointCount / (myGetPointCount + myLostPointCount) * 100).round()}%)', ttf),
        _gameDetailContainerRow('$enemyLostPointCount', (enemyGetPointCount + enemyLostPointCount == 0) ? '(0%)' : '(${(enemyLostPointCount / (enemyGetPointCount + enemyLostPointCount) * 100).round()}%)', ttf),
      ]),
    );
    list.add(
      TableRow(children: [
        _gameDetailContainer((languageJa) ? '合計' : 'Total', ttf),
        _gameDetailContainer('${myGetPointCount + myLostPointCount}', ttf),
        _gameDetailContainer('${enemyGetPointCount + enemyLostPointCount}', ttf),
      ]),
    );
    return list;
  }
  static Widget _gameDetailContainer(String _value, ttf){
    return Container(
      width: weightGameDetail,
      child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(_value,
              style: TextStyle(font: ttf, fontSize: defFontSize))
      ),
    );
  }
  static Widget _gameDetailContainerRow(String _value, String _value2, ttf){
    return Container(
      width: weightGameDetail,
      child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(children: [
            Text(_value,
                style: TextStyle(font: ttf, fontSize: defFontSize)),
            Padding(padding: EdgeInsets.only(left: 5.0),
            child: Text(_value2,
                style: TextStyle(font: ttf, fontSize: defFontSize))),
          ]),
      ),
    );
  }
  static List<TableRow> _tableRowPlayerDetail(List<GamePointTable> _selectGamePoint, List<GamePlayerTable> _selectGamePlayer, String teamName, SelectTeam teamType, ttf) {
    List<TableRow> list = [];
    List<String> listPlayerNum = [];
    List<String> listPlayerName = [];

    for (int i = 0; i < _selectGamePlayer.length; i++) {
      if (_selectGamePlayer[i].teamName == teamName) {
        listPlayerNum.add(_selectGamePlayer[i].playerNum);
        listPlayerName.add(_selectGamePlayer[i].playerName);
      }
    }
      list.add(TableRow(children: _playerDetailTitleContainer(ttf)));
      for (int i = 0; i < listPlayerNum.length; i++) {
        if(listPlayerNum[i] == '' && listPlayerName[i] =='') {}
        else{
          list.add(TableRow(children: _playerDetailContainer(listPlayerNum[i],listPlayerName[i],teamType,_selectGamePoint,ttf)));
        }
      }
    return list;
  }

  static List<Widget> _playerDetailTitleContainer(ttf) {
    List<Widget> _list = [];
    _list.add(Container());
    for (int i = 0; i < PointName.listMap.length; i++) {
      _list.add(
        Container(
          color: (PointName.listMap[i]['pointType'] == 'Get') ? PdfColors.red50 : PdfColors.blue50,
          width: weightPlayerDetail,
          child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Align(
                  alignment: Alignment.center,
                  child:Text(PointName.listMap[i]['pointSymbol'],
                  style: TextStyle(font: ttf, fontSize: defFontSize))
              )
          ),
        ),
      );
    }
    _list.add(
      Container(
        color: PdfColors.red50,
        width: weightPlayerDetail,
        child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
                alignment: Alignment.center,
                child:Text((languageJa) ? '得点' : 'Get Point',
                style: TextStyle(font: ttf, fontSize: defFontSize))
            )
        ),
      ),
    );
    _list.add(
      Container(
        color: PdfColors.blue50,
        width: weightPlayerDetail,
        child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
                alignment: Alignment.center,
                child:Text((languageJa) ? '失点' : 'Lost Point',
                style: TextStyle(font: ttf, fontSize: defFontSize))
            )
        ),
      ),
    );
    return _list;
  }

  static List<Widget> _playerDetailContainer(String playerNum, String playerName, SelectTeam teamType, List<GamePointTable> _selectGamePoint, ttf) {
    List<Widget> _list = [];
    List<int> _count = List.filled(PointName.listMap.length, 0);
    int getPointCount = 0;
    int lostPointCount = 0;

    if (teamType == SelectTeam.myTeam) {
      for (int ci = 0; ci < PointName.listMap.length; ci++) {
        for (int i = 0; i < _selectGamePoint.length; i++) {
          if (_selectGamePoint[i].myPlayerNum == playerNum &&
              PointName.listMap[ci]['pointSymbol'] ==
                  _selectGamePoint[i].myPointSymbol) {
            _count[ci]++;
          }
        }
      }
      for (int i = 0; i < _selectGamePoint.length; i++) {
        if (_selectGamePoint[i].myPlayerNum == playerNum) {
          if (_selectGamePoint[i].myPointType == 'Get')
            getPointCount++;
          else if (_selectGamePoint[i].myPointType == 'Lost') lostPointCount++;
        }
      }
    }
    else if (teamType == SelectTeam.enemyTeam) {
      for (int ci = 0; ci < PointName.listMap.length; ci++) {
        for (int i = 0; i < _selectGamePoint.length; i++) {
          if (_selectGamePoint[i].enemyPlayerNum == playerNum &&
              PointName.listMap[ci]['pointSymbol'] == _selectGamePoint[i].enemyPointSymbol)_count[ci]++;
        }
      }
      for (int i = 0; i < _selectGamePoint.length; i++) {
        if (_selectGamePoint[i].enemyPlayerNum == playerNum) {
          if (_selectGamePoint[i].enemyPointType == 'Get') getPointCount++;
          else
          if (_selectGamePoint[i].enemyPointType == 'Lost') lostPointCount++;
        }
      }
    }
    _list.add(Container(
      width: 75,
      child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(playerNum + ' ($playerName)',
              style: TextStyle(font: ttf, fontSize: defFontSize))
      ),
    ));
    for (int i = 0; i < PointName.listMap.length; i++) {
      _list.add(Container(
        width: weightPlayerDetail,
        child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
                alignment: Alignment.center,
                child: Text((_count[i] == 0) ? '' : _count[i].toString(),
                    style: TextStyle(font: ttf, fontSize: defFontSize))
            )
        ),
      ));
    }
    _list.add(Container(
        width: weightPlayerDetail,
        child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
                alignment: Alignment.center,
                child: Text(getPointCount.toString(),
                    style: TextStyle(font: ttf, fontSize: defFontSize))
            )
        ),
      ),);
    _list.add(Container(
        width: weightPlayerDetail,
        child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
                alignment: Alignment.center,
                child: Text(lostPointCount.toString(),
                    style: TextStyle(font: ttf, fontSize: defFontSize))
            )
        ),
      ),);
    return _list;
  }
}