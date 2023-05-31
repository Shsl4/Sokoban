import 'dart:math';
import 'package:sokoban/game/vector2d.dart';

class Utilities {

  static final random = Random.secure();

  static double easeIn(double t)
  {
    return t * t;
  }

  static double spike(double t) {

    if (t <= 0.5) {
      return easeIn(t / 0.5);
    }

    return easeIn(flipd(t)/ 0.5);

  }


  static double randomDouble(double minValue, double maxValue, int precision) {

    final v = minValue + (maxValue - minValue) * random.nextDouble();
    return double.parse(v.toStringAsFixed(precision));

  }

  static double lerpd(num from, num to, double t){
    return from + (to - from) * t;
  }

  static double flipd(num v) {
    return 1.0 - v;
  }

  static Vector2d easeInOut(Vector2d from, Vector2d to, double t, int easePower) {
    return lerpVec(from, to, lerpd(pow(t, easePower), flipd(pow(flipd(t), easePower)), t));
  }

  static Vector2d lerpVec(Vector2d from, Vector2d to, double t){
    return from + (to - from) * t;
  }

  static Vector2d roundUpVec(Vector2d off, int multiple){
    return Vector2d(Utilities.roundUp(off.x, multiple), Utilities.roundUp(off.y, multiple));
  }

  static double roundUp(double numToRound, int multiple) {

    if (multiple == 0) {
      return numToRound.roundToDouble();
    }

    int remainder = numToRound.round() % multiple;

    if (remainder == 0) {
      return numToRound;
    }

    return numToRound.roundToDouble() - multiple + remainder;

  }

}
