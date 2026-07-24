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

  static const String _accountTypeKey = 'account_type';
  static const String _tenantIdKey = 'tenant_id';

  Future<void> saveAccountType(String accountType) async {
    await _prefs.setString(_accountTypeKey, accountType);
  }

  String? getAccountType() {
    return _prefs.getString(_accountTypeKey);
  }

  Future<void> saveTenantId(String tenantId) async {
    await _prefs.setString(_tenantIdKey, tenantId);
  }

  String? getTenantId() {
    return _prefs.getString(_tenantIdKey);
  }

  // ─── Auth ───────────────────────────────────────────────────────────────
  static const String _rememberMeKey = 'remember_me';

  Future<void> saveRememberMe(bool value) async {
    await _prefs.setBool(_rememberMeKey, value);
  }

  bool getRememberMe() {
    return _prefs.getBool(_rememberMeKey) ?? true; // Default to true
  }

  // ─── Theme: Primary Color ─────────────────────────────────────────────────
  static const String _primaryColorKey = 'primary_color_value';

  /// Persists the user's chosen primary color as an ARGB int value.
  Future<void> savePrimaryColor(int colorValue) async {
    await _prefs.setInt(_primaryColorKey, colorValue);
  }

  /// Returns the saved primary color int value, or null if not set.
  int? getPrimaryColor() {
    return _prefs.getInt(_primaryColorKey);
  }

  // ─── Profile Caching ──────────────────────────────────────────────────────
  static const String _cachedProfileKey = 'cached_user_profile_json';

  Future<void> saveCachedProfile(String jsonString) async {
    await _prefs.setString(_cachedProfileKey, jsonString);
  }

  String? getCachedProfile() {
    return _prefs.getString(_cachedProfileKey);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
