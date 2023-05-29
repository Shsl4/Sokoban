import 'dart:ui';
import 'utilities.dart';
import 'animation.dart';
import 'game.dart';

class Camera extends FAnimation {

  Offset targetPosition = Offset.zero;
  Offset currentPosition = Offset.zero;
  Offset renderPosition = Offset.zero;
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

  void translateView(Canvas canvas, Size size){

    update(1.0 / 60.0);

    const scaling = 1.5;

    canvas.scale(scaling);

    Offset center = Utilities.roundUpVec(Offset(size.width / 2.0 / scaling, size.height / 2.0 / scaling), 50);
    Offset offset = center - renderPosition * 50.0;

    canvas.translate(offset.dx, offset.dy);

  }

  @override
  void process(double deltaTime) {
    renderPosition = Utilities.easeInOut(currentPosition, targetPosition, progress(), 2);
  }

}