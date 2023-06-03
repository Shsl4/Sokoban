import 'package:flutter/material.dart';
import 'package:sokoban/ui/level_painter.dart';
import 'package:sokoban/game/resources.dart';
import 'package:sokoban/utilities/audio.dart';
import 'package:sokoban/widgets/controls_menu.dart';
import 'package:sokoban/widgets/game_view.dart';
import 'package:sokoban/widgets/level_preview.dart';
import 'package:sokoban/widgets/levels_menu.dart';
import 'package:sokoban/widgets/main_menu.dart';
import 'package:sokoban/widgets/sokoban_button.dart';

void main() {
  runApp(const SokobanApp());
}

class SokobanApp extends StatefulWidget {

  const SokobanApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SokobanAppState();

}

enum ViewTypes{
  mainMenu,
  gameView,
  levelsMenu,
  controlsView
}

class _SokobanAppState extends State<SokobanApp>{

  ViewTypes _viewType = ViewTypes.mainMenu;

  _SokobanAppState(){
    Resources.instance().load().then((value) => setState((){
      Audio.playMusic(Resources.instance().music);
    }));
  }

  Widget selectWidget() {

    switch(_viewType){

      case ViewTypes.mainMenu:

        return MainMenu(

            onStart: () => setState(() {
              _viewType = ViewTypes.gameView;
            }),

            onLevels: () => setState(() {
              _viewType = ViewTypes.levelsMenu;
            }),

            onControls: () => setState(() {
              _viewType = ViewTypes.controlsView;
            })

        );

      case ViewTypes.gameView:

        return GameView(onMenu: () => setState(() {
          _viewType = ViewTypes.mainMenu;
        }));

      case ViewTypes.levelsMenu:

        return LevelsMenu(
          onStart: () => setState(() {
            _viewType = ViewTypes.gameView;
          }),
          onLeave: () => setState(() {
            _viewType = ViewTypes.mainMenu;
          }),
        );

      case ViewTypes.controlsView:

        return ControlsMenu(
            onLeave: () => setState(() {
              _viewType = ViewTypes.mainMenu;
            })
        );

    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sokoban',
        theme: ThemeData(

          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontSize: 72.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        home: Scaffold(
          body: Stack(
            children: [
              CustomPaint(
                painter: BackgroundPainter(),
                child: Container(),
              ),
              SafeArea(child: selectWidget()),
              SafeArea(child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Row(
                    children: [
                      SokobanButton(
                          onPressed: () => setState(() => Audio.toggleMuteEffects()),
                          size: const Size(50, 50),
                          filled: false,
                          child: Icon(Audio.effectsMuted() ? Icons.volume_off : Icons.volume_up)
                      ),
                      SokobanButton(
                          onPressed: () => setState(() => Audio.toggleMuteMusic()),
                          size: const Size(50, 50),
                          filled: false,
                          child: Icon(Audio.musicMuted() ? Icons.music_off : Icons.music_note)
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        )
    );
  }

  }
