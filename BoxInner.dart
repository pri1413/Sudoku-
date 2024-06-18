import 'package:flutter/src/material/colors.dart';
import 'package:sudoku/blokChar.dart';

class BoxInner {
  late int index;
  List<BlokChar> blokChars = List<BlokChar>.from([]);
  bool isFull;
  BoxInner(this.index, this.blokChars,{this.isFull=false});

  // declare method used
  setFocus(int index, Direction direction) {
    List<BlokChar> temp;

    if (direction == Direction.Horizontal) {
      temp = blokChars
          .where((element) => element.index! ~/ 3 == index ~/ 3)
          .toList();
    } else {
      temp = blokChars
          .where((element) => element.index! % 3 == index % 3)
          .toList();
    }

    temp.forEach((element) {
      element.isFocus = true;
    });
  }

  setExistValue(
      int index, int indexBox, String textInput, Direction direction) {
    List<BlokChar> temp;

    if (direction == Direction.Horizontal) {
      temp = blokChars
          .where((element) => element.index! ~/ 3 == index ~/ 3)
          .toList();
    } else {
      temp = blokChars
          .where((element) => element.index! % 3 == index % 3)
          .toList();
    }

    if (this.index == indexBox) {
      List<BlokChar> blokCharsBox =
          blokChars.where((element) => element.text == textInput).toList();

      if (blokCharsBox.length == 1 && temp.isEmpty) blokCharsBox.clear();

      temp.addAll(blokCharsBox);
    }

    temp.where((element) => element.text == textInput).forEach((element) {
      element.isExist = true;
    });
  }

  clearFocus() {
    blokChars.forEach((element) {
      element.isFocus = false;
    });
  }

  clearExist() {
    blokChars.forEach((element) {
      element.isExist = false;
    });
  }

  void setColor(MaterialColor green) {}
}

enum Direction { Horizontal, Vertical }
