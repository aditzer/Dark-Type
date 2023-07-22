class GameState {
  final String id;
  final bool canJoin;
  final bool isOver;
  final List text;
  final int startTime;
  final int remainingPlayer;
  final int playersFinished;
  final List players;


  GameState({required this.id,required this.canJoin, required this.isOver, required this.text, required this.startTime, required this.remainingPlayer, required this.playersFinished, required this.players});

  Map<String, dynamic> toJson() => {
    'id':id,
    'remainingPlayer': remainingPlayer,
    'canJoin': canJoin,
    'text': text,
    'isOver': isOver,
    'startTime': startTime,
    'playersFinished': playersFinished,
    'players': players
  };
}

class Player {
  final String name;
  final int currentWordIndex;
  final int WPM;
  final String socketID;

  Player(this.name, this.currentWordIndex, this.WPM, this.socketID);
}