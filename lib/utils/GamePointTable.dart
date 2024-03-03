class GamePointTable {
  final int gameId;
  final String myServerNum;
  final String myPointSymbol;
  final String myPointType;
  final String myPlayerNum;
  final int myPoint;
  final String enemyServerNum;
  final String enemyPointSymbol;
  final String enemyPointType;
  final String enemyPlayerNum;
  final int enemyPoint;

  GamePointTable(
      {this.gameId,
      this.myServerNum,
      this.myPointSymbol,
      this.myPointType,
      this.myPlayerNum,
      this.myPoint,
      this.enemyServerNum,
      this.enemyPointSymbol,
      this.enemyPointType,
      this.enemyPlayerNum,
      this.enemyPoint});

  static final String tableName = 'Game_Point_Table';
  static final String columnGameId = 'gameId';
  static final String columnMyServerNum = 'myServerNum';
  static final String columnMyPointSymbol = 'myPointSymbol';
  static final String columnMyPointType = 'myPointType';
  static final String columnMyPlayerNum = 'myPlayerNum';
  static final String columnMyPoint = 'myPoint';
  static final String columnEnemyServerNum = 'enemyServerNum';
  static final String columnEnemyPointSymbol = 'enemyPointSymbol';
  static final String columnEnemyPointType = 'enemyPointType';
  static final String columnEnemyPlayerNum = 'enemyPlayerNum';
  static final String columnEnemyPoint = 'enemyPoint';

  Map<String, dynamic> toMap() {
    return {
      '$columnGameId': gameId,
      '$columnMyServerNum': myServerNum,
      '$columnMyPointSymbol': myPointSymbol,
      '$columnMyPointType': myPointType,
      '$columnMyPlayerNum': myPlayerNum,
      '$columnMyPoint': myPoint,
      '$columnEnemyServerNum': enemyServerNum,
      '$columnEnemyPointSymbol': enemyPointSymbol,
      '$columnEnemyPointType': enemyPointType,
      '$columnEnemyPlayerNum': enemyPlayerNum,
      '$columnEnemyPoint': enemyPoint,
    };
  }

  static String createGamePointTable() {
    return ('CREATE TABLE $tableName ( '
        '$columnGameId INTEGER, '
        '$columnMyServerNum TEXT, '
        '$columnMyPointSymbol TEXT, '
        '$columnMyPointType TEXT, '
        '$columnMyPlayerNum TEXT, '
        '$columnMyPoint INTEGER, '
        '$columnEnemyServerNum TEXT, '
        '$columnEnemyPointSymbol TEXT, '
        '$columnEnemyPointType TEXT, '
        '$columnEnemyPlayerNum TEXT, '
        '$columnEnemyPoint INTEGER '
        ')');
  }

  static String insertGamePointTable(
      int gameId,
      String myServerNum,
      String myPointSymbol,
      String myPointType,
      String myPlayerNum,
      int myPoint,
      String enemyServerNum,
      String enemyPointSymbol,
      String enemyPointType,
      String enemyPlayerNum,
      int enemyPoint) {
    return ("INSERT INTO $tableName ("
        "$columnGameId, "
        "$columnMyServerNum, "
        "$columnMyPointSymbol, "
        "$columnMyPointType, "
        "$columnMyPlayerNum, "
        "$columnMyPoint, "
        "$columnEnemyServerNum, "
        "$columnEnemyPointSymbol, "
        "$columnEnemyPointType, "
        "$columnEnemyPlayerNum, "
        "$columnEnemyPoint"
        ") VALUES ("
        "$gameId, "
        "'$myServerNum', "
        "'$myPointSymbol', "
        "'$myPointType', "
        "'$myPlayerNum', "
        "$myPoint, "
        "'$enemyServerNum', "
        "'$enemyPointSymbol', "
        "'$enemyPointType', "
        "'$enemyPlayerNum', "
        "$enemyPoint"
        ")");
  }

  static String deleteTable(int gameId) {
    return ("DELETE FROM $tableName WHERE $columnGameId = $gameId");
  }

  static String selectGamePointTableAll(int gameId) {
    return ("SELECT * FROM $tableName WHERE $columnGameId = $gameId");
  }
}
