import 'dart:ui';

import 'package:sokoban/game/game.dart';
import 'package:sokoban/game/vector2d.dart';
import 'package:sokoban/ui/animator.dart';
import 'package:sokoban/utilities/utilities.dart';

class Camera extends Animator {

  Vector2d targetPosition = Vector2d.zero;
  Vector2d currentPosition = Vector2d.zero;
  Vector2d renderPosition = Vector2d.zero;
  Vector2d _viewOffset = Vector2d.zero;

  double _scale = 1.0;

  static final Game game = Game.instance();

  Camera(){
    game.moveCallback = onMove;
    targetPosition = currentPosition = renderPosition = game.playerPosition();
    setDuration(0.15);
  }

  void onMove() {

    currentPosition = renderPosition;
    targetPosition = game.playerPosition();
    restart();

  }

  void setScale(double value){
    _scale = value.clamp(0.5, 1.5);
  }

  static Vector2d clamp(Vector2d offset, Vector2d min, Vector2d max){

    double x = offset.x;
    double y = offset.y;

    if(offset.x < min.x){
      x = min.x;
    }

    if(offset.x > max.x){
      x = max.x;
    }

    if(offset.y < min.y){
      y = min.y;
    }

    if(offset.y > max.y){
      y = max.y;
    }

    return Vector2d(x, y);

  }

  void addOffset(Vector2d offset){

    double px = game.playerPosition().x * 50.0;
    double py = game.playerPosition().y * 50.0;

    double x = -game.level().width * 50.0;
    double y = -game.level().height * 50.0;

    Vector2d min = Vector2d(x + px, y + py);
    Vector2d max = Vector2d(px, py);

    _viewOffset = clamp((_viewOffset + offset / _scale), min, max);

  }

  void translateView(Canvas canvas, Size size, double dt){

    update(dt);

    canvas.scale(_scale);

    Vector2d center = (Vector2d(size.width / 2.0 / _scale, size.height / 2.0 / _scale));
    Vector2d offset = Utilities.roundUpVec(center, 50) - renderPosition * 50.0 + _viewOffset;

    canvas.translate(offset.x, offset.y);

  }

  @override
  void process(double deltaTime) {
    renderPosition = Utilities.easeInOut(currentPosition, targetPosition, progress(), 2);
    _viewOffset = Utilities.easeInOut(_viewOffset, Vector2d.zero, progress(), 1);
  }

  void updatePosition() {
    renderPosition = currentPosition = targetPosition = game.playerPosition();
  }

}