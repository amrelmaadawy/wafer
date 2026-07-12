import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  final SharedPreferences _prefs;

  CacheHelper(this._prefs);

  static const String _languageKey = 'app_language';
  static const String _onboardingKey = 'onboarding_completed';

  Future<void> saveLanguage(String langCode) async {
    await _prefs.setString(_languageKey, langCode);
  }

  String getLanguage() {
    return _prefs.getString(_languageKey) ?? 'en'; // default english
  }

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
