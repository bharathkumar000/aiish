import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_models.dart';

class AppStateProvider extends ChangeNotifier {
  static const String _storageKey = 'aiish_mobile_app_state';

  String _childName = '';
  String _childAgeGroup = '';

  // Linear progression: 'phoneme' is unlocked by default
  Map<String, bool> _unlockedModules = {
    'phoneme': true,
    'syllable': false,
    'word': false,
    'sentence': false,
    'closure': false,
  };

  // Levels unlocked per module (0 is unlocked by default for phoneme)
  Map<String, Map<int, bool>> _unlockedLevels = {
    'phoneme': {0: true, 1: false, 2: false, 3: false, 4: false},
    'syllable': {0: false, 1: false, 2: false},
    'word': {0: false, 1: false, 2: false},
    'sentence': {0: false, 1: false, 2: false},
    'closure': {0: false, 1: false, 2: false},
  };

  TherapistConfig _therapistConfig = TherapistConfig();
  List<SessionLog> _sessionLogs = [];
  bool _isLoaded = false;

  // Getters
  String get childName => _childName;
  String get childAgeGroup => _childAgeGroup;
  Map<String, bool> get unlockedModules => _unlockedModules;
  Map<String, Map<int, bool>> get unlockedLevels => _unlockedLevels;
  TherapistConfig get therapistConfig => _therapistConfig;
  List<SessionLog> get sessionLogs => _sessionLogs;
  bool get isLoaded => _isLoaded;

  AppStateProvider() {
    loadFromStorage();
  }

  Future<void> setChildInfo(String name, String ageGroup) async {
    _childName = name;
    _childAgeGroup = ageGroup;
    notifyListeners();
    await saveToStorage();
  }

  bool isModuleUnlocked(String moduleId) {
    return _unlockedModules[moduleId] ?? false;
  }

  bool isLevelUnlocked(String moduleId, int levelIndex) {
    final moduleLevels = _unlockedLevels[moduleId];
    if (moduleLevels == null) return false;
    return moduleLevels[levelIndex] ?? false;
  }

  Future<void> unlockModule(String moduleId) async {
    _unlockedModules[moduleId] = true;
    notifyListeners();
    await saveToStorage();
  }

  Future<void> unlockLevel(String moduleId, int levelIndex) async {
    if (!_unlockedLevels.containsKey(moduleId)) {
      _unlockedLevels[moduleId] = {};
    }
    _unlockedLevels[moduleId]![levelIndex] = true;
    notifyListeners();
    await saveToStorage();
  }

  Future<void> addSessionLog(SessionLog log) async {
    _sessionLogs.add(log);
    notifyListeners();
    await saveToStorage();
  }

  Future<void> updateTherapistConfig(TherapistConfig config) async {
    _therapistConfig = config;
    notifyListeners();
    await saveToStorage();
  }

  Future<void> resetAllProgress() async {
    _unlockedModules = {
      'phoneme': true,
      'syllable': false,
      'word': false,
      'sentence': false,
      'closure': false,
    };
    _unlockedLevels = {
      'phoneme': {0: true, 1: false, 2: false, 3: false, 4: false},
      'syllable': {0: false, 1: false, 2: false},
      'word': {0: false, 1: false, 2: false},
      'sentence': {0: false, 1: false, 2: false},
      'closure': {0: false, 1: false, 2: false},
    };
    _sessionLogs = [];
    _childName = '';
    _childAgeGroup = '';
    _therapistConfig = TherapistConfig();
    notifyListeners();
    await saveToStorage();
  }

  Future<void> saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = {
        'childName': _childName,
        'childAgeGroup': _childAgeGroup,
        'unlockedModules': _unlockedModules,
        'unlockedLevels': _unlockedLevels.map(
          (k, v) => MapEntry(k, v.map((lk, lv) => MapEntry(lk.toString(), lv))),
        ),
        'therapistConfig': _therapistConfig.toJson(),
        'sessionLogs': _sessionLogs.map((l) => l.toJson()).toList(),
      };
      await prefs.setString(_storageKey, jsonEncode(data));
    } catch (e) {
      debugPrint('Error saving app state: $e');
    }
  }

  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null) {
        final Map<String, dynamic> data = jsonDecode(jsonStr);
        _childName = data['childName'] as String? ?? '';
        _childAgeGroup = data['childAgeGroup'] as String? ?? '';

        if (data['unlockedModules'] != null) {
          _unlockedModules = Map<String, bool>.from(data['unlockedModules'] as Map);
        }

        if (data['unlockedLevels'] != null) {
          final rawLevels = data['unlockedLevels'] as Map<String, dynamic>;
          _unlockedLevels = rawLevels.map((modKey, lvlMap) {
            final inner = (lvlMap as Map).map(
              (k, v) => MapEntry(int.parse(k.toString()), v as bool),
            );
            return MapEntry(modKey, inner);
          });
        }

        if (data['therapistConfig'] != null) {
          _therapistConfig = TherapistConfig.fromJson(
            data['therapistConfig'] as Map<String, dynamic>,
          );
        }

        if (data['sessionLogs'] != null) {
          _sessionLogs = (data['sessionLogs'] as List<dynamic>)
              .map((item) => SessionLog.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error loading app state: $e');
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }
}
