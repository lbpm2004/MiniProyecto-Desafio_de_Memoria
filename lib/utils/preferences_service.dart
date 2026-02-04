import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyHighScore = 'high_score';

  // Guardar puntaje (solo si es menor al actual)
  static Future<void> saveScore(int moves) async {
    final prefs = await SharedPreferences.getInstance();
    final int currentBest = prefs.getInt(_keyHighScore) ?? 9999;
    
    if (moves < currentBest) {
      await prefs.setInt(_keyHighScore, moves);
    }
  }

  // Leer puntaje
  static Future<int> getBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    // Si no hay récord, devolvemos 0 o un valor indicativo
    return prefs.getInt(_keyHighScore) ?? 0;
  }
}