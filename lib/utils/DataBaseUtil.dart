import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:volley_scorebook/utils/GameNameTable.dart';
import 'package:volley_scorebook/utils/GamePlayerTable.dart';
import 'package:volley_scorebook/utils/GamePointTable.dart';
import 'package:volley_scorebook/utils/GamePositionTable.dart';
import 'package:volley_scorebook/utils/PlayerTable.dart';

class DataBaseUtil{

  static Future<Database> scoreDB;

  //テーブルを作成
  static Future<void> createTable() async {
    scoreDB = openDatabase(
      join(await getDatabasesPath(), 'scoreDataBase.db'),
      onCreate: (db, version) async{
        await db.execute(PlayerTable.createPlayerTable());
        await db.rawInsert(PlayerTable.insertFirst());
        await db.execute(GameNameTable.createGameNameTable());
        await db.rawInsert(GameNameTable.insertFirst());
        await db.execute(GamePlayerTable.createGamePlayerTable());
        await db.execute(GamePointTable.createGamePointTable());
        await db.execute(GamePositionTable.createGamePositionTable());
      },
      version: 1,
    );
  }

  static Future<void> insertPlayerTablePlayerInfo(String teamName, int teamId, int playerId, String playerNum, String playerName) async {
    final Database db = await scoreDB;
    await db.rawInsert(PlayerTable.insertPlayerTable(teamName, teamId, playerId, playerNum, playerName));
  }

  static Future<void> updatePlayerTablePlayerInfo(String teamName, int teamId, int playerId, String playerNum, String playerName) async{
    final Database db = await scoreDB;
    await db.rawUpdate(PlayerTable.updatePlayerInfo(teamName, teamId, playerId, playerNum, playerName));
  }

  static Future<void> deletePlayerTable(String teamName) async {
    final Database db = await scoreDB;
    await db.rawDelete(PlayerTable.deleteTable(teamName)
    );
  }

  static Future<List<PlayerTable>> selectPlayerTablePlayerInfo(String teamName) async {
    final Database db = await scoreDB;
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(PlayerTable.selectPlayerInfo(teamName));
    return List.generate(queryResult.length, (i)
      {
        return PlayerTable(
          teamName: queryResult[i]['teamName'],
          teamId: queryResult[i]['teamId'],
          playerId: queryResult[i]['playerId'],
          playerNum: queryResult[i]['playerNum'],
          playerName: queryResult[i]['playerName'],
        );
      }
    );
  }

  static Future<int> selectPlayerTableMaxTeamId() async{
    final Database db = await scoreDB;
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(PlayerTable.selectMaxTeamId());
    return queryResult[0]['MAX(teamId)'] + 1;
  }

  static Future<List<PlayerTable>> selectPlayerTableTeamName() async{
    final Database db = await scoreDB;
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(PlayerTable.selectTeamName());
    return List.generate(queryResult.length, (i)
      {
        return PlayerTable(
          teamName: queryResult[i]['teamName'],
        );
      }
    );
  }

  static Future<void> insertGameNameGameInfo(int gameId, String gameName, String myTeamName, String enemyTeamName) async{
    final Database db = await scoreDB;
    await db.rawInsert(GameNameTable.insertGameNameTable(gameId, gameName, myTeamName, enemyTeamName));
  }

  static Future<void> updateGameNameGameName(int gameId, String newGameName) async{
    final Database db = await scoreDB;
    await db.rawUpdate(GameNameTable.updateGameName(gameId, newGameName));
  }

  static Future<void> deleteGameNameTable(int gameId) async{
    final Database db = await scoreDB;
    await db.rawDelete(GameNameTable.deleteTable(gameId));
  }

  static Future<List<GameNameTable>> selectGameNameTableAll() async{
    final Database db = await scoreDB;
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(GameNameTable.selectGameNameAll());
    print('---------------selectGameNameTableAll ゲームID、試合名、自チーム名、敵チーム名の登録-------------------');
    queryResult.forEach((Map<String, dynamic> map){
      print(map);
    });
    return List.generate(queryResult.length, (i)
      {
        return GameNameTable(
          gameId: queryResult[i][GameNameTable.columnGameId],
          gameName: queryResult[i][GameNameTable.columnGameName],
          myTeamName: queryResult[i][GameNameTable.columnMyTeamName],
          enemyTeamName: queryResult[i][GameNameTable.columnEnemyTeamName],
        );
      }
    );
  }

  static Future<List<GameNameTable>> selectGameNameTableGameName(int gameId) async{
    final Database db = await scoreDB;
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(GameNameTable.selectGameName(gameId));
    return List.generate(queryResult.length, (i)
    {
      return GameNameTable(
        gameId: queryResult[i][GameNameTable.columnGameId],
        gameName: queryResult[i][GameNameTable.columnGameName],
      );
    }
    );
  }

