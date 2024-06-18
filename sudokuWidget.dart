import 'dart:math';
import 'package:flutter/material.dart';  
import 'package:quiver/iterables.dart';   //DO NOT CHANGE IN THE FILE
import 'package:sudoku/blokChar.dart';
import 'package:sudoku/boxInner.dart';
import 'package:sudoku/focusClass.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';   //DO NOT CHANGE IN THE FILE

class SudokuWidget extends StatefulWidget { 
  const SudokuWidget({Key? key}) : super(key: key);

  @override
  State<SudokuWidget> createState() => _SudokuWidgetState();
}

class _SudokuWidgetState extends State<SudokuWidget> {
  // our variable

  List<BoxInner> boxInners = [];
  FocusClass focusClass = FocusClass();
  bool isFinish = false;
  String? tapBoxIndex;

  @override
  void initState() {
    generateSudoku();

    // TODO: implement initState
    super.initState();
  }

  void generateSudoku() {
    isFinish = false;
    focusClass = FocusClass();
    tapBoxIndex = null;
    generatePuzzle();
    checkFinish();

    setState(() {});
  }
  //  void startTimer() {
  //   timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
  //     setState(() {
  //       secondsElapsed++;
  //     });
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    // lets put on ui

    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(onPressed: () => generateSudoku(), child: const Icon(Icons.refresh)),
        ],
      ),
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              ///outer
              Container(
                margin: const EdgeInsets.all(20),
                // height: 400,
                color: Colors.blueGrey,
                padding: const EdgeInsets.all(5),
                width: double.maxFinite,
                alignment: Alignment.center,
                child: GridView.builder(
                  /// outer 9 box
                  itemCount: boxInners.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  physics: const ScrollPhysics(),
                  itemBuilder: (buildContext, index) {
                    BoxInner boxInner = boxInners[index];
                    return Container(
                      color: Colors.red.shade100,
                      alignment: Alignment.center,
                      child: GridView.builder(
                        /// inner 9 box 1 sudoko
                        itemCount: boxInner.blokChars.length,
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        physics: const ScrollPhysics(),
                        itemBuilder: (buildContext, indexChar) {
                          BlokChar blokChar = boxInner.blokChars[indexChar];
                          Color color = Colors.yellow.shade100;
                          Color colorText = Colors.black;

                        // Change color base condition

                          if (isFinish) {
                            color = Colors.green;
                          } else if (blokChar.isFocus && blokChar.text != "") {
                            color = Colors.brown.shade100;
                          } else if (blokChar.isDefault) {
                            color = Colors.grey.shade400;
                          }

                          if (tapBoxIndex == "${index}-${indexChar}" && !isFinish) {
                            color = Colors.blue.shade100;
                          }

                          if (isFinish) {
                            colorText = Colors.white;
                          } else if (blokChar.isExist) {
                            colorText = Colors.red;
                          }else if (blokChar.isGivenByUser==true && boxInner.blokChars.any((element) => element.text=="")==true) {
                            colorText = Colors.green;
                          }

                          return Container(
                            color: (boxInner.blokChars.any((element) => element.isCorrect==false)==false && boxInner.isFull==false /*&& boxInner.blokChars.any((element) => element.text=="")==false*/) ? Colors.green : color,
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: blokChar.isDefault
                                  ? null
                                  : () => setFocus(index, indexChar),
                              child: Text(
                                "${blokChar.text}",
                                style: TextStyle(color: colorText),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: GridView.builder(
                          itemCount: 9,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          physics: const ScrollPhysics(),
                          itemBuilder: (buildContext, index) {
                            return ElevatedButton(
                              onPressed: () => setInput(index + 1),
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            onPressed: () => setInput(null),
                            child: Container(
                              child: const Text(
                                "Clear",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  generatePuzzle() {
    // install plugins sudoku generator to generate one
    boxInners.clear(); 
    var sudokuGenerator = SudokuGenerator(emptySquares: 5); //54
    // then we populate to get a possible combination
    // Quiver for easy populate collection using partition
    List<List<List<int>>> completes = partition(sudokuGenerator.newSudokuSolved, sqrt(sudokuGenerator.newSudoku.length).toInt()).toList();
    partition(sudokuGenerator.newSudoku, sqrt(sudokuGenerator.newSudoku.length).toInt()).toList().asMap().entries.forEach(
      (entry) {
        List<int> tempListCompletes = completes[entry.key].expand((element) => element).toList();
        List<int> tempList = entry.value.expand((element) => element).toList();

        tempList.asMap().entries.forEach((entryIn) {
          int index = entry.key * sqrt(sudokuGenerator.newSudoku.length).toInt() + (entryIn.key % 9).toInt() ~/ 3;

          if (boxInners.where((element) => element.index == index).length == 0) {
            boxInners.add(BoxInner(index, []));
          }
          BoxInner boxInner = boxInners.where((element) => element.index == index).first;
          boxInner.blokChars.add(BlokChar(
            entryIn.value == 0 ? "" : entryIn.value.toString(),
            index: boxInner.blokChars.length,
            isDefault: entryIn.value != 0,
            isCorrect: entryIn.value != 0,
            correctText: tempListCompletes[entryIn.key].toString(),
          ));

        });
      },
    );
    boxInners.forEach((box) {
      if(box.blokChars.any((blok) => blok.text=="")==true){
        box.isFull=false;
      }else{
        box.isFull=true;
      }
    });
    // complte generate puzzle sudoku
  }

  setFocus(int index, int indexChar) {
    tapBoxIndex = "$index-$indexChar";
    focusClass.setData(index, indexChar);
    showFocusCenterLine();
    setState(() {});
  }

  void showFocusCenterLine() {
    // set focus color for line vertical & horizontal
    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    this.boxInners.forEach((element) => element.clearFocus());

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach(
        (e) => e.setFocus(focusClass.indexChar!, Direction.Horizontal));

    boxInners
        .where((element) => element.index % 3 == colNoBox)
        .forEach((e) => e.setFocus(focusClass.indexChar!, Direction.Vertical));
  }

  setInput(int? number) {
    // set input data based grid
    // or clear out data
    if (focusClass.indexBox == null) return;
    if (boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text == number.toString() || number == null)
    {
      boxInners.forEach((element) {
        element.clearFocus();
        element.clearExist();
      });
      boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].setEmpty();
      tapBoxIndex = null;
      isFinish = false;
      showSameInputOnSameLine();
    }
    else {
      boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].setText("$number");

      showSameInputOnSameLine();

      checkFinish();
    }

    setState(() {});
  }

  void showSameInputOnSameLine() {
    // show duplicate number on same line vertical & horizontal so player know he or she put a wrong value on somewhere

    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    String textInput =
        boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text!;

    boxInners.forEach((element) => element.clearExist());

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Horizontal));

    boxInners.where((element) => element.index % 3 == colNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Vertical));

    List<BlokChar> exists = boxInners
        .map((element) => element.blokChars)
        .expand((element) => element)
        .where((element) => element.isExist)
        .toList();

    if (exists.length == 1) exists[0].isExist = false;
  }

  void checkFinish() {
    int totalUnfinish = boxInners
        .map((e) => e.blokChars)
        .expand((element) => element)
        .where((element) => !element.isCorrect)
        .length;

    isFinish = totalUnfinish == 0;
  }
}
