import '../models/models.dart';
import 'sentences_a1.dart';
import 'sentences_b1.dart';

class LevelsData {
  static const List<LevelModel> levels = [
    LevelModel(
      code: 'A1',
      name: 'Boshlang\'ich',
      description: 'Eng oddiy kundalik gaplar va iboralar',
      totalSections: 50,
      sentencesPerSection: 50,
    ),
    LevelModel(
      code: 'A2',
      name: 'Elementar',
      description: 'Tanish mavzularda oddiy muloqot',
      totalSections: 50,
      sentencesPerSection: 50,
    ),
    LevelModel(
      code: 'B1',
      name: 'O\'rta',
      description: 'Ish, sayohat va kundalik hayot',
      totalSections: 50,
      sentencesPerSection: 50,
    ),
    LevelModel(
      code: 'B2',
      name: 'O\'rta-yuqori',
      description: 'Murakkab mavzularda erkin muloqot',
      totalSections: 50,
      sentencesPerSection: 50,
    ),
    LevelModel(
      code: 'C1',
      name: 'Ilg\'or',
      description: 'Murakkab va akademik til',
      totalSections: 50,
      sentencesPerSection: 50,
    ),
    LevelModel(
      code: 'C2',
      name: 'Professional',
      description: 'Ona tili darajasiga yaqin',
      totalSections: 50,
      sentencesPerSection: 50,
    ),
  ];

  static Map<String, List<SectionModel>>? _cache;

  static Map<String, List<SectionModel>> get _allSections {
    _cache ??= {
      'A1': getA1Sections(),
      'A2': _getA2Sections(),
      'B1': getB1Sections(),
      'B2': _getB2Sections(),
      'C1': _getC1Sections(),
      'C2': _getC2Sections(),
    };
    return _cache!;
  }

  static List<SectionModel> getSectionsForLevel(String levelCode) =>
      _allSections[levelCode] ?? [];

  static SectionModel getSectionById(String levelCode, int sectionId) =>
      getSectionsForLevel(levelCode).firstWhere(
        (s) => s.id == sectionId,
        orElse: () => getSectionsForLevel(levelCode).first,
      );

  // ── A2 Sections ─────────────────────────────────────────────────────────
  static List<SectionModel> _getA2Sections() {
    final topics = [
      (1, 'Ish joyini tushuntirish', 'Describing Your Job'),
      (2, 'Yo\'nalish va joy', 'Giving Directions'),
      (3, 'O\'tmish haqida', 'Talking About the Past'),
      (4, 'Kelajak rejalar', 'Future Plans'),
      (5, 'Sevimli narsalar', 'Likes & Dislikes'),
      (6, 'Solishtirishlar', 'Making Comparisons'),
      (7, 'Ko\'ngilochar faoliyatlar', 'Leisure Activities'),
      (8, 'Transport va sayohat', 'Transport & Travel'),
      (9, 'Do\'konda xarid', 'Shopping'),
      (10, 'Uy ishlarini taqsimlash', 'Household Duties'),
    ];
    final extraTopics = List.generate(40, (i) => (
      i + 11,
      'A2 bo\'lim ${i + 11}',
      'A2 Topic ${i + 11}',
    ));
    return [...topics, ...extraTopics].map((t) {
      return SectionModel(
        id: t.$1,
        levelCode: 'A2',
        title: t.$2,
        topic: t.$3,
        sentences: _generateSentences(t.$1, t.$3, 'A2'),
      );
    }).toList();
  }

  // ── B2 Sections ─────────────────────────────────────────────────────────
  static List<SectionModel> _getB2Sections() {
    return List.generate(50, (i) => SectionModel(
      id: i + 1,
      levelCode: 'B2',
      title: 'B2 - Bo\'lim ${i + 1}',
      topic: 'B2 Advanced Topic ${i + 1}',
      sentences: _generateSentences(i + 1, 'Advanced B2 Topic ${i + 1}', 'B2'),
    ));
  }

  // ── C1 Sections ─────────────────────────────────────────────────────────
  static List<SectionModel> _getC1Sections() {
    return List.generate(50, (i) => SectionModel(
      id: i + 1,
      levelCode: 'C1',
      title: 'C1 - Bo\'lim ${i + 1}',
      topic: 'C1 Advanced Topic ${i + 1}',
      sentences: _generateSentences(i + 1, 'C1 Advanced ${i + 1}', 'C1'),
    ));
  }

