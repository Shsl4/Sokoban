enum AnimationState {

  idle,
  playing,
  paused,
  done

}

abstract class Animator {

  Animator();

  void play()  {

    if(_animState == AnimationState.playing) return;

    _animTime = 0.0;
    _animState = AnimationState.playing;

  }

  void pause() {

    _animState = AnimationState.paused;

  }

  void stop(){

    _animState = AnimationState.idle;
    _animTime = 0.0;

  }

  void restart(){

    _animState = AnimationState.playing;
    _animTime = 0.0;

  }

  void update(double deltaTime){

    if(_animState != AnimationState.playing) return;

    _animTime = (_animTime + deltaTime).clamp(0.0, _animDuration);

    process(deltaTime);

    if(_animTime == _animDuration) {

      if(_loop) {

        _animTime = 0.0;

      }
      else {

        _animState = AnimationState.done;

        finished();

      }

    }

  }

  void finished(){

  }

  void end() {

    _animTime = _animDuration;

  }

  void setDuration(double value) { _animDuration = value; }

  void setLooping(bool value) { _loop = value; }

  void setProgress(double value) { _animTime = _animDuration * value.clamp(0.0, 1.0); }

  bool looping() { return _loop; }

  AnimationState state() { return _animState; }

  double duration() { return _animDuration; }

  double currentTime() { return _animTime; }

  double progress() { return _animTime / _animDuration; }

  void process(double deltaTime);
  
  double _animDuration = 1.0;
  bool _loop = false;
  double _animTime = 0.0;
  AnimationState _animState = AnimationState.idle;

}