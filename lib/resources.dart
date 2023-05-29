import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:sokoban/level.dart';
import 'package:sokoban/game.dart';

class Resources {

  static final Resources _instance = Resources._internal();

  Resources._internal();

  factory Resources(){
    return _instance;
  }

  bool _loaded = false;

  bool valid() {
    return _loaded;
  }

  ui.Image? _playerRight0;
  ui.Image? _playerLeft0;
  ui.Image? _playerTop0;
  ui.Image? _playerDown0;
  ui.Image? _box;
  ui.Image? _ground;
  ui.Image? _wall;
  ui.Image? _hole;
  ui.Image? _target;

  final List<Level> _levels = [];

  Future<void> load() async {

    if(valid()) return;

    _playerRight0 = await _loadImage('assets/sprites/droite_0.png');
    _playerLeft0 = await _loadImage('assets/sprites/gauche_0.png');
    _playerTop0 = await _loadImage('assets/sprites/haut_0.png');
    _playerDown0 = await _loadImage('assets/sprites/bas_0.png');
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

  ui.Image playerRight() {
    return _playerRight0!;
  }

  ui.Image playerLeft() {
    return _playerLeft0!;
  }

  ui.Image playerTop() {
    return _playerTop0!;
  }

  ui.Image playerDown() {
    return _playerDown0!;
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
    var input = await File(filePath).readAsString();
    return jsonDecode(input);
  }

}
