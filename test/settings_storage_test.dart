import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tiny_pop/services/settings_storage.dart';

void main() {
  group('SharedPreferencesSettingsStorage', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('readSoundEnabled defaults to true when unset', () async {
      const storage = SharedPreferencesSettingsStorage();

      expect(await storage.readSoundEnabled(), isTrue);
    });

    test('writeSoundEnabled stores the latest value', () async {
      const storage = SharedPreferencesSettingsStorage();

      await storage.writeSoundEnabled(false);

      expect(await storage.readSoundEnabled(), isFalse);
    });
  });
}
