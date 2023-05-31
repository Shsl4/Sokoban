import 'package:flutter/material.dart';
import 'package:sokoban/widgets/game_view.dart';

void main() {
  runApp(const SokobanApp());
}

class SokobanApp extends StatelessWidget {

  const SokobanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Sokoban',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameView(),
    );

  }

}
