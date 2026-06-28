import 'package:flutter_test/flutter_test.dart';

import 'package:tiny_pop/services/score_storage.dart';

class _MemoryScoreStorage implements ScoreStorage {
  int _highScore = 0;

  @override
  Future<int> readHighScore() async => _highScore;

  @override
  Future<bool> writeHighScoreIfBetter(int score) async {
    if (score <= _highScore) {
      return false;
    }

    _highScore = score;
    return true;
  }
}

void main() {
  group('ScoreStorage', () {
    test('writeHighScoreIfBetter saves a higher score', () async {
      final storage = _MemoryScoreStorage();

      final isNewRecord = await storage.writeHighScoreIfBetter(12);

      expect(isNewRecord, isTrue);
      expect(await storage.readHighScore(), 12);
    });

    test('writeHighScoreIfBetter ignores equal or lower scores', () async {
      final storage = _MemoryScoreStorage();
      await storage.writeHighScoreIfBetter(10);

      final isNewRecord = await storage.writeHighScoreIfBetter(8);

      expect(isNewRecord, isFalse);
      expect(await storage.readHighScore(), 10);
    });
  });
}
