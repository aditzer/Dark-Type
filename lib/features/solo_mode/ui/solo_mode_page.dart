import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/components/button.dart';
import '../models/user_solo.dart';
import '../repository/solo_mode_repository.dart';

class SoloModePage extends StatefulWidget {
  final int gameTime;
  const SoloModePage({super.key, required this.gameTime});

  @override
  State<SoloModePage> createState() => _SoloModePageState();
}

class _SoloModePageState extends State<SoloModePage> {
  String difficulty = 'easy';
  List<String> list = [];
  bool isLoading = false;
  bool started = false;
  TextEditingController controller = TextEditingController();
  int typingSpeed = 0;
  late UserSolo user;
  String typedWords = "", nextWord = "";
  int totalTime = 60;
  Timer? timer;
  late double height, width;

  @override
  void initState() {
    fetchParagraph();
    totalTime = widget.gameTime;
    super.initState();
    controller.addListener(onTextChanged);
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void fetchParagraph() async {
    setState(() {
      isLoading = true;
    });
    list = await SoloModeRepository.fetchParagraph(difficulty);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            title: const Text("Solo Mode"),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white),
        body: isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : soloModeScreen(context));
  }

  Widget soloModeScreen(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        SizedBox(height: 20),
        Center(
          child: Text(
            "Time left: $totalTime",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: height * 0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Speed: $typingSpeed WPM",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            difficultyModeSwitch(),
          ],
        ),
        SizedBox(height: height * 0.1),
        textBox(),
        SizedBox(height: height * 0.1),
        typingBox(),
        SizedBox(height: height * 0.1),
        Visibility(
          visible: !started,
          child: Button(title: "Start", onTap: startGame),
        ),
      ],
    );
  }

  Widget difficultyModeSwitch() {
    Color easyModeColor, hardModeColor;
    if (difficulty == 'easy') {
      easyModeColor = Colors.green;
      hardModeColor = Colors.transparent;
    } else {
      easyModeColor = Colors.transparent;
      hardModeColor = Colors.red;
    }
    return Row(
      children: [
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: easyModeColor,
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text("Easy"),
            ),
          ),
          onTap: () async {
            timer?.cancel();
            setState(() {
              isLoading = true;
            });
            list = await SoloModeRepository.fetchParagraph('easy');
            resetGame();
            setState(() {
              difficulty = 'easy';
              isLoading = false;
            });
          },
        ),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: hardModeColor,
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text("Hard"),
            ),
          ),
          onTap: () async {
            timer?.cancel();
            setState(() {
              isLoading = true;
            });
            list = await SoloModeRepository.fetchParagraph('hard');
            resetGame();
            setState(() {
              isLoading = false;
              difficulty = 'hard';
            });
          },
        )
      ],
    );
  }

  Widget textBox() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.amber,
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Wrap(
        children: [
          Text(typedWords,
              style: const TextStyle(color: Colors.black, fontSize: 20)),
          Text(nextWord,
              style: const TextStyle(color: Colors.blue, fontSize: 20))
        ],
      ),
    );
  }

  Widget typingBox() {
    return TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(50.0),
        ),
        filled: true,
        fillColor: Colors.grey,
      ),
      controller: controller,
    );
  }

  void onTextChanged() {
    String text = controller.text;
    if (started == false) {
      return;
    }
    if (text.contains(' ')) {
      if (user.index >= list.length) {
        endGame();
      }
      if ("${list[user.index]} " == text) {
        user.correctWordsCount++;
      }
      user.calculateSpeed(DateTime.now());
      setState(() {
        typingSpeed = user.speed;
      });
      //end of list
      if (user.index == list.length - 1) {
        endGame();
      }
      setState(() {
        typedWords += "${list[user.index]} ";
        nextWord = list[user.index + 1];
      });
      user.index++;
      user.wordsCount++;
      controller.clear();
    }
  }

  void startGame(BuildContext context) {
    int index = 0, speed = 0, correctWordsCount = 0, wordsCount = 0;
    controller.clear();
    setState(() {
      typedWords = "";
      nextWord = list[0];
      started = true;
    });
    var startTime = DateTime.now();
    user = UserSolo(index, speed, startTime, correctWordsCount, wordsCount);
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if(totalTime == 0){
          timer.cancel();
          endGame();
          return;
        }
        setState(() {
          totalTime--;
        });
      },
    );
  }

  void resetGame() {
    int index = 0, speed = 0, correctWordsCount = 0, wordsCount = 0;
    controller.clear();
    timer?.cancel();
    setState(() {
      typingSpeed = 0;
      typedWords = "";
      nextWord = "";
      started = false;
      totalTime = widget.gameTime;
    });
    user = UserSolo(index, speed, DateTime.now(), correctWordsCount, wordsCount);
  }

  void endGame() {
    int speed = user.speed;
    int accuracy = 0;
    if(user.wordsCount>0) accuracy=((100*user.correctWordsCount)/user.wordsCount).round();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Time is up!"),
        content: Text("Your Speed: $speed WPM, Your Accuracy: $accuracy%"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              child: const Text("Main Menu"),
            ),
          ),
        ],
      ),
    );
  }
}
