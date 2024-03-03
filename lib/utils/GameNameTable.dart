class GameNameTable{

  final int gameId;
  final String gameName;
  final String myTeamName;
  final String enemyTeamName;


  GameNameTable({this.gameId, this.gameName, this.myTeamName, this.enemyTeamName});

  static final String tableName = 'Game_Name_Table';
  static final String columnGameId = 'gameId';
  static final String columnGameName = 'gameName';
  static final String columnMyTeamName = 'myTeamName';
  static final String columnEnemyTeamName = 'enemyTeamName';


  Map<String, dynamic> toMap() {
    return {
      '$columnGameId' : gameId,
      '$columnGameName' : gameName,
      '$columnMyTeamName' : myTeamName,
      '$columnEnemyTeamName' : enemyTeamName,
    };
  }

  static String createGameNameTable()  {
    return (
        'CREATE TABLE $tableName ('
            '$columnGameId INTEGER,'
            '$columnGameName TEXT, '
            '$columnMyTeamName TEXT, '
            '$columnEnemyTeamName TEXT '
            ')'
    );
  }
  //初期値Insert(チームIDを１から始めたいから)
  static String insertFirst(){
    return (
        'INSERT INTO $tableName ('
            '$columnGameId) '
            'VALUES (0)'
    );
  }

  static String insertGameNameTable(int gameId, String gameName, String myTeamName, String enemyTeamName) {
    return(
        "INSERT INTO $tableName ("
            "$columnGameId, "
            "$columnGameName, "
            "$columnMyTeamName, "
            "$columnEnemyTeamName"
            ") VALUES ("
            "$gameId, "
            "'$gameName', "
            "'$myTeamName', "
            "'$enemyTeamName' "
            ")"
    );
  }

  static String updateGameName(int gameId,String newGameName){
    return(
        "UPDATE $tableName"
            " SET "
            "$columnGameName = '$newGameName' "
            "WHERE $columnGameId = '$gameId' "
    );
  }

  static String deleteTable(int gameId){
    return(
        "DELETE FROM $tableName WHERE $columnGameId = $gameId"
    );
  }

  static String selectGameNameAll(){
    return(
        "SELECT * FROM $tableName"
    );
  }

  static String selectGameName(int gameId){
    return(
        "SELECT $columnGameName FROM $tableName WHERE $columnGameId = $gameId"
    );
  }

  static String selectMaxGameId(){
    return(
        "SELECT MAX($columnGameId) FROM $tableName"
    );
  }
}