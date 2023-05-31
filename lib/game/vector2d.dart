import 'dart:ui';

class Vector2d {

  double x;
  double y;

  Vector2d(this.x, this.y);

  Vector2d.fromOffset(Offset offset) : x = offset.dx, y = offset.dy;

  Vector2d.fromJson(dynamic map) : x = map["x"], y = map["y"];

  Map<String, dynamic> toJson() => {"x": x, "y": y};

  static final Vector2d zero = Vector2d(0, 0);

  Vector2d operator +(Vector2d other) => Vector2d(x + other.x, y + other.y);

  Vector2d operator -(Vector2d other) => Vector2d(x - other.x, y - other.y);

  Vector2d operator -() => Vector2d(-x, -y);

  Vector2d operator *(Object value) {
    if(value is int){
      return Vector2d(x * value, y * value);
    }
    if(value is double){
      return Vector2d(x * value, y * value);
    }
    throw Exception('Invalid operand');
  }

  Vector2d operator /(Object value) {
    if(value is int){
      return Vector2d(x / value, y / value);
    }
    if(value is double){
      return Vector2d(x / value, y / value);
    }
    throw Exception('Invalid operand');
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Vector2d &&
              runtimeType == other.runtimeType &&
              x == other.x &&
              y == other.y;

}