  static Future<int> selectGameNameTableMaxGameId() async{
    final Database db = await scoreDB;
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(GameNameTable.selectMaxGameId());
    return queryResult[0]['MAX(gameId)'] + 1;
  }

  static Future<void> insertGamePlayerPlayerInfo(int gameId, String teamName, String playerNum, String playerName,) async{
    final Database db = await scoreDB;
    await db.rawInsert(GamePlayerTable.insertGamePlayerTable(gameId, teamName, playerNum, playerName));
  }

  static Future<void> deleteGamePlayerTable(int gameId) async{
    final Database db = await scoreDB;
    await db.rawDelete(GamePlayerTable.deleteTable(gameId));
  }

  static Future<List<GamePlayerTable>> selectGamePlayerTableAll(int gameId) async{
    final Database db = await scoreDB;
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(GamePlayerTable.selectGamePlayerTableAll(gameId));
    print('---------------selectGamePlayerTableAll ゲームID、自チームの選手登録-------------------');
    queryResult.forEach((Map<String, dynamic> map){
      print(map);
    });
    return List.generate(queryResult.length, (i)
      {
        return GamePlayerTable(
            gameId: queryResult[i][GamePlayerTable.columnGameId],
            teamName: queryResult[i][GamePlayerTable.columnTeamName],
            playerNum: queryResult[i][GamePlayerTable.columnPlayerNum],
            playerName: queryResult[i][GamePlayerTable.columnPlayerName],
        );
      }
    );
  }
  static Future<void> insertGamePositionPlayerInfo(int gameId, String teamName, String positionNum, String playerNum, String playerName,) async{
    final Database db = await scoreDB;
    await db.rawInsert(GamePositionTable.insertGamePositionTable(gameId, teamName, positionNum, playerNum, playerName));
  }

  static Future<void> deleteGamePositionTable(int gameId) async{
    final Database db = await scoreDB;
    await db.rawDelete(GamePositionTable.deleteTable(gameId));
  }

  static Future<List<GamePositionTable>> selectGamePositionTableAll(int gameId) async{
    final Database db = await scoreDB;
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(GamePositionTable.selectGamePositionTableAll(gameId));
    print('---------------selectGamePositionTableAll pojisyonn -------------------');
    queryResult.forEach((Map<String, dynamic> map){
      print(map);
    });
    return List.generate(queryResult.length, (i)
    {
      return GamePositionTable(
        gameId: queryResult[i][GamePositionTable.columnGameId],
        teamName: queryResult[i][GamePositionTable.columnTeamName],
        playerNum: queryResult[i][GamePositionTable.columnPlayerNum],
        playerName: queryResult[i][GamePositionTable.columnPlayerName],
      );
    }
    );
  }

  static Future<void> insertGamePointHistory(int gameId, String myServerNum, String myPointSymbol, String myPointType, String myPlayerNum, int myPoint, String enemyServerNum, String enemyPointSymbol, String enemyPointType, String enemyPlayerNum, int enemyPoint,) async{
    final Database db = await scoreDB;
    await db.rawInsert(GamePointTable.insertGamePointTable(gameId, myServerNum, myPointSymbol, myPointType, myPlayerNum, myPoint, enemyServerNum, enemyPointSymbol, enemyPointType, enemyPlayerNum, enemyPoint));
  }

  static Future<void> deleteGamePointTable(int gameId) async{
    final Database db = await scoreDB;
    await db.rawDelete(GamePointTable.deleteTable(gameId));
  }

  static Future<List<GamePointTable>> selectGamePointTableAll(int gameId) async{
    final Database db = await scoreDB;
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(GamePointTable.selectGamePointTableAll(gameId));
    print('---------------selectGamePointTableAll スコアブックの情報を登録-------------------');
    queryResult.forEach((Map<String, dynamic> map){
      print(map);
    });
    return List.generate(queryResult.length, (i)
      {
        return GamePointTable(
          gameId: queryResult[i][GamePointTable.columnGameId],
          myServerNum: queryResult[i][GamePointTable.columnMyServerNum],
          myPointSymbol: queryResult[i][GamePointTable.columnMyPointSymbol],
          myPointType: queryResult[i][GamePointTable.columnMyPointType],
          myPlayerNum: queryResult[i][GamePointTable.columnMyPlayerNum],
          myPoint: queryResult[i][GamePointTable.columnMyPoint],
          enemyServerNum: queryResult[i][GamePointTable.columnEnemyServerNum],
          enemyPointSymbol: queryResult[i][GamePointTable.columnEnemyPointSymbol],
          enemyPointType: queryResult[i][GamePointTable.columnEnemyPointType],
          enemyPlayerNum: queryResult[i][GamePointTable.columnEnemyPlayerNum],
          enemyPoint: queryResult[i][GamePointTable.columnEnemyPoint],
        );
      }
    );
  }
}