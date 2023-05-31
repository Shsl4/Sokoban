import 'package:flutter/material.dart';
import 'package:sokoban/game/game.dart';

class TapView extends StatelessWidget {

  final Function(Operations) tap;
  final Function() longPress;

  const TapView(this.tap, this.longPress, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: GestureDetector(
            onTap: () => tap(Operations.up),
            onLongPress: () => longPress()
        )),
        Expanded(child: Row(
            children: [
              Expanded(child: GestureDetector(
                  onTap: () => tap(Operations.left),
                  onLongPress: () => longPress()
              )),
              Expanded(child: GestureDetector(
                  onTap: () => tap(Operations.right),
                  onLongPress: () => longPress()
              ))
            ])),
        Expanded(child: GestureDetector(
            onTap: () => tap(Operations.down),
            onLongPress: () => longPress()
        ))
      ],
    );
  }
}
