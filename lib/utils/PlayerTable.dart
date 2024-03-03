class PlayerTable{

  final String teamName;
  final int teamId;
  final int playerId;
  final String playerNum;
  final String playerName;
  final String playerPosition;

  PlayerTable({this.teamName, this.teamId, this.playerId, this.playerNum, this.playerName, this.playerPosition});

  static final String tableName = 'Player_Table';
  static final String columnTeamName = 'teamName';
  static final String columnTeamId = 'teamId';
  static final String columnPlayerId = 'playerId';
  static final String columnPlayerNum = 'playerNum';
  static final String columnPlayerName = 'playerName';

  Map<String, dynamic> toMap() {
    return {
      '$columnTeamName': teamName,
      '$columnTeamId' : teamId,
      '$columnPlayerId' : playerId,
      '$columnPlayerNum': playerNum,
      '$columnPlayerName': playerName
    };
  }

//選手の情報を持つテーブルを作成
  static String createPlayerTable()  {
    return (
      'CREATE TABLE $tableName ('
        '$columnTeamName TEXT,'
        '$columnTeamId INTEGER,'
        '$columnPlayerId INTEGER,'
        '$columnPlayerNum TEXT,'
        '$columnPlayerName TEXT'
          ')'
    );
  }
  //初期値Insert(チームIDを１から始めたいから)
  static String insertFirst(){
    return (
      'INSERT INTO $tableName ('
          '$columnTeamId) '
          'VALUES (0)'
    );
  }

  static String insertPlayerTable(String teamName, int teamId, int playerId, String playerNum, String playerName) {
    return(
      "INSERT INTO $tableName ("
        "$columnTeamName, "
        "$columnTeamId, "
        "$columnPlayerId, "
        "$columnPlayerNum, "
        "$columnPlayerName"
        ") VALUES ("
        "'$teamName', "
        "$teamId, "
        "$playerId, "
        "'$playerNum', "
        "'$playerName' "
        ")"
    );
  }

  static String updatePlayerInfo(String teamName, int teamId, int playerId, String playerNum, String playerName) {
    return (
      "UPDATE $tableName "
      "SET "
      "$columnTeamName = '$teamName', "
      "$columnPlayerNum = '$playerNum', "
      "$columnPlayerName = '$playerName'"
      "WHERE $columnTeamId = '$teamId' "
      "AND $columnPlayerId = '$playerId'"
    );
  }
  static String deleteTable(String teamName){
    return(
      "DELETE FROM $tableName WHERE $columnTeamName = '$teamName'"
    );
  }
  static String selectPlayerInfo(String teamName){
    return(
      "SELECT * FROM $tableName WHERE $columnTeamName = '$teamName'"
    );
  }
  static String selectMaxTeamId(){
    return(
      "SELECT MAX($columnTeamId) FROM $tableName"
    );
  }
  static String selectTeamName(){
    return(
      "SELECT $columnTeamName FROM $tableName GROUP BY $columnTeamName ORDER BY $columnTeamId"
    );
  }
}