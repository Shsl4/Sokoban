import 'package:flutter/material.dart';
import 'package:sokoban/game/resources.dart';
import 'package:sokoban/utilities/audio.dart';

class SokobanButton extends StatelessWidget {

  final Widget child;
  final Function()? onPressed;
  final Function()? onHover;
  final Function()? onLongPress;
  final Size size;
  final bool filled;
  const SokobanButton({super.key, required this.child, required this.size, this.onPressed, this.onLongPress, this.onHover, this.filled = true});

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
        onLongPress: onLongPress,
        style: style(),
        child: child
    );
  }

  ButtonStyle style(){

    if(filled){
      return ButtonStyle(
        minimumSize: MaterialStatePropertyAll<Size>(size),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      );
    }
    return ButtonStyle(
      minimumSize: MaterialStatePropertyAll<Size>(size),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black54),
      splashFactory: NoSplash.splashFactory,
      shape:MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // <-- Radius
      )),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
      shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
    );
  }

}