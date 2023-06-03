import 'package:sokoban/game/vector2d.dart';

enum TileType {
  empty,
  playerStart,
  wall,
  ground,
  box,
  target,
  hole
}

class Level {

  final int width;
  final int height;

  Vector2d playerStart = Vector2d.zero;
  List<Vector2d> boxStarts = [];
  List<Vector2d> targetPositions = [];
  List<List<TileType>> content = [];

  Level(this.width, this.height, List<dynamic> data) {

    int y = 0;

    for(var row in data){

      bool inside = false;
      var tiles = List<TileType>.filled(width, TileType.empty);

      for(int x = 0; x < row.length; ++x){

        var type = row[x];

        switch (type){

          case '\$':
            tiles[x] = TileType.box;
            boxStarts.add(Vector2d(x.toDouble(), y.toDouble()));
            break;

          case '#':
            tiles[x] = TileType.wall;
            inside = !inside;
            break;

          case '@':
            tiles[x] = TileType.ground;
            playerStart = Vector2d(x.toDouble(), y.toDouble());
            break;

          case '.':
            tiles[x] = TileType.target;
            targetPositions.add(Vector2d(x.toDouble(), y.toDouble()));
            break;

          default:
            break;

        }

      }

      content.add(tiles);
      ++y;

    }

    for(int y = 0; y < height; ++y){

      for(int x = 0; x < width; ++x){

        if(content[y][x] == TileType.empty && isInside(x, y)){
          content[y][x] = TileType.ground;
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

      if(content[tileY][x] == TileType.wall){

        if(x < tileX){
          leftWall = true;
        }
        else{
          rightWall = true;
        }

      }

    }

    for(int y = 0; y < height; ++y){

      if(content[y][tileX] == TileType.wall){

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