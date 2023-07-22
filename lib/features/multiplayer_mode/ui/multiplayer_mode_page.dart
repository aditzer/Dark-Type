import 'package:dark_typer/core/components/multiplayer_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/components/multiplayer_text_box.dart';
import '../../../core/components/multiplayer_text_field.dart';
import '../../../core/utils/socket_methods.dart';
import '../provider/client_state_provider.dart';
import '../provider/game_state_provider.dart';

class MultiPlayerMode extends StatefulWidget {
  const MultiPlayerMode({super.key});

  @override
  State<MultiPlayerMode> createState() => _MultiPlayerModeState();
}

class _MultiPlayerModeState extends State<MultiPlayerMode> {
  final SocketMethods _socketMethods = SocketMethods();
  late double height, width;

  @override
  void initState() {
    _socketMethods.updateTimer(context);
    _socketMethods.updateGame(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    final game = Provider.of<GameStateProvider>(context);
    final clientStateProvider = Provider.of<ClientStateProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        _socketMethods.endGame();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
              title: const Text("Multiplayer Mode"),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Center(
                  child: Column(children: [
                    SizedBox(height: 20,),
                    Text(
                      clientStateProvider.clientState['timer']['message'].toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Time left: ${clientStateProvider.clientState['timer']['countDown']}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MultiplayerProgressBar(),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    MultiplayerTextBox(),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    MultiplayerTypingBox(),
                    SizedBox(
                      height: 30,
                    )
              ])),
            ],
          )),
    );
  }
}
