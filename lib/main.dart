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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  Game game = Game();
  int currentLevel = 0;

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
    //print(details.delta);
  }

  void onKey(RawKeyEvent event){

    if(event is RawKeyDownEvent && !event.repeat){

      if(event.logicalKey.keyLabel == 'Arrow Down'){
        game.applyMove(Operations.down);
      }

      if(event.logicalKey.keyLabel == 'Arrow Up'){
        game.applyMove(Operations.up);
      }

      if(event.logicalKey.keyLabel == 'Arrow Left'){
        game.applyMove(Operations.left);
      }

      if(event.logicalKey.keyLabel == 'Arrow Right'){
        game.applyMove(Operations.right);
      }

      if(event.logicalKey.keyLabel == 'R'){
        game.reset();
      }

      if(event.logicalKey.keyLabel == 'U'){
        game.undo();
      }

      if(game.checkWin()){
        currentLevel++;
        reloadLevel();
      }
      
    }

  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: onKey,
        child: Scaffold(
        body: GestureDetector(
            onPanUpdate: onDrag,
            child: CustomPaint(
                child: Container(),
                painter: MyPainter()
            ),
          ),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 1000 ~/ 60);
    Timer.periodic(duration, (timer) {
      setState(() {
      });
    });
  }
}
