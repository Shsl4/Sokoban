import 'dart:ui';

enum TileType{
  Void,
  PlayerStart,
  Wall,
  Ground,
  Box,
  Target,
  Hole
}

class Vector2D {

  late int x;
  late int y;

  Vector2D.zero(){
    x = 0;
    y = 0;
  }

  Vector2D(this.x, this.y);

  Vector2D operator +(Vector2D other) => Vector2D(x + other.x, y + other.y);

  Vector2D operator -(Vector2D other) => Vector2D(x - other.x, y - other.y);

  Vector2D operator -() => Vector2D(-x, -y);

  Vector2D operator *(Object value) {
    if(value is int){
      return Vector2D(x * value, y * value);
    }
    if(value is double){
      return Vector2D((x * value).floor(), (y * value).floor());
    }
    throw Exception('Invalid operand');
  }

  Offset toOffset() {
    return Offset(x.toDouble(), y.toDouble());
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Vector2D &&
              runtimeType == other.runtimeType &&
              x == other.x &&
              y == other.y;

}

class Level {

  final int width;
  final int height;

  Vector2D playerStart = Vector2D.zero();
  List<Vector2D> boxStarts = [];
  List<Vector2D> targetPositions = [];
  List<List<TileType>> content = [];

  Level(this.width, this.height, List<dynamic> data) {

    int y = 0;

    for(var row in data){

      bool inside = false;
      var tiles = List<TileType>.filled(width, TileType.Void);

      for(int x = 0; x < row.length; ++x){

        var type = row[x];

        switch (type){

          case ' ':
            break;

          case '\$':
            tiles[x] = TileType.Box;
            boxStarts.add(Vector2D(x, y));
            break;

          case '#':
            tiles[x] = TileType.Wall;
            inside = !inside;
            break;

          case '@':
            tiles[x] = TileType.Ground;
            playerStart = Vector2D(x, y);
            break;

          case '.':
            tiles[x] = TileType.Target;
            targetPositions.add(Vector2D(x, y));
            break;

          case '*':
            tiles[x] = TileType.Hole;
            break;

          default:
            throw Exception('Unexpected symbol: $type');

        }

      }

      content.add(tiles);
      ++y;

    }

    for(int y = 0; y < height; ++y){

      for(int x = 0; x < width; ++x){

        if(content[y][x] == TileType.Void && isInside(x, y)){
          content[y][x] = TileType.Ground;
        }

      }

    }

  }

  bool isInside(int tileX, int tileY){

    bool leftWall = false;
    bool rightWall = false;
    bool topWall = false;
    bool bottomWall = false;

    for(int x = 0; x < width; ++x){

      if(content[tileY][x] == TileType.Wall){

        if(x < tileX){
          leftWall = true;
        }
        else{
          rightWall = true;
        }

      }

    }

    for(int y = 0; y < height; ++y){

      if(content[y][tileX] == TileType.Wall){

        if(y < tileY){
          topWall = true;
        }
        else{
          bottomWall = true;
        }

      }

    }

    return leftWall && rightWall && topWall && bottomWall;

  }

}