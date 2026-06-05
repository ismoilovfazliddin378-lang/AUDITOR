import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class VocabularyProvider extends ChangeNotifier {
  List<SavedWordModel> _savedWords = [];
  static const _uuid = Uuid();

  List<SavedWordModel> get savedWords => _savedWords;

  VocabularyProvider() {
    _loadWords();
  }

  List<SavedWordModel> getWordsByLevel(String levelCode) =>
      _savedWords.where((w) => w.levelCode == levelCode).toList();

  bool isWordSaved(String word) =>
      _savedWords.any((w) => w.word.toLowerCase() == word.toLowerCase());

  Future<void> addWord({
    required String word,
    required String translation,
    String? example,
    String? sentenceEnglish,
    required String levelCode,
  }) async {
    if (isWordSaved(word)) return;

    _savedWords.add(SavedWordModel(
      id: _uuid.v4(),
      word: word,
      translation: translation,
      example: example,
      sentenceEnglish: sentenceEnglish,
      levelCode: levelCode,
      savedAt: DateTime.now(),
    ));
    notifyListeners();
    await _saveWords();
  }

  Future<void> removeWord(String id) async {
    _savedWords.removeWhere((w) => w.id == id);
    notifyListeners();
    await _saveWords();
  }

  Future<void> _loadWords() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('saved_words');
    if (data != null) {
      final list = jsonDecode(data) as List;
      _savedWords = list.map((e) => SavedWordModel.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_words', jsonEncode(_savedWords.map((w) => w.toJson()).toList()));
  }
}
