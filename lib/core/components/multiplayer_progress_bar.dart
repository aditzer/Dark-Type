import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../features/multiplayer_mode/provider/game_state_provider.dart';

class MultiplayerProgressBar extends StatelessWidget {
  const MultiplayerProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final game = Provider.of<GameStateProvider>(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.black),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: game.gameState['players'].length,
        itemBuilder: (context, index) {
          var playerData = game.gameState['players'][index];
          var totalWords = game.gameState['text'].length;
          var wordsDone = playerData['currentWordIndex'];
          var percentage = (100*wordsDone/totalWords);
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(playerData['name']),
                  Visibility(
                      visible: playerData['WPM']>=0,
                      child: Text("(${playerData['WPM']} WPM)"),
                  ),
                  SizedBox(width: 10),
                  LinearPercentIndicator(
                    width: width*0.5,
                    lineHeight: 20,
                    percent: wordsDone/totalWords,
                    center: Text(
                      "${percentage.round()} %",
                      style: new TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                    backgroundColor: Colors.black,
                    progressColor: Colors.amber,
                  ),
                ],
              ),
              SizedBox(height: 5,),
            ],
          );
        },
      ),
    );
  }
}