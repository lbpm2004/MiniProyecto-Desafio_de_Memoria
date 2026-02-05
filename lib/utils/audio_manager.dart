import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  // CREAMOS DOS REPRODUCTORES SEPARADOS
  // 1. Para sonidos rápidos y repetitivos (Flip)
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  
  // 2. Para eventos importantes (Match y Win)
  static final AudioPlayer _eventPlayer = AudioPlayer();

  // Reproducir sonido de volteo
  static void playFlip() async {
    
    // Verificamos si el player está ocupado para evitar errores, si no, reproducimos.
    if (_sfxPlayer.state != PlayerState.playing) {
       await _sfxPlayer.play(AssetSource('sounds/flip.mp3'));
    } else {
       // Si ya está sonando, forzamos un reinicio rápido sin 'stop' bloqueante
       await _sfxPlayer.seek(Duration.zero);
       await _sfxPlayer.resume();
    }
  }

  // Reproducir sonido de acierto
  static void playMatch() async {
    // Aquí sí detenemos el evento anterior si lo hubiera
    await _eventPlayer.stop(); 
    await _eventPlayer.play(AssetSource('sounds/match.mp3'));
  }

  // Reproducir sonido de victoria
  static void playWin() async {
    await _eventPlayer.stop();
    await _eventPlayer.play(AssetSource('sounds/win.mp3'));
  }
}