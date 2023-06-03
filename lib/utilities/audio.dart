import 'package:audioplayers/audioplayers.dart';

class Audio {

  static final Audio _instance = Audio._init();

  final AudioPlayer _effectPlayer = AudioPlayer(playerId: 'effects');
  final AudioPlayer _musicPlayer = AudioPlayer(playerId: 'music');

  double _musicVolume = 0.5;
  double _effectsVolume = 0.25;

  Audio._init() {
    _effectPlayer.setVolume(_effectsVolume);
    _musicPlayer.setVolume(_musicVolume);
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  static bool musicMuted() {
    return _instance._musicVolume <= 0.0;
  }

  static bool effectsMuted() {
    return _instance._effectsVolume <= 0.0;
  }

  static void toggleMuteMusic(){

    _instance._musicVolume = _instance._musicVolume > 0.0 ? 0.0 : 0.5;
    _instance._musicPlayer.setVolume(_instance._musicVolume);

  }

  static void toggleMuteEffects(){

    _instance._effectsVolume = _instance._effectsVolume > 0.0 ? 0.0 : 0.5;
    _instance._effectPlayer.setVolume(_instance._effectsVolume);

  }

  static void playEffect(AssetSource source){

    _instance._effectPlayer.stop();
    _instance._effectPlayer.play(source);

  }

  static void playMusic(AssetSource source){

    _instance._musicPlayer.stop();
    _instance._musicPlayer.play(source);

  }

}