import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sokoban/game/game.dart';
import 'package:sokoban/game/resources.dart';
import 'package:sokoban/widgets/sokoban_button.dart';

class BackgroundPainter extends CustomPainter{

  static final Resources resources = Resources.instance();

  @override
  void paint(Canvas canvas, Size size) {

    if(!resources.valid()) return;

    Rect srcRect = const Rect.fromLTWH(0, 0, 1024, 1024);
    Rect destRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(resources.backgroundForest(), srcRect, destRect, Paint());

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class MainMenu extends StatelessWidget {

  final Function() onStart;
  final Function() onLevels;
  final Function() onControls;

  const MainMenu({super.key, required this.onStart, required this.onLevels, required this.onControls});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(flex: 6,
                child: SizedBox(
                  height: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      const Text("Sokoban",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.blue,
                              decoration: TextDecoration.none,
                              fontSize: 55
                          )
                      ),
                      const Spacer(),
                      SokobanButton(
                          onPressed: () {
                            Game.instance().readState().then((value) {
                              onStart();
                            });
                          },
                          size: const Size(250, 50),
                          child: const Text('Start')
                      ),
                      const Spacer(),
                      SokobanButton(
                          onPressed: onLevels,
                          size: const Size(250, 50),
                          child: const Text('Levels')
                      ),
                      const Spacer(),
                      SokobanButton(
                          onPressed: onControls,
                          size: const Size(250, 50),
                          child: const Text('Controls')
                      ),
                      const Spacer(flex: 2)
                    ],
                  ),
                )),
            Expanded(flex: 2, child: Container())
          ],
        )
      ],
    );
  }

}