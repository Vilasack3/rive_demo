import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'enums.dart';

class EndState extends StatelessWidget {
  const EndState({Key? key, required this.gameState}) : super(key: key);

  final GameStatus gameState;

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset('assets/findthedog.riv',
        artboard:
            gameState == GameStatus.lost ? "LoseEndState" : "WinEndState");
  }
}
