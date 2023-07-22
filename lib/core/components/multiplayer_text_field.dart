import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/multiplayer_mode/provider/client_state_provider.dart';
import '../../features/multiplayer_mode/provider/game_state_provider.dart';
import '../utils/socket_client.dart';
import '../utils/socket_methods.dart';

class MultiplayerTypingBox extends StatefulWidget {
  const MultiplayerTypingBox({Key? key}) : super(key: key);

  @override
  _MultiplayerTypingBoxState createState() => _MultiplayerTypingBoxState();
}

class _MultiplayerTypingBoxState extends State<MultiplayerTypingBox> {
  final SocketMethods _socketMethods = SocketMethods();
  var playerMe = null;
  bool isBtn = true;
  late GameStateProvider? game;

  final TextEditingController _wordsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    game = Provider.of<GameStateProvider>(context, listen: false);
    findPlayerMe(game!);
  }

  handleTextChange(String value, String gameID) {
    var lastChar = value[value.length - 1];
    if (lastChar == " ") {
      log(gameID+" "+value.substring(0, value.length - 1));
      _socketMethods.sendUserInput(value.substring(0, value.length - 1), gameID);
      setState(() {
        _wordsController.text = "";
      });
    }
  }

  findPlayerMe(GameStateProvider game) {
    game.gameState['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<GameStateProvider>(context);
    final clientStateProvider = Provider.of<ClientStateProvider>(context);
      return TextFormField(
      readOnly: gameData.gameState['canJoin'],
      controller: _wordsController,
      onChanged: (val) => handleTextChange(val, gameData.gameState['id']),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 3, color: Colors.black),
            borderRadius: BorderRadius.circular(50.0),
          ),
          filled: true,
          fillColor: Colors.grey,
        ),
    );
  }
}