import 'package:sokoban/level.dart';
import 'package:sokoban/resources.dart';

enum Operations{
  none,
  up,
  down,
  left,
  right
}

class Move {

  Operations op;
  bool push;

  Move(this.op, this.push);

}

class Game {

  int levelIndex = -1;
  List<Move> moves = [];
  Vector2D _playerPosition = Vector2D.zero();
  List<Vector2D> _boxPositions = [];
  Level? _currentState;

  static final _instance = Game._internal();

  Game._internal();

  factory Game() { return _instance; }

  void reset(){
    loadLevel(levelIndex);
  }

  bool loadLevel(int index){

    try{
      _currentState = Resources().level(index);
      _playerPosition = Vector2D(_currentState!.playerStart.x, _currentState!.playerStart.y);
      _boxPositions = List.from(_currentState!.boxStarts);
      levelIndex = index;
      moves = [];
    }
    catch(e){
      return false;
    }

    return true;

  }

  TileType tile(Vector2D v){
    return _currentState!.content[v.y][v.x];
  }

  List<Vector2D> boxes(){
    return _boxPositions;
  }

  Vector2D offsetFromOperation(Operations op){

    switch(op){

      case Operations.none:
        return Vector2D.zero();

      case Operations.up:
        return Vector2D(0, -1);

      case Operations.down:
        return Vector2D(0, 1);

      case Operations.left:
        return Vector2D(-1, 0);

      case Operations.right:
        return Vector2D(1, 0);

    }
  }

  bool checkWin(){

    for(var box in _boxPositions){
      if(!_currentState!.targetPositions.contains(box)){
        return false;
      }
    }

    return true;

  }

  bool applyMove(Operations op) {

    if(!levelLoaded()) throw Exception('Trying to apply a move but no level is loaded!');

    Vector2D offset = offsetFromOperation(op);

    Vector2D targetPosition = _playerPosition + offset;
    Vector2D nextPosition = _playerPosition + (offset * 2);

    if(outOfBounds(nextPosition)) return false;

    TileType targetTile = tile(targetPosition);
    TileType nextTile = tile(nextPosition);
    bool push = false;

    if(blockingTile(targetTile)) return false;

    if(_boxPositions.contains(targetPosition)){

      if(!blockingTile(nextTile) && !_boxPositions.contains(nextPosition)){

        var box = _boxPositions.indexOf(targetPosition);
        _boxPositions[box] += offset;
        push = true;

      }
      else{
        return false;
      }

    }

    _playerPosition += offset;

    moves.add(Move(op, push));

    return true;

  }

  bool undo(){

    if(moves.isEmpty) return false;

    Move move = moves.last;
    Vector2D offset = offsetFromOperation(move.op);
    Vector2D boxOffset = _playerPosition + offset;

    if(move.push && _boxPositions.contains(boxOffset)){
      var box = _boxPositions.indexOf(boxOffset);
      _boxPositions[box] += -offset;
    }
    
    _playerPosition += -offset;

    moves.removeAt(moves.length - 1);
    return true;

  }

  bool outOfBounds(Vector2D v){
    return v.x < 0 || v.x > _currentState!.width - 1 ||
        v.y < 0 || v.y > _currentState!.height - 1;
  }

  bool blockingTile(TileType tile){
    return (tile == TileType.Void || tile == TileType.Wall || tile == TileType.Hole);
  }

  Level level(){
    if(!levelLoaded()) throw Exception('Trying to get the level state but no level is loaded!');
    return _currentState!;
  }

  Vector2D playerPosition(){
    return _playerPosition;
  }

  bool levelLoaded(){
    return _currentState != null;
  }

}