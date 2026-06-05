# 🦊 Tuyul — English Speaking Practice App

**Tuyul** — ingliz tilini Speaking ko'nikmasini oshirish uchun mo'ljallangan Android/iOS ilovasi.

---

## 📱 Ilova haqida

| Xususiyat | Ma'lumot |
|-----------|---------|
| Platform | Flutter (Android + iOS) |
| Darajalar | A1 · A2 · B1 · B2 · C1 · C2 |
| Bo'limlar | 6 daraja × 50 bo'lim = **300 bo'lim** |
| Gaplar | 300 × 50 = **15,000 gap** |
| Til | O'zbekcha → Inglizcha |
| Mavzu | Kundalik hayotiy gaplar |

---

## 🎯 Asosiy funksiyalar

### 🎤 Speaking Mashq
- O'zbekcha gap ekranda ko'rinadi
- Foydalanuvchi inglizcha aytadi
- **Speech-to-text** orqali ovoz tanib olinadi va **subtitr** sifatida ko'rsatiladi
- Ilova **tekshirib**, natijani ko'rsatadi (to'g'ri/noto'g'ri)
- **So'z tahlili** — qaysi so'zlar to'g'ri, qaysilari noto'g'ri

### 🔊 Tinglash
- Har bir gapning inglizcha talaffuzini eshitish mumkin (Text-to-Speech)

### 📚 Lug'at
- Mashq paytida bilmagan so'zga bosib **lug'atga saqlash**
- O'zbekcha tarjimasi va eslatma qo'shish
- Daraja bo'yicha filtrlash
- Qidiruv

### 📊 Progress
- Har bir bo'lim va daraja bo'yicha taraqqiyot kuzatiladi
- Bajarilgan bo'limlar belgilanadi

---

## 🏗 Loyiha tuzilmasi

```
tuyul/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── theme/         # Nim-siyohrang dizayn
│   │   ├── models/        # Ma'lumot modellari
│   │   ├── providers/     # State management
│   │   └── data/          # Gaplar ma'lumotlari
│   └── features/
│       ├── home/          # Bosh ekran (darajalar)
│       ├── sections/      # Bo'limlar ro'yxati
│       ├── practice/      # Mashq ekrani (asosiy)
│       └── vocabulary/    # Lug'at
├── android/
└── pubspec.yaml
```

---

## 🎨 Dizayn

- **Fon**: `#0F1117` — chuqur qora-ko'k (nim-siyohrang)
- **Kartalar**: `#1E2138` — to'q ko'k-kulrang
- **Asosiy rang**: `#6C63FF` — binafsha
- **Ikkinchi rang**: `#00D4AA` — yashil-moviy
- **Shakllar**: Qirrasiz to'rtburchaklar (flat dizayn)
- **Shrift**: Google Poppins

---

## 📲 O'rnatish

### Talablar
- Flutter 3.10+
- Android 5.0 (API 21)+
- Mikrofon ruxsati

### Qurish
```bash
cd tuyul
flutter pub get
flutter run
```

### APK yaratish
```bash
flutter build apk --release
```

---

## 🔮 Kelajakdagi yangilanishlar
- [ ] Yangi darajalar va bo'limlar qo'shish
- [ ] Flashcard rejimi
- [ ] Statistika va grafik
- [ ] Kunlik mashq eslatmasi
- [ ] Leaderboard
- [ ] Offline rejim
- [ ] iOS App Store

---

*Tuyul — O'zbekiston yoshlari uchun ingliz tili practikasi*
