import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/components/button.dart';
import '../../../core/utils/socket_methods.dart';

class MultiplayerSettings extends StatefulWidget {
  const MultiplayerSettings({super.key});

  @override
  State<MultiplayerSettings> createState() => _MultiplayerSettingsState();
}

class _MultiplayerSettingsState extends State<MultiplayerSettings> {
  late double height,width;
  TextEditingController nameController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();
  late String difficulty;

  @override
  void initState() {
    difficulty = 'easy';
    _socketMethods.updateGameListener(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Multiplayer Settings"),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: width*0.1),
        children: [
          Image.asset('assets/images/multiplayer.png'),
          Container(
            margin: EdgeInsets.only(bottom: height*0.05),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                    ),
                    hintText: "Enter Name"
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    const Text("Select difficulty", style: TextStyle(fontSize: 16),),
                    SizedBox(width: 20,),
                    DropdownButton<String>(
                      // Step 3.
                      value: difficulty,
                      // Step 4.
                      items: <String>['easy', 'medium', 'hard'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                      // Step 5.
                      onChanged: (String? newValue) {
                        setState(() {
                          difficulty = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Button(title: 'Join Game',onTap: joinGame)
        ],
      )
    );
  }

  void joinGame(BuildContext context) {
    String name = nameController.text;
    if(name.isEmpty) {
      var snackBar = const SnackBar(content: Text('Enter your Name!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      _socketMethods.startGame(
        name, difficulty, 'multiplayer', 60
      );
    }
  }
}
