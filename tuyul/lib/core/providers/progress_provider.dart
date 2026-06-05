import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ProgressProvider extends ChangeNotifier {
  Map<String, ProgressModel> _progress = {};
  int _totalPracticed = 0;
  int _streak = 0;

  Map<String, ProgressModel> get progress => _progress;
  int get totalPracticed => _totalPracticed;
  int get streak => _streak;

  ProgressProvider() {
    _loadProgress();
  }

  String _key(String levelCode, int sectionId) => '${levelCode}_$sectionId';

  ProgressModel? getProgress(String levelCode, int sectionId) =>
      _progress[_key(levelCode, sectionId)];

  int getCompletedSections(String levelCode) =>
      _progress.values.where((p) => p.levelCode == levelCode && p.isCompleted).length;

  double getLevelProgress(String levelCode) {
    final sections = _progress.values.where((p) => p.levelCode == levelCode).toList();
    if (sections.isEmpty) return 0.0;
    final total = sections.fold<int>(0, (sum, p) => sum + p.totalSentences);
    final completed = sections.fold<int>(0, (sum, p) => sum + p.completedSentences);
    return total > 0 ? completed / total : 0.0;
  }

  Future<void> updateProgress(String levelCode, int sectionId, int sentenceIndex, int total) async {
    final key = _key(levelCode, sectionId);
    final completed = sentenceIndex + 1;

    _progress[key] = ProgressModel(
      levelCode: levelCode,
      sectionId: sectionId,
      completedSentences: completed,
      totalSentences: total,
      isCompleted: completed >= total,
    );
    _totalPracticed++;
    notifyListeners();
    await _saveProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('progress');
    if (data != null) {
      final map = jsonDecode(data) as Map<String, dynamic>;
      _progress = map.map((k, v) => MapEntry(k, ProgressModel.fromJson(v)));
    }
    _totalPracticed = prefs.getInt('totalPracticed') ?? 0;
    _streak = prefs.getInt('streak') ?? 0;
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final map = _progress.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString('progress', jsonEncode(map));
    await prefs.setInt('totalPracticed', _totalPracticed);
  }
}
