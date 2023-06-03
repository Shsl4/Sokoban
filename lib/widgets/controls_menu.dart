import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sokoban/game/game.dart';
import 'package:sokoban/game/resources.dart';
import 'package:sokoban/widgets/level_preview.dart';
import 'package:sokoban/widgets/sokoban_button.dart';

class ControlsMenu extends StatelessWidget{

  final Function() onLeave;

  const ControlsMenu({super.key, required this.onLeave});

  static const TextStyle mediumStyle = TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold);
  static const TextStyle titleStyle = TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold);
  static const TextStyle regularStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: SokobanButton(
              size: const Size(50, 50),
              onPressed: onLeave,
              child: const Text('X')
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
          padding: const EdgeInsets.all(10.0),
          width: 400,
            child: const Column(
              children: [
                Spacer(flex: 6),
                Text('Controls', style: titleStyle),
                Spacer(flex: 2),
                Text("Movement", style: mediumStyle),
                Spacer(),
                Text("Press the the arrow keys on the keyboard, or tap on the top/bottom/left/right parts of the screen to move",
                    style: regularStyle,
                    textAlign: TextAlign.center),
                Spacer(flex: 2),
                Text("Undo", style: mediumStyle),
                Spacer(),
                Text("Press U or the arrow at the bottom right corner of the screen to undo the last movement.",
                    style: regularStyle,
                    textAlign: TextAlign.center),
                Spacer(flex: 2),
                Text("Reset", style: mediumStyle),
                Spacer(),
                Text("Press R or long press the arrow at the bottom right corner of the screen to reset.",
                    style: regularStyle,
                    textAlign: TextAlign.center),
                Spacer(flex: 2),
                Text("Pause", style: mediumStyle),
                Spacer(),
                Text("Press Escape or long press anywhere on the screen to show the pause menu.",
                    style: regularStyle,
                    textAlign: TextAlign.center),
                Spacer(flex: 6)
              ],
            ),
          ),
        )
      ],
    );
  }

}