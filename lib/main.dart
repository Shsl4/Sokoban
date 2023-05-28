import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sokoban/resources.dart';
import 'package:sokoban/my_painter.dart';
import 'package:sokoban/game.dart';

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
      home: MyHomePage(title: 'Niveau 1'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key, required this.title}) : super(key: key);

  String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}


//La classe principale
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
    widget.title = 'Niveau ${currentLevel + 1}';
    setState((){});
  }

  void onDrag(DragUpdateDetails details){
    print(details.delta);
  }

  void onKey(RawKeyEvent event){

    if(event is RawKeyDownEvent){

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

      setState(() {});

    }

  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: onKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          //Le widget principal est la zone de dessin (un canvas) : on lui passe la hauteur de l'écran moins la hauteur de l'appBar et la hauteur de la barre de notif, la largeur de l'écran et les ressources
          body: GestureDetector(
            onPanUpdate: onDrag,
            child: CustomPaint(
                painter: MyPainter(MediaQuery.of(context).size.height-56-24, MediaQuery.of(context).size.width)
            ),
          ),
        )
    );
  }
}
