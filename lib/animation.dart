import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';

enum State {

  idle,
  playing,
  paused,
  done

}

abstract class FAnimation {

  FAnimation();

  void play()  {

    if(_animState == State.playing) return;

    _animTime = 0.0;
    _animState = State.playing;

  }

  void pause() {

    _animState = State.paused;

  }

  void stop(){

    _animState = State.idle;
    _animTime = 0.0;

  }

  void restart(){

    _animState = State.playing;
    _animTime = 0.0;

  }

  void update(double deltaTime){

    if(_animState != State.playing) return;

    _animTime = (_animTime + deltaTime).clamp(0.0, _animDuration);

    process(deltaTime);

    if(_animTime == _animDuration) {

      if(_loop) {

        _animTime = 0.0;

      }
      else {

        _animState = State.done;

      }

    }

  }

  void end() {

    _animTime = _animDuration;

  }

  void setDuration(double value) { _animDuration = value; }

  void setLooping(bool value) { _loop = value; }

  void setAutoReverse(bool value) { _autoReverse = value; }

  void setProgress(double value) { _animTime = _animDuration * value.clamp(0.0, 1.0); }

  bool looping() { return _loop; }

  bool autoReverses() { return _autoReverse; }

  State state() { return _animState; }

  double duration() { return _animDuration; }

  double currentTime() { return _animTime; }

  double progress() { return _animTime / _animDuration; }

  void process(double deltaTime);
  
  double _animDuration = 1.0;
  bool _loop = false;
  bool _autoReverse = false;
  double _animTime = 0.0;
  State _animState = State.idle;

}