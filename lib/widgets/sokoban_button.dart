import 'package:flutter/material.dart';
import 'package:sokoban/game/resources.dart';
import 'package:sokoban/utilities/audio.dart';

class SokobanButton extends StatelessWidget {

  final Widget child;
  final Function()? onPressed;
  final Function()? onHover;
  final Size size;
  const SokobanButton({super.key, required this.child, required this.size, this.onPressed, this.onHover});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Audio.playEffect(Resources.instance().selectSound);
          if(onPressed != null) { onPressed!(); }
        },
        onHover: (value) {
          if(value) { Audio.playEffect(Resources.instance().hoverSound); }
          if(value && onHover != null) { onHover!(); }
        },
        style: ButtonStyle(
          minimumSize: MaterialStatePropertyAll<Size>(size),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: child
    );
  }

}