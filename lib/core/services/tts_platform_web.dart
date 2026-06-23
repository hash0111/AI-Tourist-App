import 'dart:async';
import 'dart:html';

Future<void> platformSpeak(String text, String language, {bool Function()? isActive}) async {
  final synth = window.speechSynthesis;
  if (synth == null) throw Exception('SpeechSynthesis not available');

  final completer = Completer<void>();
  final utterance = SpeechSynthesisUtterance(text);
  utterance.lang = language;

  utterance.onEnd.listen((_) {
    if (!completer.isCompleted) completer.complete();
  }, cancelOnError: false);
  utterance.onError.listen((e) {
    if (!completer.isCompleted) completer.completeError(Exception('Speech error: $e'));
  }, cancelOnError: false);

  synth.speak(utterance);

  var waited = 0;
  while (synth.speaking == true && waited < 120) {
    await Future.delayed(const Duration(milliseconds: 250));
    waited++;
    if (isActive != null && !isActive()) {
      synth.cancel();
      break;
    }
  }

  if (!completer.isCompleted) completer.complete();
  await completer.future;
}
