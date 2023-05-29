import 'package:flutter/material.dart';
import 'resources.dart';
import 'level.dart';
import 'game.dart';
import 'camera.dart';
import 'particle.dart';

class MyPainter extends CustomPainter {

  static final Game game = Game();
  static final Resources resources = Resources();
  static final Camera camera = Camera();
  static final Paint backPaint = Paint()..color = Colors.black;
  static final ParticleManager particleManager = ParticleManager(100);

  @override
  void paint(Canvas canvas, Size size) {

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backPaint);

    if(!game.levelLoaded()) return;

    particleManager.paint(canvas, size);
    camera.translateView(canvas, size);
    drawTiles(canvas);

  }

  void drawTiles(Canvas canvas){

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

    Rect destRect = Rect.fromLTWH(camera.renderPosition.dx * 50.0, camera.renderPosition.dy * 50.0, 50, 50);

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