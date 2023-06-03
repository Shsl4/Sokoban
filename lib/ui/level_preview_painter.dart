import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sokoban/game/level.dart';
import 'package:sokoban/game/resources.dart';

class LevelPreviewPainter extends CustomPainter {

  static final Resources resources = Resources.instance();
  static final Paint backPaint = Paint()..color = Colors.white..isAntiAlias = true;

  final int levelId;

  LevelPreviewPainter(this.levelId);

  @override
  void paint(Canvas canvas, Size size) {

    Level level = resources.level(levelId);

    double boxDim;
    Size offset;

    boxDim = min(size.width, size.height) / max(level.width, level.height);

    offset = Size((size.width - boxDim * level.width) / 2.0, (size.height - boxDim * level.height) / 2.0);

    drawTiles(level, canvas, boxDim, offset);

  }

  void drawTiles(Level level, Canvas canvas, double boxDim, Size offset){

    Rect srcRect = const Rect.fromLTWH(0, 0, 128, 128);

    int x = 0;
    int y = 0;

    for(var row in level.content){

      for (var tile in row){

        Rect destRect = Rect.fromLTWH(offset.width + boxDim * x, offset.height + boxDim * y, boxDim, boxDim);

        if(tile != TileType.empty && tile != TileType.hole){
          canvas.drawImageRect(resources.groundTexture(), srcRect, destRect, backPaint);
        }

        switch(tile){

          case TileType.empty:
          case TileType.ground:
          case TileType.playerStart:
            break;

          case TileType.box:
            canvas.drawImageRect(resources.boxTexture(), srcRect, destRect, backPaint);
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}