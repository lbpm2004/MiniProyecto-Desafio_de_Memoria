import 'package:shared_preferences/shared_preferences.dart';
import '../models/difficulty_model.dart';

class PreferencesService {
  
  // Guardar puntaje
  static Future<void> saveScore(Difficulty difficulty, int moves) async {
    final prefs = await SharedPreferences.getInstance();
    final String key = 'high_score_${difficulty.name}';
    
    // Obtenemos el récord actual. Si es nulo (no existe), usamos 99999
    final int currentBest = prefs.getInt(key) ?? 99999;
    
    // Depuración: Ver en consola qué está pasando
    print("Intentando guardar para ${difficulty.name}. Actual: $currentBest, Nuevo: $moves");

    if (moves < currentBest) {
      await prefs.setInt(key, moves);
      print("¡GUARDADO EXITOSO!");
    }
  }

  // Leer puntaje (Devuelve 0 si no hay récord, para la UI)
  static Future<int> getBestScore(Difficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    final String key = 'high_score_${difficulty.name}';
    return prefs.getInt(key) ?? 0; 
  }
}