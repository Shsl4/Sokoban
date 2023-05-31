import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sokoban/ui/animator.dart';
import 'package:sokoban/game/level.dart';
import 'package:sokoban/utilities/utilities.dart';
import 'dart:ui' as ui;
import 'dart:async';

class SpriteSequence {

  List<ui.Image> images = [];

  SpriteSequence();

  void loadAll(List<String> files) async {

    for(var str in files){
      images.add(await Resources._loadImage('assets/sprites/$str'));
    }

  }

}

class SpriteSequenceAnimator extends Animator {

  SpriteSequence seq;
  double _current = 0.0;

  SpriteSequenceAnimator(this.seq, double duration){
    setDuration(duration);
  }

  ui.Image currentFrame(){
    return seq.images[_current.floor()];
  }

  void updateSequence(SpriteSequence s){
    stop();
    seq = s;
  }

  @override
  void process(double deltaTime) {
    _current = Utilities.lerpd(0.0, (seq.images.length - 1).toDouble(), Utilities.spike(progress()));
  }

}

class Resources {

  static final Resources _instance = Resources._internal();

  Resources._internal();

  static Resources instance(){
    return _instance;
  }

  bool _loaded = false;

  bool valid() {
    return _loaded;
  }

  final SpriteSequence _playerRight = SpriteSequence();
  final SpriteSequence _playerLeft = SpriteSequence();
  final SpriteSequence _playerUp = SpriteSequence();
  final SpriteSequence _playerDown = SpriteSequence();

  ui.Image? _box;
  ui.Image? _ground;
  ui.Image? _wall;
  ui.Image? _hole;
  ui.Image? _target;

  final List<Level> _levels = [];

  Future<void> load() async {

    if(valid()) return;

    _playerRight.loadAll(["droite_0.png", "droite_1.png", "droite_2.png"]);
    _playerLeft.loadAll(["gauche_0.png", "gauche_1.png", "gauche_2.png"]);
    _playerUp.loadAll(["haut_0.png", "haut_1.png", "haut_2.png"]);
    _playerDown.loadAll(["bas_0.png", "bas_1.png", "bas_2.png"]);

    _box = await _loadImage('assets/sprites/caisse.png');
    _ground = await _loadImage('assets/sprites/sol.png');
    _wall = await _loadImage('assets/sprites/bloc.png');
    _hole = await _loadImage('assets/sprites/trou.png');
    _target = await _loadImage('assets/sprites/cible.png');

    var levelData = await _loadJson('assets/levels.json');

    for(var data in levelData){
        _levels.add(Level(data['largeur'], data['hauteur'], data['lignes']));
    }

    _loaded = true;

  }

  Level level(int index){
    if(!validLevel(index)) throw Exception('Invalid level index provided.');
    return _levels[index];
  }

  bool validLevel(int index) {
    return index >= 0 && index < _levels.length;
  }

  SpriteSequence playerRight() {
    return _playerRight;
  }

  SpriteSequence playerLeft() {
    return _playerLeft;
  }

  SpriteSequence playerUp() {
    return _playerUp;
  }

  SpriteSequence playerDown() {
    return _playerDown;
  }

  ui.Image boxTexture() {
    return _box!;
  }

  ui.Image groundTexture() {
    return _ground!;
  }

  ui.Image wallTexture() {
    return _wall!;
  }

  ui.Image holeTexture() {
    return _hole!;
  }

  ui.Image targetTexture() {
    return _target!;
  }

  static Future<ui.Image> _loadImage(String fichier) async {

    ExactAssetImage assetImage = ExactAssetImage(fichier);

    AssetBundleImageKey key = await assetImage.obtainKey(const ImageConfiguration());

    final ByteData data = await key.bundle.load(key.name);

    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    var frame = await codec.getNextFrame();

    return frame.image;

  }

  Future<List<dynamic>> _loadJson(String filePath) async {
    var input = await rootBundle.loadString(filePath);
    return jsonDecode(input);
  }

}
