# Noor نور — Application Islamique Complète

Une application mobile islamique premium développée avec **Flutter 3.24+**, **GetX** et **Clean Architecture**.

## Fonctionnalités

| Feature | Description |
|---|---|
| 🕌 **Prières & Azan** | Horaires précis par GPS, notifications Azan, plein écran Azan |
| 📖 **Saint Coran** | Lecture complète, traduction française, récitation audio |
| 🌿 **Azkar** | Azkar du matin/soir/réveil/prière avec suivi quotidien |
| 📿 **Tasbih** | Compteur électronique avec perles animées, vibration |
| 📅 **Calendrier** | Convertisseur grégorien ↔ hijri, fêtes islamiques |
| 🧭 **Qibla** | Boussole pointant vers La Mecque |
| 🌐 **Ummah** | Feed social communautaire |
| ⚙️ **Paramètres** | Thème, langue, méthode de calcul, notifications |

## Structure du Projet

```
lib/
├── core/
│   ├── constants/         # AppConstants
│   ├── theme/             # AppColors, AppTheme, AppTextStyles
│   ├── utils/             # PrayerTimeUtils, HijriUtils
│   └── widgets/           # GradientBackground, NoorAppBar
├── features/
│   ├── splash/            # SplashScreen
│   ├── onboarding/        # OnboardingScreen (4 pages)
│   ├── home/              # HomeScreen + MainNavigationScreen
│   ├── prayer/            # PrayerScreen + AzanScreen + PrayerController
│   ├── azkar/             # AzkarListScreen + AzkarDetailScreen + Controller
│   ├── quran/             # QuranScreen + QuranSurahScreen + Controller
│   ├── tasbih/            # TasbihScreen + Controller
│   ├── calendar/          # CalendarScreen (Hijri + Gregorian)
│   ├── ummah/             # UmmahScreen (social feed)
│   └── settings/          # SettingsScreen + QiblaScreen
└── shared/
    ├── models/            # PrayerModel, AzkarModel
    └── services/          # StorageService, LocationService, NotificationService
assets/
├── json/
│   ├── azkar.json         # Données Azkar complètes (21 azkar, 9 catégories)
│   └── tasbih.json        # Liste Tasbih (12 entrées)
└── fonts/                 # Amiri, ScheherazadeNew, NotoNaskhArabic
```

## Installation

### Prérequis
- Flutter 3.24+
- Dart 3.0+
- Android SDK 21+ / iOS 12+

### Étapes

```bash
# 1. Cloner le repo
git clone <repo-url>
cd noor_app

# 2. Installer les dépendances
flutter pub get

# 3. Télécharger les polices arabes
# Placer dans assets/fonts/:
#   - Amiri-Regular.ttf, Amiri-Bold.ttf
#   - ScheherazadeNew-Regular.ttf, ScheherazadeNew-Bold.ttf
#   - NotoNaskhArabic-Regular.ttf, NotoNaskhArabic-Bold.ttf

# 4. Lancer l'application
flutter run
```

### Téléchargement des polices

Les polices sont disponibles sur Google Fonts :
- **Amiri** : https://fonts.google.com/specimen/Amiri
- **Scheherazade New** : https://fonts.google.com/specimen/Scheherazade+New
- **Noto Naskh Arabic** : https://fonts.google.com/noto/specimen/Noto+Naskh+Arabic

## Dépendances Principales

```yaml
get: ^4.6.6                    # State management
adhan: ^1.2.0                  # Calcul horaires de prière
hijri: ^2.0.1                  # Calendrier islamique
awesome_notifications: ^0.9.3  # Notifications push
geolocator: ^11.0.0            # Géolocalisation
flutter_compass: ^0.7.0        # Boussole Qibla
just_audio: ^0.9.39            # Lecture audio Coran
flutter_animate: ^4.5.0        # Animations fluides
shared_preferences: ^2.2.3     # Stockage local
```

## Permissions Requises

### Android (`AndroidManifest.xml`)
- `ACCESS_FINE_LOCATION` — Géolocalisation pour les horaires de prière
- `POST_NOTIFICATIONS` — Notifications Azan
- `SCHEDULE_EXACT_ALARM` — Notifications précises
- `VIBRATE` — Retour haptique Tasbih
- `WAKE_LOCK` — Écran plein Azan

### iOS (`Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Pour calculer vos horaires de prière précis</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Pour les rappels de prière en arrière-plan</string>
```

## Palette de Couleurs

| Couleur | Hex | Usage |
|---|---|---|
| Primary | `#006B3C` | Couleur principale |
| Primary Light | `#00A36C` | Accents, boutons actifs |
| Primary Dark | `#004D2A` | Header, fond sombre |
| Gold | `#D4AF37` | Accents dorés, titres arabes |
| Background Light | `#F5F5F0` | Fond mode clair |
| Background Dark | `#0D1F14` | Fond mode sombre |

## Architecture

L'application suit le pattern **Feature-First Clean Architecture** :

```
feature/
├── data/
│   ├── models/        # Data models
│   └── repositories/  # Repository implementations
├── domain/
│   ├── entities/      # Business entities
│   └── usecases/      # Use cases
└── presentation/
    ├── controllers/   # GetX controllers
    ├── screens/       # UI screens
    └── widgets/       # Feature-specific widgets
```

## Contribuer

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit vos changements (`git commit -m 'Add: nouvelle fonctionnalité'`)
4. Push sur la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrir une Pull Request

---

Développé avec ❤️ pour la communauté musulmane francophone.

**بارك الله فيكم**
