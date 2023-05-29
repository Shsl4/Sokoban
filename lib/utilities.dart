import 'dart:math';
import 'dart:ui';

class Utilities {

  static final random = Random.secure();

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

  static Offset easeInOut(Offset from, Offset to, double t, int easePower) {
    return lerpVec(from, to, lerpd(pow(t, easePower), flipd(pow(flipd(t), easePower)), t));
  }

  static Offset lerpVec(Offset from, Offset to, double t){
    return from + (to - from) * t;
  }

  static Offset roundUpVec(Offset off, int multiple){
    return Offset(Utilities.roundUp(off.dx, multiple), Utilities.roundUp(off.dy, multiple));
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
