import 'dart:ui';

import 'package:sokoban/game/vector2d.dart';
import 'package:sokoban/ui/animator.dart';
import 'package:sokoban/ui/resources.dart';
import 'package:sokoban/utilities/utilities.dart';

class BoxManager {

  List<Box> boxes = [];

  void setup(List<Vector2d> newBoxes){

    reset();

    for(var pos in newBoxes){
      boxes.add(Box(pos));
    }

  }

  Box? findBox(Vector2d offset){

    for(var box in boxes){

      if(box.position() == offset){
        return box;
      }

    }

    return null;

  }

  List<Vector2d> asList(){
    return List<Vector2d>.from(boxes.map((e) => e.position()));
  }

  void reset(){
    boxes.clear();
  }

  void renderBoxes(Canvas canvas, double dt){

    for(var box in boxes){
      box.paint(canvas, dt);
    }

  }


}

class Box extends Animator {

  Vector2d _lastPosition;
  Vector2d _renderPosition = Vector2d.zero;
  Vector2d _targetPosition = Vector2d.zero;

  Box(this._lastPosition){
    _renderPosition = _targetPosition = _lastPosition;
    setDuration(0.15);
  }

  void move(Vector2d offset){
    _lastPosition = _renderPosition;
    _targetPosition += offset;
    restart();
  }

  Vector2d position() => _targetPosition;

  @override
  void finished(){
    _lastPosition = _targetPosition;
  }

  void paint(Canvas canvas, double dt){

    update(dt);

    Rect srcRect = const Rect.fromLTWH(0, 0, 128, 128);
    Rect destRect = Rect.fromLTWH(50.0 * _renderPosition.x, 50.0 * _renderPosition.y, 50, 50);
    canvas.drawImageRect(Resources.instance().boxTexture(), srcRect, destRect, Paint());

  }

  @override
  void process(double deltaTime) {
    _renderPosition = Utilities.easeInOut(_lastPosition, _targetPosition, progress(), 2);
  }

}
