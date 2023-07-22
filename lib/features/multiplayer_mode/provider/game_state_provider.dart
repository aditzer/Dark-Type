import 'package:flutter/material.dart';

import '../models/game_state.dart';

class GameStateProvider extends ChangeNotifier {
  GameState _gameState = GameState(
      id: '',
      canJoin: true,
      isOver: false,
      text: [],
      startTime: 0,
      remainingPlayer: 3,
      playersFinished: 0,
      players: []);

  Map<String, dynamic> get gameState => _gameState.toJson();

  void updateGameState(
      {required id,
      required canJoin,
      required isOver,
      required text,
      required startTime,
      required remainingPlayer,
      required playersFinished,
      required players}) {
    _gameState = GameState(
        id: id,
        canJoin: canJoin,
        isOver: isOver,
        text: text,
        startTime: startTime,
        remainingPlayer: remainingPlayer,
        playersFinished: playersFinished,
        players: players);
    notifyListeners();
  }
}
