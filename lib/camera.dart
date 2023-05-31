import 'dart:ui';
import 'utilities.dart';
import 'animation.dart';
import 'game.dart';

class Camera extends FAnimation {

  Offset targetPosition = Offset.zero;
  Offset currentPosition = Offset.zero;
  Offset renderPosition = Offset.zero;
  Offset _viewOffset = Offset.zero;

  double scaling = 1.0;

  static final Game game = Game();

  Camera(){
    game.moveCallback = onMove;
    targetPosition = currentPosition = renderPosition = game.playerPosition().toOffset();
    setDuration(0.15);
  }

  void onMove() {

    currentPosition = renderPosition;
    targetPosition = game.playerPosition().toOffset();
    restart();

  }

  static Offset clamp(Offset offset, Offset min, Offset max){

    double x = offset.dx;
    double y = offset.dy;

    if(offset.dx < min.dx){
      x = min.dx;
    }

    if(offset.dx > max.dx){
      x = max.dx;
    }

    if(offset.dy < min.dy){
      y = min.dy;
    }

    if(offset.dy > max.dy){
      y = max.dy;
    }

    return Offset(x, y);

  }

  void addOffset(Offset offset){

    double px = game.playerPosition().x * 50.0;
    double py = game.playerPosition().y * 50.0;

    double x = -game.level().width * 50.0;
    double y = -game.level().height * 50.0;

    Offset min = Offset(x + px, y + py);
    Offset max = Offset(px, py);

    _viewOffset = clamp(_viewOffset + offset, min, max);

  }

  void translateView(Canvas canvas, Size size){

    update(1.0 / 60.0);

    canvas.scale(scaling);

    Offset center = (Offset(size.width / 2.0 / scaling, size.height / 2.0 / scaling));
    Offset offset = center - renderPosition * 50.0 + _viewOffset;

    canvas.translate(offset.dx, offset.dy);

  }

  @override
  void process(double deltaTime) {
    renderPosition = Utilities.easeInOut(currentPosition, targetPosition, progress(), 2);
    _viewOffset = Utilities.easeInOut(_viewOffset, Offset.zero, progress(), 1);
  }

}