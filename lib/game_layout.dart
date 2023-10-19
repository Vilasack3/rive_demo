import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive_demo/rive_button.dart';

import 'colors.dart';
import 'end_state.dart';
import 'enums.dart';

class FindTheDogScreen extends StatefulWidget {
  const FindTheDogScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FindTheDogScreen> createState() => _FindTheDogScreen();
}

class _FindTheDogScreen extends State<FindTheDogScreen> {
  final _random = Random();
  int guessesLeft = 25;
  bool didLose = false;
  int animationsRunning = 0;

  GameStatus gameState = GameStatus.inProgress;

  void _handleGuessTap(isWrongGuess) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (isWrongGuess) {
      setState(() {
        animationsRunning++;
        if (guessesLeft == 1) {
          didLose = true;
          gameState = GameStatus.lost;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }
        if (guessesLeft > 0) {
          guessesLeft--;
        }
      });
    } else {
      setState(() {
        animationsRunning++;
        gameState = GameStatus.won;
      });
    }
  }

  void _handleStateEnter(String stateMachineName, String toStateName) {
    if (toStateName == "Pressed_wrong_static") {
      setState(() {
        animationsRunning--;
      });
    } else if (toStateName == "Pressed_wrong") {
      _handleGuessTap(true);
      var snackBar = SnackBar(
        content: Text(
          "$guessesLeft guess${guessesLeft == 1 ? "" : "es"} left!",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: GameColors.snackbarText,
          ),
        ),
        width: 300.0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: GameColors.snackbarBg,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (toStateName == "Pressed_correct") {
      _handleGuessTap(false);
    } else if (toStateName == "Pressed_correct_static") {
      setState(() {
        animationsRunning--;
      });
    }
  }

  int _getDogIdx() {
    return 0 + _random.nextInt(8 - 0);
  }

  // Render 20 widgets, of which one is the true dog button
  List<Widget> renderButtons() {
    int dogIdx = _getDogIdx();
    List<Widget> list = List.empty(growable: true);
    for (var i = 0; i < 15; i++) {
      bool isReal = i == dogIdx;
      list.add(
        RiveButton(
          isReal: isReal,
          stateChangeCb: _handleStateEnter,
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: GameColors.primary,
      ),
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
              color:
                  gameState == GameStatus.inProgress || animationsRunning >= 1
                      ? GameColors.background
                      : GameColors.backgroundEndState),
          child: gameState == GameStatus.inProgress || animationsRunning >= 1
              ? GridView.count(
                  crossAxisCount: 5, children: [...renderButtons()])
              : EndState(gameState: gameState),
        ),
      ),
    );
  }
}
