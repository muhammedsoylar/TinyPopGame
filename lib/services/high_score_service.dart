import 'package:flutter/widgets.dart';
import 'package:tiny_pop/services/score_storage.dart';

/// Loads and updates the local high score for UI surfaces.
class HighScoreService extends ChangeNotifier {
  HighScoreService({ScoreStorage? storage})
      : _storage = storage ?? const SharedPreferencesScoreStorage();

  final ScoreStorage _storage;

  int _highScore = 0;
  bool _isNewRecord = false;
  bool _hasRecordedCurrentGame = false;

  int get highScore => _highScore;
  bool get isNewRecord => _isNewRecord;

  Future<void> load() async {
    _highScore = await _storage.readHighScore();
    notifyListeners();
  }

  Future<void> recordGameScore(int score) async {
    if (_hasRecordedCurrentGame) {
      return;
    }

    _hasRecordedCurrentGame = true;
    final isNewRecord = await _storage.writeHighScoreIfBetter(score);
    _isNewRecord = isNewRecord;
    if (isNewRecord) {
      _highScore = score;
    }
    notifyListeners();
  }

  void resetSession() {
    _hasRecordedCurrentGame = false;
    _isNewRecord = false;
  }
}

/// Provides [HighScoreService] to the widget tree.
class HighScoreScope extends InheritedNotifier<HighScoreService> {
  const HighScoreScope({
    required HighScoreService super.notifier,
    required super.child,
    super.key,
  });

  static HighScoreService of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<HighScoreScope>();
    assert(scope != null, 'HighScoreScope not found in context');
    return scope!.notifier!;
  }
}
