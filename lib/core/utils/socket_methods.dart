import 'dart:developer';

import 'package:dark_typer/core/utils/socket_client.dart';
import 'package:dark_typer/features/multiplayer_mode/ui/multiplayer_mode_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/multiplayer_mode/provider/client_state_provider.dart';
import '../../features/multiplayer_mode/provider/game_state_provider.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;
  bool _isPlaying = false;

  void endGame() {
    _socketClient.disconnect();
    _socketClient.close();
    _socketClient.destroy();
  }

  startGame(String name, String difficulty, String mode, int duration) {
    if (name.isNotEmpty && difficulty.isNotEmpty) {
      _socketClient.emit('start-game', {
        'name': name,
        'difficulty': difficulty,
        'mode': 'multiplayer',
        'duration': 60
      });
    }
  }

  sendUserInput(String value, String gameID) {
    _socketClient.emit('user-input', {
      'userInput': value,
      'gameId': gameID,
    });
  }

  //listeners
  updateGameListener(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      log(data.toString());
      final gameStateProvider =
          Provider.of<GameStateProvider>(context, listen: false)
              .updateGameState(
                  id: data['game']['_id'],
                  canJoin: data['game']['canJoin'],
                  players: data['game']['players'],
                  startTime: data['game']['startTime'],
                  text: data['game']['text'],
                  isOver: data['game']['isOver'],
                  remainingPlayer: data['game']['remainingPlayers'],
                  playersFinished: data['game']['playersFinished']);
      log(data['game']['_id']+" "+_isPlaying.toString());
      if (data['game']['_id'].isNotEmpty && !_isPlaying) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MultiPlayerMode()),
        );
        _isPlaying = true;
      }
    });
  }
  updateGame(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      final gameStateProvider =
      Provider.of<GameStateProvider>(context, listen: false)
          .updateGameState(
          id: data['game']['_id'],
          canJoin: data['game']['canJoin'],
          players: data['game']['players'],
          startTime: data['game']['startTime'],
          text: data['game']['text'],
          isOver: data['game']['isOver'],
          remainingPlayer: data['game']['remainingPlayers'],
          playersFinished: data['game']['playersFinished']
      );
    });
  }

  updateTimer(BuildContext context) {
    final clientStateProvider =
        Provider.of<ClientStateProvider>(context, listen: false);
    _socketClient.on('timer', (data) {
      clientStateProvider.setClientState(data);
    });
  }
}
