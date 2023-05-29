import 'package:flutter/material.dart';
import 'package:sokoban/resources.dart';
import 'package:sokoban/level.dart';
import 'package:sokoban/game.dart';

class MyPainter extends CustomPainter {

  double height;
  double width;
  Game game = Game();
  Resources resources = Resources();

  MyPainter(this.height, this.width);

  @override
  void paint(Canvas canvas, Size size) {

    if(!game.levelLoaded()) return;

    Rect srcRect = const Rect.fromLTWH(0, 0, 128, 128);

    Level level = game.level();
    int x = 0;
    int y = 0;

    for(var row in level.content){

      for (var tile in row){

        Rect destRect = Rect.fromLTWH(50.0 * x, 50.0 * y, 50, 50);

        if(tile != TileType.Void && tile != TileType.Hole){
          canvas.drawImageRect(resources.groundTexture(), srcRect, destRect, Paint());
        }

        switch(tile){

          case TileType.Void:
          case TileType.Ground:
          case TileType.Box:
          case TileType.PlayerStart:
            break;

          case TileType.Wall:
            canvas.drawImageRect(resources.wallTexture(), srcRect, destRect, Paint());
            break;

          case TileType.Target:
            canvas.drawImageRect(resources.targetTexture(), srcRect, destRect, Paint());
            break;

          case TileType.Hole:
            canvas.drawImageRect(resources.holeTexture(), srcRect, destRect, Paint());
            break;

        }

        ++x;

      }

      ++y;

      x = 0;

    }

    for(var pos in game.boxes()){
      Rect destRect = Rect.fromLTWH(50.0 * pos.x, 50.0 * pos.y, 50, 50);
      canvas.drawImageRect(resources.boxTexture(), srcRect, destRect, Paint());
    }

    var pos = game.playerPosition();
    Rect destRect = Rect.fromLTWH(50.0 * pos.x, 50.0 * pos.y, 50, 50);

    canvas.drawImageRect(selectPlayerTexture(), srcRect, destRect, Paint());

  }

  dynamic selectPlayerTexture() {

    Operations op = game.lastOp();

    switch(op){

      case Operations.none:
        return resources.playerRight();
      case Operations.up:
        return resources.playerTop();
      case Operations.down:
        return resources.playerDown();
      case Operations.left:
        return resources.playerLeft();
      case Operations.right:
        return resources.playerRight();
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}