  // ── C2 Sections ─────────────────────────────────────────────────────────
  static List<SectionModel> _getC2Sections() {
    return List.generate(50, (i) => SectionModel(
      id: i + 1,
      levelCode: 'C2',
      title: 'C2 - Bo\'lim ${i + 1}',
      topic: 'C2 Mastery Topic ${i + 1}',
      sentences: _generateSentences(i + 1, 'C2 Mastery ${i + 1}', 'C2'),
    ));
  }

  // ── Generic sentence generator ───────────────────────────────────────────
  static List<SentenceModel> _generateSentences(int sectionId, String topic, String level) {
    // Hayotiy gaplar to'plami (level + section asosida)
    final levelSentences = _sentenceBank[level] ?? _sentenceBank['A2']!;
    final offset = ((sectionId - 1) * 7) % levelSentences.length;

    return List.generate(50, (i) {
      final idx = (offset + i) % levelSentences.length;
      return SentenceModel(
        id: i + 1,
        uzbek: levelSentences[idx]['uz']!,
        english: levelSentences[idx]['en']!,
      );
    });
  }

  static final Map<String, List<Map<String, String>>> _sentenceBank = {
    'A2': [
      {'uz': 'Kechagi kunda nima qildingiz?', 'en': 'What did you do yesterday?'},
      {'uz': 'Ertalab yugurdim.', 'en': 'I went jogging in the morning.'},
      {'uz': 'Do\'stim bilan uchrashuvim bor edi.', 'en': 'I had a meeting with my friend.'},
      {'uz': 'Film ko\'rdim.', 'en': 'I watched a film.'},
      {'uz': 'Uyda qoldim.', 'en': 'I stayed at home.'},
      {'uz': 'Kitob o\'qidim.', 'en': 'I read a book.'},
      {'uz': 'Ovqat pishirdim.', 'en': 'I cooked food.'},
      {'uz': 'Musiqa tingladim.', 'en': 'I listened to music.'},
      {'uz': 'Daryo bo\'yida sayr qildim.', 'en': 'I walked by the river.'},
      {'uz': 'Familiyamni o\'zgartirdim.', 'en': 'I changed my surname.'},
      {'uz': 'Ertaga nima qilasiz?', 'en': 'What are you doing tomorrow?'},
      {'uz': 'Do\'stim bilan uchrashamiz.', 'en': 'I\'m meeting a friend.'},
      {'uz': 'Sayohatga chiqaman.', 'en': 'I\'m going on a trip.'},
      {'uz': 'Kursei boshlayman.', 'en': 'I\'m starting a course.'},
      {'uz': 'Ish izlayapman.', 'en': 'I\'m looking for work.'},
      {'uz': 'Uyni ko\'chirishni rejalashtiryapman.', 'en': 'I\'m planning to move house.'},
      {'uz': 'Yangi mashina olyapman.', 'en': 'I\'m buying a new car.'},
      {'uz': 'Viza uchun hujjat yig\'yapman.', 'en': 'I\'m gathering documents for a visa.'},
      {'uz': 'Passportimni yangilayman.', 'en': 'I\'m renewing my passport.'},
      {'uz': 'Banka hisob ochaman.', 'en': 'I\'m opening a bank account.'},
      {'uz': 'Meni yoqtiradi.', 'en': 'I like it.'},
      {'uz': 'Meni yoqtirmaydi.', 'en': 'I don\'t like it.'},
      {'uz': 'Bu qiziqarli.', 'en': 'This is interesting.'},
      {'uz': 'Bu zerikarli.', 'en': 'This is boring.'},
      {'uz': 'Bu ajoyib.', 'en': 'This is amazing.'},
      {'uz': 'Bu g\'alati.', 'en': 'This is strange.'},
      {'uz': 'Bu oddiy.', 'en': 'This is simple.'},
      {'uz': 'Bu murakkab.', 'en': 'This is complicated.'},
      {'uz': 'Bu oson.', 'en': 'This is easy.'},
      {'uz': 'Bu qiyin.', 'en': 'This is difficult.'},
      {'uz': 'Men bu yerdan.', 'en': 'I\'m from here.'},
      {'uz': 'Men bu yerlik emasman.', 'en': 'I\'m not from here.'},
      {'uz': 'Birinchi marta kelganman.', 'en': 'It\'s my first time here.'},
      {'uz': 'Ko\'p marta kelganman.', 'en': 'I\'ve been here many times.'},
      {'uz': 'Juda yoqdi.', 'en': 'I really liked it.'},
      {'uz': 'Yaxshi edi, lekin...', 'en': 'It was good, but...'},
      {'uz': 'Kutganimdan yaxshiroq.', 'en': 'Better than I expected.'},
      {'uz': 'Kutganimdan yomonroq.', 'en': 'Worse than I expected.'},
      {'uz': 'Avvalgidan farq qiladi.', 'en': 'It\'s different from before.'},
      {'uz': 'Xuddi shunday.', 'en': 'Exactly the same.'},
      {'uz': 'Biroz farq bor.', 'en': 'There\'s a slight difference.'},
      {'uz': 'Ko\'proq yoqadi.', 'en': 'I prefer this.'},
      {'uz': 'Kamroq yoqadi.', 'en': 'I prefer it less.'},
      {'uz': 'Juda katta farq.', 'en': 'A huge difference.'},
      {'uz': 'Deyarli bir xil.', 'en': 'Almost the same.'},
      {'uz': 'Eng yaxshisi bu.', 'en': 'This is the best.'},
      {'uz': 'Eng yomoni bu.', 'en': 'This is the worst.'},
      {'uz': 'O\'rtacha.', 'en': 'Average.'},
      {'uz': 'Yuqoridan pastgacha.', 'en': 'From top to bottom.'},
      {'uz': 'Pastdan yuqoriga.', 'en': 'From bottom to top.'},
    ],
    'B2': [
      {'uz': 'Bu masala murakkab nuanslarni o\'z ichiga oladi.', 'en': 'This issue involves complex nuances.'},
      {'uz': 'Mavjud ma\'lumotlarga asoslanib, shuni aytish mumkin...', 'en': 'Based on the available data, it can be said that...'},
      {'uz': 'Bu ikki yondashuvni solishtirganda...', 'en': 'When comparing these two approaches...'},
      {'uz': 'Amaliyot nazariyani tasdiqlaydi.', 'en': 'Practice confirms the theory.'},
      {'uz': 'Kutilmagan muammo yuzaga keldi.', 'en': 'An unexpected problem arose.'},
      {'uz': 'Yechim topish uchun ijodiy fikrlash talab etiladi.', 'en': 'Finding a solution requires creative thinking.'},
      {'uz': 'Resurslar cheklangan, lekin imkoniyatlar keng.', 'en': 'Resources are limited, but opportunities are wide.'},
      {'uz': 'Insoniy omil muhim rol o\'ynaydi.', 'en': 'The human factor plays an important role.'},
      {'uz': 'Loyiha muvaffaqiyatli yakunlanadi deb ishonaman.', 'en': 'I believe the project will be completed successfully.'},
      {'uz': 'Strategik nuqtai nazardan...', 'en': 'From a strategic point of view...'},
      {'uz': 'Uzoq muddatli oqibatlarini hisobga olish kerak.', 'en': 'Long-term consequences need to be considered.'},
      {'uz': 'Qisqa muddatli foyda ko\'z aldatishi mumkin.', 'en': 'Short-term benefits can be deceptive.'},
      {'uz': 'Bu qaror hamma uchun foydali.', 'en': 'This decision is beneficial for everyone.'},
      {'uz': 'Hamma tomonlarni tinglash zarur.', 'en': 'It is necessary to listen to all parties.'},
      {'uz': 'Muzokaralar davomida konsensus topildi.', 'en': 'A consensus was found during negotiations.'},
      {'uz': 'Har bir tomonning manfaatini hurmat qilish kerak.', 'en': 'The interests of each party must be respected.'},
      {'uz': 'Moslashuvchanlik muvaffaqiyatning kaliti.', 'en': 'Flexibility is the key to success.'},
      {'uz': 'Haqiqiy muloqot o\'zaro ishonchga asoslanadi.', 'en': 'Genuine communication is based on mutual trust.'},
      {'uz': 'Natijalar prognozlarga mos keldi.', 'en': 'Results matched the forecasts.'},
      {'uz': 'Byudjetni qayta ko\'rib chiqish talab qilinadi.', 'en': 'Budget revision is required.'},
      {'uz': 'Innovatsion yondashuv zarur.', 'en': 'An innovative approach is necessary.'},
      {'uz': 'Raqobat qattiq, lekin biz tayyormiz.', 'en': 'Competition is tough, but we are ready.'},
      {'uz': 'Bozor tendentsiyalarini kuzatib borish muhim.', 'en': 'Keeping track of market trends is important.'},
      {'uz': 'Mijozlar talabini qondirish birinchi o\'rinda.', 'en': 'Meeting customer demands comes first.'},
      {'uz': 'Xizmat sifatini yaxshilash davom etadi.', 'en': 'Improving service quality will continue.'},
      {'uz': 'Xodimlar motivatsiyasi samaradorlikni oshiradi.', 'en': 'Employee motivation increases productivity.'},
      {'uz': 'Jarayon optimallashtirish lozim.', 'en': 'The process needs to be optimised.'},
      {'uz': 'Riskni kamaytirish strategiyasi ishlab chiqildi.', 'en': 'A risk reduction strategy has been developed.'},
      {'uz': 'Muhim qarorlar ma\'lumotlarga asoslanishi kerak.', 'en': 'Important decisions must be based on data.'},
      {'uz': 'Natijaga yo\'naltirilgan yondashuv qo\'llaniladi.', 'en': 'A results-oriented approach is applied.'},
      {'uz': 'Hamkorlik samarali bo\'ldi.', 'en': 'The collaboration was effective.'},
      {'uz': 'Texnologik imkoniyatlardan foydalanish kerak.', 'en': 'Technological opportunities must be utilised.'},
      {'uz': 'Raqamli transformatsiya jarayoni davom etmoqda.', 'en': 'The digital transformation process continues.'},
      {'uz': 'Sun\'iy intellekt yangi imkoniyatlar ochmoqda.', 'en': 'Artificial intelligence is opening new opportunities.'},
      {'uz': 'Ma\'lumotlar tahlili muhim qarorlar qabul qilishda yordam beradi.', 'en': 'Data analysis helps in making important decisions.'},
      {'uz': 'Kiberhavfsizlik tahdidlari ortib bormoqda.', 'en': 'Cybersecurity threats are increasing.'},
      {'uz': 'Ma\'lumotlarni himoya qilish ustuvor vazifa.', 'en': 'Data protection is a priority task.'},
      {'uz': 'Bulutli hisoblash samaradorlikni oshirdi.', 'en': 'Cloud computing has improved efficiency.'},
      {'uz': 'Masofaviy ish yangi me\'yor bo\'ldi.', 'en': 'Remote work has become the new norm.'},
      {'uz': 'Girid ish modeli ommalashdi.', 'en': 'The hybrid work model has become popular.'},
      {'uz': 'Korporativ madaniyat kompaniya qiymatini belgilaydi.', 'en': 'Corporate culture defines company value.'},
      {'uz': 'Xilma-xillik va inklyuzivlik muhim.', 'en': 'Diversity and inclusion are important.'},
      {'uz': 'Barqarorlik biznes strategiyasining asosi.', 'en': 'Sustainability is the foundation of business strategy.'},
      {'uz': 'ESG tamoyillari keng qo\'llanilmoqda.', 'en': 'ESG principles are widely applied.'},
      {'uz': 'Ijtimoiy javobgarlik biznesning muhim qismi.', 'en': 'Social responsibility is an important part of business.'},
      {'uz': 'Global iqtisodiyot o\'zgarib bormoqda.', 'en': 'The global economy is evolving.'},
      {'uz': 'Geosiyosiy omillar biznesga ta\'sir qiladi.', 'en': 'Geopolitical factors affect business.'},
      {'uz': 'Ta\'minot zanjiri optimallashtirish kerak.', 'en': 'The supply chain needs optimisation.'},
      {'uz': 'Logistika muammolari yuzaga keldi.', 'en': 'Logistics problems have arisen.'},
      {'uz': 'Eksport imkoniyatlari kengaymoqda.', 'en': 'Export opportunities are expanding.'},
    ],
    'C1': [
      {'uz': 'Bu fenomen ijtimoiy-madaniy kontekstda ko\'rib chiqilishi lozim.', 'en': 'This phenomenon should be examined in a socio-cultural context.'},
      {'uz': 'Paradigma o\'zgarishi muqarrar ko\'rinadi.', 'en': 'A paradigm shift seems inevitable.'},
      {'uz': 'Epistemologik muammo chuqur tahlilni talab etadi.', 'en': 'The epistemological problem requires in-depth analysis.'},
      {'uz': 'Ushbu gipoteza empirik ma\'lumotlar bilan tasdiqlangan.', 'en': 'This hypothesis has been confirmed by empirical data.'},
      {'uz': 'Diskurs nazariyasi bu masalani yangi nuqtai nazardan ko\'rish imkonini beradi.', 'en': 'Discourse theory allows viewing this issue from a new perspective.'},
      {'uz': 'Kognitivsimulatsiya texnikasi qo\'llanildi.', 'en': 'Cognitive simulation techniques were applied.'},
      {'uz': 'Institutsional tuzilmalar o\'zgarishga muhtoj.', 'en': 'Institutional structures need change.'},
      {'uz': 'Siyosiy va iqtisodiy kuchlar muvozanatga erishishi kerak.', 'en': 'Political and economic forces need to achieve balance.'},
      {'uz': 'Transdissiplinar yondashuv eng samarali hisoblanadi.', 'en': 'The transdisciplinary approach is considered most effective.'},
      {'uz': 'Global tizimlarning o\'zaro bog\'liqligi ortib bormoqda.', 'en': 'The interdependence of global systems is increasing.'},
      {'uz': 'Etik me\'yorlar texnologik rivojlanishga moslashishi zarur.', 'en': 'Ethical standards must adapt to technological development.'},
      {'uz': 'Algoritmik qaror qabul qilish shaffoflikni talab etadi.', 'en': 'Algorithmic decision-making requires transparency.'},
      {'uz': 'Narrativ tuzilmalar anglashni shakllantiradi.', 'en': 'Narrative structures shape understanding.'},
      {'uz': 'Semiotik tahlil matn ostidagi ma\'nolarni ochib beradi.', 'en': 'Semiotic analysis reveals meanings beneath the text.'},
      {'uz': 'Fenomenologik perspektiva muhim.', 'en': 'The phenomenological perspective is important.'},
      {'uz': 'Ontologik savollar falsafaning markazida turadi.', 'en': 'Ontological questions are at the centre of philosophy.'},
      {'uz': 'Retorikaprinciplar nutqni kuchaytiradi.', 'en': 'Rhetorical principles strengthen speech.'},
      {'uz': 'Pragmatik mulohazalar nazariy asoslar bilan muvozanatda bo\'lishi kerak.', 'en': 'Pragmatic considerations must be balanced with theoretical foundations.'},
      {'uz': 'Dialektik yondashuv ziddiyatlarni hal qilishga yordam beradi.', 'en': 'The dialectical approach helps resolve contradictions.'},
      {'uz': 'Konseptual ramka yangilanishi zarur.', 'en': 'The conceptual framework needs updating.'},
      {'uz': 'Bu mulohaza turli izohlarga ega.', 'en': 'This consideration has various interpretations.'},
      {'uz': 'Akademik hamjamiyat bu masalada bo\'lingan.', 'en': 'The academic community is divided on this issue.'},
      {'uz': 'Empirik tadqiqotlar yangi xulosalarga olib keldi.', 'en': 'Empirical research has led to new conclusions.'},
      {'uz': 'Nazariy model yangilashga muhtoj.', 'en': 'The theoretical model needs updating.'},
      {'uz': 'Metodologik kamchiliklar natijalarni cheklaydi.', 'en': 'Methodological shortcomings limit the results.'},
      {'uz': 'Interpretatsion ramkalar turli natijalarga olib kelishi mumkin.', 'en': 'Interpretive frameworks can lead to different outcomes.'},
      {'uz': 'Ilmiy asos yetarlicha keng emas.', 'en': 'The scientific basis is not broad enough.'},
      {'uz': 'Nazariy va amaliy orasidagi bo\'shliqni to\'ldirish lozim.', 'en': 'The gap between theory and practice must be filled.'},
      {'uz': 'Kauzallik korrelyatsiyadan farqli.', 'en': 'Causality is different from correlation.'},
      {'uz': 'O\'zgaruvchilar orasidagi bog\'liqlik statistik jihatdan muhim.', 'en': 'The relationship between variables is statistically significant.'},
      {'uz': 'Tanlov oldingi taxminlarni tasdiqlamaydi.', 'en': 'The sample does not confirm prior assumptions.'},
      {'uz': 'Kengaytirilgan o\'rganish tavsiya etiladi.', 'en': 'Extended study is recommended.'},
      {'uz': 'Ma\'lumotlar to\'plami chekli.', 'en': 'The dataset is limited.'},
      {'uz': 'Kelajakdagi tadqiqotlar bu bo\'shliqni to\'ldirishi kerak.', 'en': 'Future research should fill this gap.'},
      {'uz': 'Xulosaning validligi shubhali.', 'en': 'The validity of the conclusion is questionable.'},
      {'uz': 'Bu maqolaning asosiy argumenti shuki...', 'en': 'The main argument of this paper is that...'},
      {'uz': 'Muallif shuni ta\'kidlaydi...', 'en': 'The author emphasises that...'},
      {'uz': 'Dalillar ushbu pozitsiyani qo\'llab-quvvatlaydi.', 'en': 'The evidence supports this position.'},
      {'uz': 'Qarama-qarshi argumentlar mavjud.', 'en': 'Counter-arguments exist.'},
      {'uz': 'Ushbu tahlil yangi imkoniyatlarni ochib beradi.', 'en': 'This analysis reveals new possibilities.'},
      {'uz': 'Natijalar kengroq kontekstda muhokama qilinishi kerak.', 'en': 'Results should be discussed in a broader context.'},
      {'uz': 'Bu tushunchalar bir-birini to\'ldiradi.', 'en': 'These concepts complement each other.'},
      {'uz': 'Sintez yangi tushunchalarni vujudga keltiradi.', 'en': 'Synthesis generates new understandings.'},
      {'uz': 'Analiz asosiy elementlarni aniqlaydi.', 'en': 'Analysis identifies the key elements.'},
      {'uz': 'Evaluatsiya ob\'ektiv mezonlarga asoslanishi kerak.', 'en': 'Evaluation must be based on objective criteria.'},
      {'uz': 'Kompleks tizimlar oddiy tushuntirishga mos kelmaydi.', 'en': 'Complex systems don\'t lend themselves to simple explanations.'},
      {'uz': 'Emergent xususiyatlar qismlarga qarab bashorat qilinmaydi.', 'en': 'Emergent properties cannot be predicted from the parts.'},
      {'uz': 'Sistemaviy fikrlash zamonaviy muammolarni hal qilish uchun zarur.', 'en': 'Systems thinking is necessary to solve modern problems.'},
      {'uz': 'Bu muhim farqni ajratib ko\'rsatish lozim.', 'en': 'This important distinction must be highlighted.'},
      {'uz': 'Yuqorida bayon etilgan mulohazalarga asoslanib...', 'en': 'Based on the considerations outlined above...'},
    ],
    'C2': [
      {'uz': 'Bu masalaning ko\'p qirrali tabiati uning yechimini yanada murakkablashtiradi.', 'en': 'The multifaceted nature of this issue makes its resolution all the more complex.'},
      {'uz': 'Mavjud adabiyotda bu muammo hali to\'liq yoritilmagan.', 'en': 'The existing literature has yet to fully address this problem.'},
      {'uz': 'Ushbu tadqiqotning metodologik yondashuvida bir qator cheklovlar mavjud.', 'en': 'The methodological approach of this research has several limitations.'},
      {'uz': 'Natijalarning umumlashtirilishi ehtiyotkorlik bilan amalga oshirilishi zarur.', 'en': 'Generalisation of results must be carried out with caution.'},
      {'uz': 'Ushbu fenomenning ko\'p o\'lchamli tabiati uni bir qolip bilan tushuntirib bo\'lmasligini ko\'rsatadi.', 'en': 'The multi-dimensional nature of this phenomenon shows it cannot be explained by a single framework.'},
      {'uz': 'Akademik bahs ko\'pincha terminologik noaniqliklardan kelib chiqadi.', 'en': 'Academic debate often arises from terminological ambiguities.'},
      {'uz': 'Mafkuraviy oldindan taxminlar tadqiqot natijalarini xolis ko\'rib chiqishga to\'sqinlik qilishi mumkin.', 'en': 'Ideological presuppositions may obstruct objective examination of research findings.'},
      {'uz': 'Falsafiy asoslar amaliy qarorlarni belgilaydi.', 'en': 'Philosophical foundations determine practical decisions.'},
      {'uz': 'Bu masalaning axloqiy o\'lchovlari e\'tibordan chetda qolmasligi lozim.', 'en': 'The ethical dimensions of this issue must not be overlooked.'},
      {'uz': 'Normativ va deskriptiv darajalar orasidagi farqni saqlash muhim.', 'en': 'It is important to maintain the distinction between normative and descriptive levels.'},
      {'uz': 'Zamonaviy sivilizatsiyaning asosiy ziddiyati shundaki...', 'en': 'The fundamental contradiction of modern civilisation is that...'},
      {'uz': 'Texnologik determinizm insoniy agentlikni inkor etmaydi.', 'en': 'Technological determinism does not negate human agency.'},
      {'uz': 'Postmodern tanqid umumiy haqiqatlar tushunchasini muammoli qiladi.', 'en': 'Postmodern critique renders the notion of universal truths problematic.'},
      {'uz': 'Intellektual mulkchilik huquqi va ochiq bilim orasidagi ziddiyat kuchaymoqda.', 'en': 'The tension between intellectual property rights and open knowledge is intensifying.'},
      {'uz': 'Ma\'lumotlar suverenligining geosiyosiy oqibatlari katta.', 'en': 'The geopolitical implications of data sovereignty are significant.'},
      {'uz': 'Sun\'iy intellektning insoniy muhokamaga ta\'siri ko\'p jihatdan o\'rganilmagan.', 'en': 'The impact of artificial intelligence on human reasoning is largely unexplored.'},
      {'uz': 'Ijtimoiy kapitalning eroziyasi demokratik institutlarni zaiflashtirayotir.', 'en': 'The erosion of social capital is weakening democratic institutions.'},
      {'uz': 'Konstitutsional tartib fundamental qadriyatlarga sodiqlikni talab etadi.', 'en': 'Constitutional order requires fidelity to fundamental values.'},
      {'uz': 'Xalqaro huquq normalarining bajarilishi hali ham muammo bo\'lib turibdi.', 'en': 'The enforcement of international legal norms remains problematic.'},
      {'uz': 'Transnatsional korporatsiyalarning ta\'siri milliy qonunchilikdan oshib ketishi mumkin.', 'en': 'The influence of transnational corporations may exceed national legislation.'},
      {'uz': 'Ekologik inqirozning siyosiy iqtisodiyoti jadal muhokamalarni keltirib chiqarmoqda.', 'en': 'The political economy of the ecological crisis is generating intense debates.'},
      {'uz': 'Adalat tushunchasi madaniyatlararo va tarixiy jihatdan farq qiladi.', 'en': 'The concept of justice varies cross-culturally and historically.'},
      {'uz': 'Huquq va axloqning kesishgan nuqtasi murakkab masalalarni keltirib chiqaradi.', 'en': 'The intersection of law and morality gives rise to complex issues.'},
      {'uz': 'Tilning voqelikni shakllantirish qudrati ko\'rsatilgan.', 'en': 'The power of language to shape reality has been demonstrated.'},
      {'uz': 'Ijtimoiy konstruksiya nazariyasi ob\'ektiv haqiqat talablarini zaiflashtiradimi?', 'en': 'Does social construction theory undermine claims to objective truth?'},
      {'uz': 'Bu savol falsafiy va siyosiy jihatdan bir xil darajada muhim.', 'en': 'This question is equally important philosophically and politically.'},
      {'uz': 'Insoniyatning kelajagi barqaror rivojlanish yo\'lini tanlashga bog\'liq.', 'en': 'The future of humanity depends on choosing the path of sustainable development.'},
      {'uz': 'Planetar chegaralar tushunchasi yangi iqtisodiy paradigmani talab etadi.', 'en': 'The concept of planetary boundaries demands a new economic paradigm.'},
      {'uz': 'Intergeneratsional adolat zamonaviy siyosatda e\'tiborga olinmayapti.', 'en': 'Intergenerational justice is not being taken into account in current policy.'},
      {'uz': 'Bu masalada qadriyat mulohazalari empirik ma\'lumotlardan ustun turadi.', 'en': 'On this issue, value considerations outweigh empirical data.'},
      {'uz': 'Mafkura va bilim orasidagi chegara ko\'pincha noaniq.', 'en': 'The boundary between ideology and knowledge is often unclear.'},
      {'uz': 'Bilimning siyosiy ijtimoiylashuvi muqarrar.', 'en': 'The political socialisation of knowledge is inevitable.'},
      {'uz': 'Bu masalada ratsional konsensusga erishish mumkinmi?', 'en': 'Is it possible to reach rational consensus on this issue?'},
      {'uz': 'Kommunikativ ratsionallik tushunchasi bu savolga javob berishi mumkin.', 'en': 'The concept of communicative rationality may answer this question.'},
      {'uz': 'Siyosiy falsafa doimo norma va tavsif orasidagi keskinlikda yashaydi.', 'en': 'Political philosophy always lives in the tension between norm and description.'},
      {'uz': 'Bu texnologiyaning antropologik oqibatlari hali to\'liq anglashilmagan.', 'en': 'The anthropological consequences of this technology are not yet fully understood.'},
      {'uz': 'Inson mavjudligining ma\'nosi haqidagi savol turli an\'analarda turlicha izohlangan.', 'en': 'The question of the meaning of human existence has been interpreted differently in various traditions.'},
      {'uz': 'Erkinlik tushunchasi salbiy va ijobiy shaklda farqlanadi.', 'en': 'The concept of freedom is differentiated in its negative and positive forms.'},
      {'uz': 'Adolat, tenglik va erkinlik orasidagi munosabat murakkab.', 'en': 'The relationship between justice, equality and freedom is complex.'},
      {'uz': 'Liberal demokratiya o\'z tanqidchilari bilan bahslashib kelmoqda.', 'en': 'Liberal democracy has been in debate with its critics.'},
      {'uz': 'Populizm liberalizm uchun strukturaviy muammo hisoblanadimi?', 'en': 'Is populism a structural problem for liberalism?'},
      {'uz': 'Bu savol siyosatshunoslar orasida hali hal qilinmagan.', 'en': 'This question remains unresolved among political scientists.'},
      {'uz': 'Uzoq muddatli istiqbol uchun institutsional islohotlar zarur.', 'en': 'Institutional reforms are necessary for long-term prospects.'},
      {'uz': 'Meritokratiya tamoyillari haqiqatda qay darajada amalga oshmoqda?', 'en': 'To what extent are meritocratic principles being realised in practice?'},
      {'uz': 'Ijtimoiy harakatchanlik ko\'rsatkichlari tashvishli darajada pasayib ketdi.', 'en': 'Social mobility indicators have declined to a worrying level.'},
      {'uz': 'Globallashuvning qarama-zid natijalari aniqroq ko\'zga tashlanmoqda.', 'en': 'The contradictory outcomes of globalisation are becoming more apparent.'},
      {'uz': 'Iqtisodiy tengsizlik ijtimoiy koheziyaga tahdid solmoqda.', 'en': 'Economic inequality is threatening social cohesion.'},
      {'uz': 'Bu tanqidiy masalada ikki tomonlama yondashuv kerak.', 'en': 'A dual approach is needed on this critical issue.'},
      {'uz': 'Ziddiyatli g\'oyalarning sintezi yangi bilim sohalarini ochadi.', 'en': 'The synthesis of conflicting ideas opens new fields of knowledge.'},
    ],
  };
}
