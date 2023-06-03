import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sokoban/game/game.dart';
import 'package:sokoban/game/level.dart';
import 'package:sokoban/game/resources.dart';
import 'package:sokoban/ui/particle.dart';
import 'package:sokoban/ui/camera.dart';

class LevelPainter extends CustomPainter {

  static final Game game = Game.instance();
  static final Resources resources = Resources.instance();
  static final Camera camera = Camera();
  static final Paint backPaint = Paint()..color = Colors.black..isAntiAlias = true;
  static final ParticleManager particleManager = ParticleManager(100);
  static final SpriteSequenceAnimator playerAnim = SpriteSequenceAnimator(resources.playerRight(), 0.25);

  final double dt;

  static final Rect srcRect = const Rect.fromLTWH(0, 0, 128, 128);


  LevelPainter(this.dt);

  @override
  void paint(Canvas canvas, Size size) {

    if(!game.levelLoaded()) return;

    playerAnim.update(dt);
    particleManager.paint(canvas, size, dt);
    camera.translateView(canvas, size, dt);

    // Render the tiles on a separate canvas then draw the rendered image on
    // the original canvas. This is done to prevent small lines from appearing
    // in between tiles due to decimal point imprecision when translating or
    // scaling the camera.
    final recorder = PictureRecorder();
    Canvas tileCanvas = Canvas(recorder);

    // Draw the tiles on the new canvas
    drawTiles(tileCanvas);

    // Calculate the image size
    Size sz = Size(game.level().width * 50, game.level().height * 50);

    // Convert to an image
    var tiles = recorder.endRecording().toImageSync(sz.width.toInt(), sz.height.toInt());

    // Draw the rendered picture onto the original canvas
    canvas.drawImage(tiles, Offset.zero, backPaint);

    // Draw the boxes
    game.boxManager.renderBoxes(canvas, dt);

    // Draw the character
    Rect destRect = Rect.fromLTWH(camera.renderPosition.x * 50.0, camera.renderPosition.y * 50.0, 50, 50);
    canvas.drawImageRect(playerAnim.currentFrame(), srcRect, destRect, Paint());

  }

  void drawTiles(Canvas canvas){

    Level level = game.level();

    int x = 0;
    int y = 0;

    for(var row in level.content){

      for (var tile in row){

        Rect destRect = Rect.fromLTWH(50.0 * x, 50.0 * y, 50, 50);

        if(tile != TileType.empty && tile != TileType.hole){
          canvas.drawImageRect(resources.groundTexture(), srcRect, destRect, backPaint);
        }

        switch(tile){

          case TileType.empty:
          case TileType.ground:
          case TileType.box:
          case TileType.playerStart:
            break;

          case TileType.wall:
            canvas.drawImageRect(resources.wallTexture(), srcRect, destRect, backPaint);
            break;

          case TileType.target:
            canvas.drawImageRect(resources.targetTexture(), srcRect, destRect, backPaint);
            break;

          case TileType.hole:
            canvas.drawImageRect(resources.holeTexture(), srcRect, destRect, backPaint);
            break;

        }

        ++x;

      }

      ++y;

      x = 0;

    }

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