import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sokoban/game/game.dart';
import 'package:sokoban/game/vector2d.dart';
import 'package:sokoban/ui/level_painter.dart';
import 'package:sokoban/game/resources.dart';
import 'package:sokoban/utilities/audio.dart';
import 'package:sokoban/widgets/autorefresh.dart';
import 'package:sokoban/widgets/overlay_menu.dart';
import 'package:sokoban/widgets/tap_view.dart';

class GameView extends StatefulWidget{

  final Function() onMenu;

  const GameView({Key? key, required this.onMenu}) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();

}

class _GameViewState extends State<GameView>{

  Game game = Game.instance();
  bool paused = false;
  bool levelFinished = false;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  _GameViewState();

  @override
  Widget build(BuildContext context) {

    return Listener(
        child: RawKeyboardListener(
            autofocus: true,
            focusNode: FocusNode(),
            onKey: onKey,
            child: Stack(
              children: makeChildren(),
            )
        )
    );

  }

  void reloadLevel(){
    game.reset();
    setState((){
      levelFinished = false;
    });
  }

  void onScaleStart(ScaleStartDetails details){
    _baseScaleFactor = _scaleFactor;
  }

  void onScale(ScaleUpdateDetails details){
    LevelPainter.camera.addOffset(Vector2d.fromOffset(details.focalPointDelta));
    _scaleFactor = (_baseScaleFactor * details.scale).clamp(0.5, 1.5);
    LevelPainter.camera.setScale(_scaleFactor);
  }

  void move(Operations op){

    game.applyMove(op);

    if(game.checkWin()){
      Audio.playEffect(Resources.instance().completeSound);
      setState((){
        levelFinished = true;
      });
    }

  }

  void pauseMenu(bool value){

    setState(() {
      paused = value;
    });

  }

  void onKey(RawKeyEvent event){

    if(levelFinished) return;

    if(event is RawKeyDownEvent && !event.repeat){

      if(event.logicalKey.keyLabel == 'Arrow Down'){
        move(Operations.down);
      }

      if(event.logicalKey.keyLabel == 'Arrow Up'){
        move(Operations.up);
      }

      if(event.logicalKey.keyLabel == 'Arrow Left'){
        move(Operations.left);
      }

      if(event.logicalKey.keyLabel == 'Arrow Right'){
        move(Operations.right);
      }

      if(event.logicalKey.keyLabel == 'R'){
        game.reset();
      }

      if(event.logicalKey.keyLabel == 'U'){
        game.undo();
      }

      if(event.logicalKey.keyLabel == 'Escape'){
        pauseMenu(!paused);
      }

    }

  }

  Widget generatePainter(double dt){
    return Stack(
      children: [
        CustomPaint(
            painter: LevelPainter(dt),
            child: Container()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Moves: ${game.moves.length}",
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              )
            ),
            Text("Undos: ${game.undos}",
              style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              )
            )
          ],
        )
      ],
    );
  }

  List<Widget> makeChildren() {

    List<Widget> display = [];

    display.add(Scaffold(
        body: GestureDetector(
            onScaleStart: onScaleStart,
            onScaleUpdate: onScale,
            child: AutoRefresh(
                refreshRate: 60,
                widgetGenerator: generatePainter
            )
        )
    ));

    display.add(TapView(move, () => pauseMenu(true)));

    display.add(Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
            onLongPress: () => game.reset(),
            onPressed: () => game.undo(),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shape:MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              )),
              minimumSize: const MaterialStatePropertyAll<Size>(Size(75, 75)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            child: const Icon(Icons.rotate_left)
        )
    ));

    if(levelFinished){

      if(game.loadedLevelIndex() + 1 == Resources.instance().levelCount()){

        display.add(OverlayMenu(
            title: 'All levels finished!',
            leftButtonAction: () {
              game.unloadLevel();
              widget.onMenu();
            },
            leftButtonText: 'Menu',
            rightButtonText: null,
            rightButtonAction: null
        ));

      }
      else{

        display.add(OverlayMenu(
            title: 'Level finished!',
            leftButtonAction: () {
              game.unloadLevel();
              widget.onMenu();
            },
            leftButtonText: 'Menu',
            rightButtonText: 'Next level',
            rightButtonAction: () {
              game.loadNextLevel();
              setState(() {
                levelFinished = false;
              });
            })
        );

      }

      return display;

    }

    if(paused){

      display.add(OverlayMenu(
          title: 'Paused',
          leftButtonAction: () => pauseMenu(false),
          leftButtonText: 'Continue',
          rightButtonText: 'Menu',
          rightButtonAction: () {
            game.unloadLevel();
            widget.onMenu();
          })
      );

    }

    return display;

  }

}