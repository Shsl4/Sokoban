import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sokoban/game/game.dart';
import 'package:sokoban/game/vector2d.dart';
import 'package:sokoban/ui/level_painter.dart';
import 'package:sokoban/ui/resources.dart';
import 'package:sokoban/widgets/autorefresh.dart';
import 'package:sokoban/widgets/overlay_menu.dart';
import 'package:sokoban/widgets/tap_view.dart';

class GameView extends StatefulWidget{

  const GameView({Key? key}) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();

}

class _GameViewState extends State<GameView>{

  Game game = Game();
  int currentLevel = 0;
  bool paused = false;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  _GameViewState() {
    Resources.instance().load().then((value) => {
      game.readState().then((value) => {
        if(!value){
          reloadLevel()
        }
      })
    });
  }

  @override
  Widget build(BuildContext context) {

    return Listener(
        child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: onKey,
            child: Stack(
              children: makeChildren(),
            )
        )
    );

  }

  void reloadLevel(){
    game.loadLevel(currentLevel);
    setState((){});
  }

  void onScaleStart(ScaleStartDetails details){
    _baseScaleFactor = _scaleFactor;
  }

  void onScale(ScaleUpdateDetails details){
    LevelPainter.camera.addOffset(Vector2d.fromOffset(details.focalPointDelta));
    _scaleFactor = (_baseScaleFactor * details.scale).clamp(0.5, 1.5);
    LevelPainter.camera.setScale(_scaleFactor);
  }

  void receiveOp(Operations op){

    game.applyMove(op);

    if(game.checkWin()){
      currentLevel++;
      reloadLevel();
    }

  }

  void pauseMenu(bool value){

    setState(() {
      paused = value;
    });

  }

  void onKey(RawKeyEvent event){

    if(event is RawKeyDownEvent && !event.repeat){

      if(event.logicalKey.keyLabel == 'Arrow Down'){
        receiveOp(Operations.down);
      }

      if(event.logicalKey.keyLabel == 'Arrow Up'){
        receiveOp(Operations.up);
      }

      if(event.logicalKey.keyLabel == 'Arrow Left'){
        receiveOp(Operations.left);
      }

      if(event.logicalKey.keyLabel == 'Arrow Right'){
        receiveOp(Operations.right);
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

      if(game.checkWin()){
        currentLevel++;
        reloadLevel();
      }

    }

  }

  Widget generatePainter(double dt){
    return CustomPaint(
        painter: LevelPainter(dt),
        child: Container()
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

    display.add(TapView(receiveOp, () => pauseMenu(true)));

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
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            child: const Icon(Icons.rotate_left)
        )
    ));

    if(paused){

      display.add(OverlayMenu(
          title: 'Paused',
          leftButtonAction: () => pauseMenu(false),
          leftButtonText: 'Continue',
          rightButtonText: 'Exit',
          rightButtonAction: null)
      );

    }

    return display;

  }

}