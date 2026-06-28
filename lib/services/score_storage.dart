import 'package:shared_preferences/shared_preferences.dart';

/// Persists the player's best score on device.
abstract class ScoreStorage {
  Future<int> readHighScore();

  /// Saves [score] when it beats the stored high score.
  /// Returns `true` when a new record was written.
  Future<bool> writeHighScoreIfBetter(int score);
}

class SharedPreferencesScoreStorage implements ScoreStorage {
  const SharedPreferencesScoreStorage();

  static const _highScoreKey = 'high_score';

  @override
  Future<int> readHighScore() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_highScoreKey) ?? 0;
  }

  @override
  Future<bool> writeHighScoreIfBetter(int score) async {
    final preferences = await SharedPreferences.getInstance();
    final current = preferences.getInt(_highScoreKey) ?? 0;
    if (score <= current) {
      return false;
    }

    await preferences.setInt(_highScoreKey, score);
    return true;
  }
}
