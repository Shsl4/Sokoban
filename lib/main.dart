import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'resources.dart';
import 'my_painter.dart';
import 'game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );

  }

}

class TapView extends StatelessWidget {

  Function(Operations) tap;
  Function() longPress;

  TapView(this.tap, this.longPress);

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

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  Game game = Game();
  int currentLevel = 0;
  bool paused = false;

  _MyHomePageState(){
    Resources().load().then((value) => {
      reloadLevel()
    });
  }

  void reloadLevel(){
    game.loadLevel(currentLevel);
    setState((){});
  }

  void onDrag(DragUpdateDetails details){
    MyPainter.camera.drawOffset += details.delta;
  }

  void onScale(ScaleUpdateDetails details){

    // MyPainter.camera.drawOffset += details.focalPointDelta;
    // RMyPainter.camera.scaling = details.scale;

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

  Widget buttons() {

    return Row(
      children: [
        Spacer(),
        ElevatedButton(
          onPressed: () => pauseMenu(false),
          child: Text('Resume'),
          style: ButtonStyle(
            minimumSize: MaterialStatePropertyAll<Size>(Size(125, 40)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () => {},
          child: Text('Exit'),
          style: ButtonStyle(
            minimumSize: MaterialStatePropertyAll<Size>(Size(125, 40)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        Spacer()
      ],
    );

  }


  List<Widget> makeChildren() {

    List<Widget> display = [];

    display.add(Scaffold(
        body: GestureDetector(
          onScaleUpdate: onScale,
          child: CustomPaint(
              child: Container(),
              painter: MyPainter()
          ),
        )
    ));

    display.add(TapView(receiveOp, () => pauseMenu(true)));

    display.add(Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
          onLongPress: () => game.reset(),
          onPressed: () => game.undo(),
          child: Icon(Icons.rotate_left),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shape:MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // <-- Radius
            )),
            minimumSize: MaterialStatePropertyAll<Size>(Size(75, 75)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          )
      )
    ));

    if(paused){

      display.add(Stack(
        children: [
          Container(color: Color.fromARGB(200, 0, 0, 0)),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 350,
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 3),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    children: [
                      Spacer(),
                      Text('Menu', style: TextStyle(color: Colors.red, decoration: TextDecoration.none)),
                      Spacer(),
                      buttons(),
                      Spacer()
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ));

    }

    return display;

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

  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 1000 ~/ 60);
    Timer.periodic(duration, (timer) {
      setState(() {});
    });
  }
}
