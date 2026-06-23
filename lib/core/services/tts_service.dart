import 'dart:async';
import 'dart:io' show Platform, Process;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  FlutterTts? _tts;
  bool _speaking = false;
  final List<void Function()> _onStateChanged = [];
  Object? activeSpeakerId;
  void Function(String error)? onError;

  bool get isSpeaking => _speaking;

  void addListener(void Function() callback) => _onStateChanged.add(callback);
  void removeListener(void Function() callback) => _onStateChanged.remove(callback);

  TtsService() {
    if (kIsWeb || !Platform.isLinux) {
      _tts = FlutterTts();
      _tts!.setCompletionHandler(() {
        _speaking = false;
        activeSpeakerId = null;
        _notifyListeners();
      });
      _tts!.setErrorHandler((msg) {
        onError?.call('TTS error: $msg');
        _speaking = false;
        activeSpeakerId = null;
        _notifyListeners();
      });
    }
  }

  void _notifyListeners() {
    for (final cb in _onStateChanged) {
      cb();
    }
  }

  Future<void> speak(String text, {Object? speakerId, String fallback = '', String language = 'en-US'}) async {
    activeSpeakerId = speakerId;

    final t = (_isAscii(text) || fallback.isEmpty) ? text : fallback;
    if (t.trim().isEmpty) return;

    try {
      if (_tts != null) {
        await _tts!.setLanguage(language == 'hi' ? 'hi-IN' : 'en-US');
        await _tts!.setSpeechRate(0.9);
        _speaking = true;
        _notifyListeners();
        await _tts!.speak(t.trim(), focus: true);
      } else if (Platform.isLinux) {
        await _linuxSpeak(t);
      } else {
        onError?.call('TTS not available on this platform');
        activeSpeakerId = null;
        _notifyListeners();
      }
    } catch (e) {
      onError?.call('TTS failed: $e');
      _speaking = false;
      activeSpeakerId = null;
      _notifyListeners();
    }
  }

  Future<void> _linuxSpeak(String text) async {
    final check = await Process.run('which', ['spd-say']);
    if (check.exitCode != 0) {
      onError?.call('Install speech-dispatcher: sudo apt install speech-dispatcher');
      return;
    }
    _speaking = true;
    _notifyListeners();
    await Process.run('spd-say', ['-e', text]);
    _speaking = false;
    _notifyListeners();
  }

  Future<void> stop() async {
    _speaking = false;
    activeSpeakerId = null;
    _notifyListeners();
    try {
      await _tts?.stop();
    } catch (_) {}
  }

  bool _isAscii(String text) => text.codeUnits.every((c) => c < 256);

  void dispose() {
    _speaking = false;
    activeSpeakerId = null;
    try {
      _tts?.stop();
    } catch (_) {}
  }
}
