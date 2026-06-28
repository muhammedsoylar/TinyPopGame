import 'package:shared_preferences/shared_preferences.dart';

/// Persists player settings on device.
abstract class SettingsStorage {
  Future<bool> readSoundEnabled();

  Future<void> writeSoundEnabled(bool enabled);
}

class SharedPreferencesSettingsStorage implements SettingsStorage {
  const SharedPreferencesSettingsStorage();

  static const _soundEnabledKey = 'sound_enabled';

  @override
  Future<bool> readSoundEnabled() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_soundEnabledKey) ?? true;
  }

  @override
  Future<void> writeSoundEnabled(bool enabled) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_soundEnabledKey, enabled);
  }
}
