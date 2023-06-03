import 'package:flutter/material.dart';
import 'package:sokoban/game/game.dart';
import 'package:sokoban/game/resources.dart';
import 'package:sokoban/widgets/level_preview.dart';
import 'package:sokoban/widgets/sokoban_button.dart';

class LevelsMenu extends StatelessWidget{

  final PageController _controller = PageController(initialPage: 0, keepPage: false);
  final Function() onLeave;
  final Function() onStart;

  LevelsMenu({super.key, required this.onLeave, required this.onStart});

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
        Row(
          children: [
            const Spacer(),
            SokobanButton(
                size: const Size(50, 50),
                onPressed: () {
                _controller.animateToPage((_controller.page! - 1.0).toInt(),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.linear);
                },
                child: const Text('<')
            ),
            const Spacer(),
            Expanded(
                flex: 10,
                child: PageView(
                    clipBehavior: Clip.antiAlias,
                    controller: _controller,
                    children: previews()
                )
            ),
            const Spacer(),
            SokobanButton(
                size: const Size(50, 50),
                onPressed: () {
                  _controller.animateToPage((_controller.page! + 1.0).ceil().toInt(),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutSine);
                },
                child: const Text('>')
            ),
            const Spacer()
          ],
        )
      ],
    );
  }


  List<Widget> previews(){

    List<Widget> widgets = [];

    for(int i = 0; i < Resources.instance().levelCount(); ++i){
      widgets.add(LevelPreview(i,
        onStart: () {
          Game.instance().loadLevel(i);
          onStart();
        }
      ));
    }

    return widgets;

  }

}