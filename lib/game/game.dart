import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sokoban/game/box_manager.dart';
import 'package:sokoban/game/level.dart';
import 'package:sokoban/game/vector2d.dart';
import 'package:sokoban/ui/level_painter.dart';
import 'package:sokoban/game/resources.dart';
import 'package:sokoban/utilities/audio.dart';

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

  Move.fromJson(dynamic map) : op = Operations.values.firstWhere((element) => element.toString() == map["op"]), push = map["push"];

  Map<String, dynamic> toJson(){
    return {
      "op": op.toString(),
      "push": push
    };
  }

}

class Game {

  int _levelIndex = -1;
  Function()? moveCallback;
  List<Move> moves = [];
  BoxManager boxManager = BoxManager();
  Vector2d _playerPosition = Vector2d.zero;
  Level? _currentState;
  int undos = 0;

  static final _instance = Game._internal();

  Game._internal();

  static Game instance() { return _instance; }

  void loadLevel(int index){

    _currentState = Resources.instance().level(index);
    _playerPosition = Vector2d(_currentState!.playerStart.x, _currentState!.playerStart.y);
    boxManager.setup(List.from(_currentState!.boxStarts));
    _levelIndex = index;
    moves = [];
    undos = 0;

    LevelPainter.camera.updatePosition();

    if(moveCallback != null){
      moveCallback!();
    }

  }

  void unloadLevel(){

    if(checkWin()){
      int s = _levelIndex + 1;
      _clear();
      _levelIndex = s;
    }

    writeState().then((value) {
      _clear();
    });

  }

  void _clear(){

    _currentState = null;
    _playerPosition = Vector2d.zero;
    boxManager.reset();
    moves = [];
    _levelIndex = -1;

  }

  void reset(){
    loadLevel(_levelIndex);
  }

  TileType tile(Vector2d v){
    return _currentState!.content[v.y.floor()][v.x.floor()];
  }

  Vector2d offsetFromOperation(Operations op){

    switch(op){

      case Operations.none:
        return Vector2d.zero;

      case Operations.up:
        return Vector2d(0, -1);

      case Operations.down:
        return Vector2d(0, 1);

      case Operations.left:
        return Vector2d(-1, 0);

      case Operations.right:
        return Vector2d(1, 0);

    }
  }

  bool checkWin(){

    for(var box in boxManager.boxes){
      if(!_currentState!.targetPositions.contains(box.position())){
        return false;
      }
    }

    return true;

  }

  bool applyMove(Operations op) {

    if(!levelLoaded()) throw Exception('Trying to apply a move but no level is loaded!');

    Vector2d offset = offsetFromOperation(op);

    Vector2d targetPosition = _playerPosition + offset;
    Vector2d nextPosition = _playerPosition + (offset * 2);

    if(outOfBounds(nextPosition)) return false;

    TileType targetTile = tile(targetPosition);
    TileType nextTile = tile(nextPosition);
    bool push = false;

    if(blockingTile(targetTile)) return false;

    Box? box = boxManager.findBox(targetPosition);

    if(box != null){

      Box? nextBox = boxManager.findBox(nextPosition);

      if(!blockingTile(nextTile) && nextBox == null){

        box.move(offset);
        push = true;

      }
      else{
        return false;
      }

    }

    _playerPosition += offset;

    moves.add(Move(op, push));

    if(moveCallback != null){
      moveCallback!();
    }

    Audio.playEffect(push ? Resources.instance().moveBoxSound : Resources.instance().randomMoveSound());

    LevelPainter.notifyMove(op);

    // Save every 20 moves
    if((moves.length + undos) % 20 == 0){
      writeState();
    }

    return true;

  }

  void loadNextLevel(){

    _levelIndex++;
    loadLevel(_levelIndex);
    writeState();

  }

  Operations lastOp() {

    if(moves.isEmpty) return Operations.none;

    return moves.last.op;

  }

  bool undo(){

    if(moves.isEmpty) return false;

    Move move = moves.last;
    Vector2d offset = offsetFromOperation(move.op);
    Vector2d boxOffset = _playerPosition + offset;

    Box? box = boxManager.findBox(boxOffset);

    if(move.push && box != null){
      box.move(-offset);
    }
    
    _playerPosition += -offset;

    moves.removeAt(moves.length - 1);

    if(moveCallback != null){
      moveCallback!();
    }

    LevelPainter.notifyMove(move.op);

    Audio.playEffect(move.push ? Resources.instance().moveBoxSound : Resources.instance().randomMoveSound());

    undos++;

    // Save every 20 moves
    if((moves.length + undos) % 20 == 0){
      writeState();
    }

    return true;

  }

  bool outOfBounds(Vector2d v){
    return v.x < 0.0 || v.x > _currentState!.width - 1.0 ||
        v.y < 0.0 || v.y > _currentState!.height - 1.0;
  }

  bool blockingTile(TileType tile){
    return (tile == TileType.empty || tile == TileType.wall || tile == TileType.hole);
  }

  Level level(){
    if(!levelLoaded()) throw Exception('Trying to get the level state but no level is loaded!');
    return _currentState!;
  }

  Vector2d playerPosition(){
    return _playerPosition;
  }

  bool levelLoaded(){
    return _currentState != null;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _saveFile async {
    final path = await _localPath;
    return File('$path/save.txt');
  }

  Future<File> writeState() async {

    final file = await _saveFile;

    Map<String, dynamic> sv = {
      "level": _levelIndex,
      "playerPosition": _playerPosition,
      "boxes": boxManager.asList(),
      "moves": moves
    };

    return file.writeAsString(jsonEncode(sv));

  }


  Future<bool> saveExists() async {

    try{
      await _saveFile;
      return true;
    }
    catch(e){
      return false;
    }


  }

  Future<bool> readState() async {

    try {

      final file = await _saveFile;

      final contents = jsonDecode(await file.readAsString());

      var boxes = contents["boxes"];
      var mvs = contents["moves"];

      loadLevel(contents["level"]);

      if(!boxes.isEmpty){
        _playerPosition = Vector2d.fromJson(contents["playerPosition"]);
        boxManager.setup(List<Vector2d>.from(boxes.map((obj) => Vector2d.fromJson(obj))));
        moves = List<Move>.from(mvs.map((obj) => Move.fromJson(obj)));
      }

      LevelPainter.camera.updatePosition();

      return true;

    } catch(e) {

      loadLevel(0);
      return false;

    }

  }

  int loadedLevelIndex(){
    return _levelIndex;
  }

}
