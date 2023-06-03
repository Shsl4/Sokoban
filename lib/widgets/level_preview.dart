import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sokoban/ui/level_preview_painter.dart';
import 'package:sokoban/game/resources.dart';
import 'package:sokoban/widgets/sokoban_button.dart';

class LevelPreview extends StatelessWidget {

  final int levelId;
  final Function() onStart;

  const LevelPreview(this.levelId, {super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Text('Level ${levelId + 1}',
            style: const TextStyle(
                fontSize: 35
            )),
        const Spacer(),
        Expanded(
          flex: 6,
            child: CustomPaint(
              painter: LevelPreviewPainter(levelId),
              child: Container(
                color: Colors.transparent,
              ),
            )
        ),
        const Spacer(),
        SokobanButton(
            onPressed: onStart,
            size: const Size(250, 50),
            child: const Text('Start')
        ),
        const Spacer(),
      ],
    );

  }

}