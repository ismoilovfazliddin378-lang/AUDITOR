# 10.2.4-RASM: XONA ISSIQLIK TAHLILI — TEPLOVIZOR TEKSHIRUVI

<div align="center"><i>Термографический анализ помещения</i></div>

---

## 1. RASM HAQIDA UMUMIY MA'LUMOT

| Parametr | Qiymat |
|---|---|
| **Rasm nomi** | 10.2.4-rasm — Xona issiqlik xaritasi |
| **Qurilma** | Teplovizor kamera (termografik tasvir) |
| **O'lchov diapazoni** | 17.6 °C — 39.3 °C |
| **Emissivlik koeffitsienti** | 0.95 |
| **Aks ettiruvchi temperatura** | 20.0 °C |
| **O'lchov nuqtalari** | M1, M2, M3, M4 |

---

## 2. BERILGAN QIYMATLAR JADVALI

| № Nuqta | Temperatura (°C) | Emissivlik | Aks temp. (°C) | Izoh |
|:---:|:---:|:---:|:---:|:---|
| **M1** | 19.1 | 0.95 | 20.0 | Sovuq zona (devor burchagi) |
| **M2** | **38.3** | 0.95 | 20.0 | ⚠️ **ISSIQ ZONA — anomaliya!** |
| **M3** | 20.8 | 0.95 | 20.0 | Normal zona |
| **M4** | 20.7 | 0.95 | 20.0 | Normal zona |

---

## 3. MATEMATIK TAHLIL

**O'lchovlar:**
$$T_1 = 19.1\,°C, \quad T_2 = 38.3\,°C, \quad T_3 = 20.8\,°C, \quad T_4 = 20.7\,°C$$

### 3.1. Asosiy statistik ko'rsatkichlar

**a) O'rtacha temperatura (Arithmetic Mean):**

$$\bar{T} = \frac{T_1 + T_2 + T_3 + T_4}{4} = \frac{19.1 + 38.3 + 20.8 + 20.7}{4} = \frac{98.9}{4} = \mathbf{24.725\,°C}$$

**b) Maksimal temperatura:**

$$T_{max} = 38.3\,°C \quad (M2 \text{ nuqtasi})$$

**c) Minimal temperatura:**

$$T_{min} = 19.1\,°C \quad (M1 \text{ nuqtasi})$$

**d) Temperatura oralig'i (Range):**

$$\Delta T = T_{max} - T_{min} = 38.3 - 19.1 = \mathbf{19.2\,°C}$$

**e) Dispersiya (Variance):**

$$\sigma^2 = \frac{(19.1-24.725)^2 + (38.3-24.725)^2 + (20.8-24.725)^2 + (20.7-24.725)^2}{4}$$

$$\sigma^2 = \frac{31.641 + 184.276 + 15.376 + 16.202}{4} = \frac{247.495}{4} = \mathbf{61.874}$$

**f) Standart og'ish (Standard Deviation):**

$$\sigma = \sqrt{61.874} \approx \mathbf{7.866\,°C}$$

**g) M2 anomaliya darajasi:**

$$\Delta T_{anomaliya} = T_2 - \bar{T} = 38.3 - 24.725 = \mathbf{+13.575\,°C}$$

$$\text{Anomaliya darajasi} = \frac{13.575}{7.866} \approx \mathbf{1.73\,\sigma}$$

**h) Temperatura taqsimoti nisbati:**

$$\text{M2 ulushi} = \frac{38.3}{98.9} \times 100\% = \mathbf{38.7\%}$$

### 3.2. Issiqlik gradient tahlili

| Gradient yo'nalishi | Hisoblash | Natija | Baho |
|:---|:---:|:---:|:---:|
| M2 → M1 | 38.3 − 19.1 | **19.2 °C** | 🔴 KRITIK |
| M2 → M3 | 38.3 − 20.8 | **17.5 °C** | 🟠 YUQORI |
| M2 → M4 | 38.3 − 20.7 | **17.6 °C** | 🟠 YUQORI |
| M3 → M4 | 20.8 − 20.7 | **0.1 °C**  | 🟢 NORMAL |

### 3.3. Ruxsat etilgan me'yor bilan taqqoslash

| Ko'rsatkich | Hisoblangan qiymat | SNiP/ASHRAE me'yori | Holat |
|:---|:---:|:---:|:---:|
| Temperatura gradienti | 19.2 °C | ≤ 5.0 °C | ❌ **3.84× oshgan** |
| O'rtacha temperatura | 24.725 °C | 20–26 °C | ✅ Normal |
| Standart og'ish | 7.866 °C | ≤ 3.0 °C | ❌ **2.62× oshgan** |

---

## 4. XULOSA

Teplovizor tasviri asosida quyidagi xulosalar chiqarildi:

1. **M2 nuqtasi (38.3 °C)** — aniq issiqlik anomaliyasini ko'rsatmoqda. Bu temperatura o'rtachadan **+13.6 °C** yuqori bo'lib, **1.73σ** chegarasidan oshadi. Rasm asosida bu zona ship yaqinida joylashgan — ehtimol elektr simlar yoki yashirin issiqlik manbai mavjud.

2. **M1 nuqtasi (19.1 °C)** — eng sovuq zona. Tashqi devor burchagida joylashgan bo'lib, issiqlik yo'qolishi (isitish tizimining yetarlicha etib bormasligi) kuzatilmoqda.

3. **M3 va M4 nuqtalari (20.8 °C va 20.7 °C)** — me'yoriy harorat ko'rsatkichlari. Farq atigi 0.1 °C — bu zonalar normal holatda.

4. **Umumiy temperatura diapazoni 19.2 °C** — xonada sezilarli issiqlik notekisligi mavjud bo'lib, bu SNiP me'yoridan **3.84 marta** oshadi.

---

## 5. TAVSIYALAR

| № | Tavsiya | Muhimlik darajasi |
|:---:|:---|:---:|
| 1 | **M2 zonasini darhol tekshiring** — ship yaqinidagi issiq zona elektr o'tkazgichlari, qisqa tutashuv yoki yashirin quvur bilan bog'liq bo'lishi mumkin. Elektr xavfsizligi bo'yicha mutaxassis chaqiring. | 🔴 SHOSHILINCH |
| 2 | **M1 zonasini izolyatsiya qiling** — devor burchagidagi sovuq zona (19.1 °C) issiqlik yo'qolishini bildiradi; qo'shimcha devor izolyatsiyasi tavsiya etiladi. | 🟠 MUHIM |
| 3 | **Muntazam monitoring** — har oyda kamida bir marta teplovizor tekshiruvi o'tkazish tavsiya etiladi. | 🟡 O'RTA |
| 4 | **Standartlar bilan solishtiring** — ruxsat etilgan gradient ≤ 5 °C; hozirgi holat 19.2 °C (SNiP va ASHRAE standartlari bo'yicha). | 🟠 MUHIM |
| 5 | **Konditsioner holatini tekshiring** — rasm o'ng tomonida ko'rinayotgan konditsioner M2 zonasining issiqlik manbai bo'lishi mumkin. | 🟡 O'RTA |

---

<div align="center">

*Tahlil amalga oshirildi: 2026-yil*

*Hujjat AUDITOR tizimi tomonidan avtomatik tarzda yaratildi*

</div>
