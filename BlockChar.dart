import 'package:flutter/src/material/colors.dart';

class BlokChar {
  String? text;
  String? correctText;
  int? index;
  bool isFocus = false;
  bool isCorrect;
  bool isDefault;
  bool isExist = false;
  bool? isGivenByUser;

  BlokChar(
    this.text, {
    this.index,
    this.isDefault = false,
    this.correctText,
    this.isCorrect = false,
    this.isGivenByUser
  });

  // declare method used

  get isCorrectPos => correctText == text;
  setText(String text) {
    this.text = text;
    isCorrect = isCorrectPos;
    isGivenByUser = isCorrectPos;
  }

  setEmpty() {
    text = "";
    isCorrect = false;
  }

  void setColor(MaterialColor green) {}
}
