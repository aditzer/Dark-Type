import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/multiplayer_mode/provider/game_state_provider.dart';
import '../utils/socket_client.dart';
import '../utils/socket_methods.dart';
import 'multiplayer_progress_bar.dart';

class MultiplayerTextBox extends StatefulWidget {
  const MultiplayerTextBox({Key? key}) : super(key: key);

  @override
  State<MultiplayerTextBox> createState() => _MultiplayerTextBoxState();
}

class _MultiplayerTextBoxState extends State<MultiplayerTextBox> {
  var playerMe = null;
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateGame(context);
  }

  findPlayerMe(GameStateProvider game) {
    game.gameState['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

  Widget getTypedWords(words, player) {
    var tempWords = words.sublist(0, player['currentWordIndex']);
    String typedWord = tempWords.join(' ');
    return Text(
      typedWord+" ",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    );
  }

  Widget getCurrentWord(words, player) {
    return Text(
      words[player['currentWordIndex']]+" ",
      style: const TextStyle(
        color: Colors.blue,
        fontSize: 20,
      ),
    );
  }

  Widget getWordsToBeTyped(words, player) {
    var tempWords = words.sublist(player['currentWordIndex'] + 1, words.length);
    String wordstoBeTyped = tempWords.join(' ');
    return Text(
      wordstoBeTyped,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    findPlayerMe(game);
    if (game.gameState['text'].length > playerMe['currentWordIndex']) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.amber,
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Wrap(
          children: [
            getTypedWords(game.gameState['text'], playerMe),
            getCurrentWord(game.gameState['text'], playerMe),
            getWordsToBeTyped(game.gameState['text'], playerMe),
          ],
        ),
      );
    }
    return Container();
  }
}