class GamePlayerTable{

  final int gameId;
  final String teamName;
  final String playerNum;
  final String playerName;

  GamePlayerTable({this.gameId, this.teamName, this.playerNum, this.playerName});

  static final String tableName = 'Game_Player_Table';
  static final String columnGameId = 'gameId';
  static final String columnTeamName = 'teamName';
  static final String columnPlayerNum = 'playerNum';
  static final String columnPlayerName = 'playerName';

  Map<String, dynamic> toMap() {
    return {
      '$columnGameId' : gameId,
      '$columnTeamName' : teamName,
      '$columnPlayerNum': playerNum,
      '$columnPlayerName': playerName,
    };
  }

  static String createGamePlayerTable()  {
    return (
      'CREATE TABLE $tableName ('
      '$columnGameId INTEGER, '
      '$columnTeamName TEXT, '
      '$columnPlayerNum TEXT,'
      '$columnPlayerName TEXT'
      ')'
    );
  }

  static String insertGamePlayerTable(int gameId, String teamName, String playerNum, String playerName,) {
    return(
      "INSERT INTO $tableName ("
      "$columnGameId, "
      "$columnTeamName, "
      "$columnPlayerNum, "
      "$columnPlayerName"
      " )VALUES ("
      "$gameId, "
      "'$teamName', "
      "'$playerNum', "
      "'$playerName' "
      ")"
    );
  }

  static String deleteTable(int gameId){
    return(
      "DELETE FROM $tableName WHERE $columnGameId = $gameId"
    );
  }
  static String selectGamePlayerTableAll(int gameId){
    return(
      "SELECT * FROM $tableName WHERE $columnGameId = $gameId"
    );
  }
}