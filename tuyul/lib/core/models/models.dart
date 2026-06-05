// ─── Level Model ───────────────────────────────────────────────────────────────
class LevelModel {
  final String code;       // A1, A2, B1, B2, C1, C2
  final String name;
  final String description;
  final int totalSections;
  final int sentencesPerSection;

  const LevelModel({
    required this.code,
    required this.name,
    required this.description,
    required this.totalSections,
    required this.sentencesPerSection,
  });

  int get totalSentences => totalSections * sentencesPerSection;
}

// ─── Section Model ─────────────────────────────────────────────────────────────
class SectionModel {
  final int id;
  final String levelCode;
  final String title;
  final String topic;
  final List<SentenceModel> sentences;

  const SectionModel({
    required this.id,
    required this.levelCode,
    required this.title,
    required this.topic,
    required this.sentences,
  });
}

// ─── Sentence Model ────────────────────────────────────────────────────────────
class SentenceModel {
  final int id;
  final String uzbek;
  final String english;
  final String? hint;

  const SentenceModel({
    required this.id,
    required this.uzbek,
    required this.english,
    this.hint,
  });
}

// ─── Saved Word Model ──────────────────────────────────────────────────────────
class SavedWordModel {
  final String id;
  final String word;
  final String translation;
  final String? example;
  final String? sentenceEnglish;
  final String levelCode;
  final DateTime savedAt;

  SavedWordModel({
    required this.id,
    required this.word,
    required this.translation,
    this.example,
    this.sentenceEnglish,
    required this.levelCode,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'translation': translation,
    'example': example,
    'sentenceEnglish': sentenceEnglish,
    'levelCode': levelCode,
    'savedAt': savedAt.toIso8601String(),
  };

  factory SavedWordModel.fromJson(Map<String, dynamic> json) => SavedWordModel(
    id: json['id'],
    word: json['word'],
    translation: json['translation'],
    example: json['example'],
    sentenceEnglish: json['sentenceEnglish'],
    levelCode: json['levelCode'],
    savedAt: DateTime.parse(json['savedAt']),
  );
}

// ─── Progress Model ────────────────────────────────────────────────────────────
class ProgressModel {
  final String levelCode;
  final int sectionId;
  final int completedSentences;
  final int totalSentences;
  final bool isCompleted;

  ProgressModel({
    required this.levelCode,
    required this.sectionId,
    required this.completedSentences,
    required this.totalSentences,
    this.isCompleted = false,
  });

  double get percentage => totalSentences > 0 ? completedSentences / totalSentences : 0.0;

  Map<String, dynamic> toJson() => {
    'levelCode': levelCode,
    'sectionId': sectionId,
    'completedSentences': completedSentences,
    'totalSentences': totalSentences,
    'isCompleted': isCompleted,
  };

  factory ProgressModel.fromJson(Map<String, dynamic> json) => ProgressModel(
    levelCode: json['levelCode'],
    sectionId: json['sectionId'],
    completedSentences: json['completedSentences'],
    totalSentences: json['totalSentences'],
    isCompleted: json['isCompleted'] ?? false,
  );
}
