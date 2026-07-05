import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.42); // Slightly slower for auditory training
      await _flutterTts.setPitch(1.1); // Slightly higher/friendly pitch for kids
      await _flutterTts.setVolume(1.0);
      _isInitialized = true;
    } catch (e) {
      debugPrint('AudioService init warning: $e');
    }
  }

  Future<void> speakTrainingWord(String word) async {
    await init();
    try {
      await _flutterTts.stop();
      await _flutterTts.speak(word);
    } catch (e) {
      debugPrint('Error speaking word: $e');
    }
  }

  Future<void> speakClue(String clue) async {
    await init();
    try {
      await _flutterTts.stop();
      await _flutterTts.speak("Here is your clue: $clue");
    } catch (e) {
      debugPrint('Error speaking clue: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }
}
