import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/levels_data.dart';

class AppProvider extends ChangeNotifier {
  String _selectedLevel = 'A1';
  int _selectedSection = 0;

  String get selectedLevel => _selectedLevel;
  int get selectedSection => _selectedSection;

  List<LevelModel> get levels => LevelsData.levels;

  LevelModel getLevelByCode(String code) =>
      LevelsData.levels.firstWhere((l) => l.code == code);

  List<SectionModel> getSectionsForLevel(String levelCode) =>
      LevelsData.getSectionsForLevel(levelCode);

  SectionModel getSectionById(String levelCode, int sectionId) =>
      LevelsData.getSectionById(levelCode, sectionId);

  void selectLevel(String level) {
    _selectedLevel = level;
    notifyListeners();
  }

  void selectSection(int sectionId) {
    _selectedSection = sectionId;
    notifyListeners();
  }
}
