import 'package:flutter/material.dart';
import 'package:sokoban/game/game.dart';
import 'package:sokoban/game/level.dart';
import 'package:sokoban/ui/resources.dart';
import 'package:sokoban/ui/particle.dart';
import 'package:sokoban/ui/camera.dart';

class LevelPainter extends CustomPainter {

  static final Game game = Game();
  static final Resources resources = Resources.instance();
  static final Camera camera = Camera();
  static final Paint backPaint = Paint()..color = Colors.black;
  static final ParticleManager particleManager = ParticleManager(100);
  static final SpriteSequenceAnimator playerAnim = SpriteSequenceAnimator(resources.playerRight(), 0.25);

  final double dt;

  LevelPainter(this.dt);

  @override
  void paint(Canvas canvas, Size size) {

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backPaint);

    if(!game.levelLoaded()) return;

    playerAnim.update(dt);
    particleManager.paint(canvas, size);
    camera.translateView(canvas, size, dt);
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

        if(tile != TileType.empty && tile != TileType.hole){
          canvas.drawImageRect(resources.groundTexture(), srcRect, destRect, Paint());
        }

        switch(tile){

          case TileType.empty:
          case TileType.ground:
          case TileType.box:
          case TileType.playerStart:
            break;

          case TileType.wall:
            canvas.drawImageRect(resources.wallTexture(), srcRect, destRect, Paint());
            break;

          case TileType.target:
            canvas.drawImageRect(resources.targetTexture(), srcRect, destRect, Paint());
            break;

          case TileType.hole:
            canvas.drawImageRect(resources.holeTexture(), srcRect, destRect, Paint());
            break;

        }

        ++x;

      }

      ++y;

      x = 0;

    }

    game.boxManager.renderBoxes(canvas, dt);

    Rect destRect = Rect.fromLTWH(camera.renderPosition.x * 50.0, camera.renderPosition.y * 50.0, 50, 50);
    canvas.drawImageRect(playerAnim.currentFrame(), srcRect, destRect, Paint());

  }

  static SpriteSequence selectPlayerTexture(Operations op) {

    switch(op){

      case Operations.none:
        return resources.playerRight();
      case Operations.up:
        return resources.playerUp();
      case Operations.down:
        return resources.playerDown();
      case Operations.left:
        return resources.playerLeft();
      case Operations.right:
        return resources.playerRight();
    }

  }

  static void notifyMove(Operations op) {
    playerAnim.updateSequence(selectPlayerTexture(op));
    playerAnim.restart();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}