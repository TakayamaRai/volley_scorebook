class GamePositionTable{

  final int gameId;
  final String teamName;
  final String positionNum;
  final String playerNum;
  final String playerName;

  GamePositionTable({this.gameId, this.teamName, this.positionNum, this.playerNum, this.playerName});

  static final String tableName = 'Game_Position_Table';
  static final String columnGameId = 'gameId';
  static final String columnTeamName = 'teamName';
  static final String columnPositionNum = 'positionNum';
  static final String columnPlayerNum = 'playerNum';
  static final String columnPlayerName = 'playerName';

  Map<String, dynamic> toMap() {
    return {
      '$columnGameId' : gameId,
      '$columnTeamName' : teamName,
      '$columnPositionNum' : positionNum,
      '$columnPlayerNum': playerNum,
      '$columnPlayerName': playerName,
    };
  }

  static String createGamePositionTable()  {
    return (
        'CREATE TABLE $tableName ('
            '$columnGameId INTEGER, '
            '$columnTeamName TEXT, '
            '$columnPositionNum TEXT, '
            '$columnPlayerNum TEXT,'
            '$columnPlayerName TEXT'
            ')'
    );
  }

  static String insertGamePositionTable(int gameId, String teamName, String positionNum,  String playerNum, String playerName,) {
    return(
        "INSERT INTO $tableName ("
            "$columnGameId, "
            "$columnTeamName, "
            "$columnPositionNum, "
            "$columnPlayerNum, "
            "$columnPlayerName"
            " )VALUES ("
            "$gameId, "
            "'$teamName', "
            "'$positionNum', "
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
  static String selectGamePositionTableAll(int gameId){
    return(
        "SELECT * FROM $tableName WHERE $columnGameId = $gameId"
    );
  }
}