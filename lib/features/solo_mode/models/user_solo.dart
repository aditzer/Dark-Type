import 'dart:developer';

class UserSolo {
  int index;
  int speed=0;
  DateTime startTime;
  int correctWordsCount;
  int wordsCount;

  UserSolo(this.index, this.speed, this.startTime, this.correctWordsCount, this.wordsCount);

  void calculateSpeed(DateTime currentTime) {
    Duration diff = currentTime.difference(startTime);
    speed = (60*(correctWordsCount/diff.inSeconds)).round();
  }
}