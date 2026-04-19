# 🚀 Guide Complet de Publication — Noor Islamic App

## Vue d'ensemble

| Étape | Plateforme | Durée estimée |
|-------|-----------|---------------|
| Préparation | Les deux | 1-2 jours |
| Google Play | Android | 1-3 jours (review) |
| App Store | iOS | 1-7 jours (review) |

---

## PARTIE 1 — PRÉPARATION COMMUNE

### ✅ Checklist Pré-publication

#### Code & Build
- [ ] `flutter analyze` sans erreurs critiques
- [ ] Testé sur appareil réel Android (pas seulement émulateur)
- [ ] Testé sur iPhone réel (si possible)
- [ ] Version dans `pubspec.yaml` correcte (ex: `1.0.0+1`)
- [ ] Toutes les permissions justifiées dans les manifests
- [ ] Mode release testé (pas de logs de debug)
- [ ] Mode hors ligne fonctionnel

#### Assets
- [ ] Icône app 512×512 px (Google Play)
- [ ] Icône app 1024×1024 px (App Store)
- [ ] 8 screenshots (voir `screenshots_guide.md`)
- [ ] Feature Graphic 1024×500 px (Google Play uniquement)
- [ ] Aucun screenshot avec UI d'une autre app

#### Légal
- [ ] Privacy Policy hébergée sur un URL public
- [ ] Email de contact actif
- [ ] Aucun contenu protégé par copyright sans licence

---

## PARTIE 2 — GOOGLE PLAY STORE

### Étape 1 — Créer un compte développeur
1. Aller sur **https://play.google.com/console**
2. Créer un compte développeur (frais uniques : **25 USD**)
3. Remplir les informations du compte

### Étape 2 — Générer le Keystore
```bash
cd noor_app
chmod +x store/generate_keystore.sh
./store/generate_keystore.sh
```
⚠️ **Sauvegardez le keystore et les mots de passe — IMPOSSIBILITÉ DE METTRE À JOUR SANS EUX**

### Étape 3 — Build l'AAB Release
```bash
flutter pub get
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-symbols
```
Le fichier sera dans : `build/app/outputs/bundle/release/app-release.aab`

Ou utilisez le script complet :
```bash
chmod +x store/build_release.sh
./store/build_release.sh android
```

### Étape 4 — Créer l'application dans la Play Console
1. **Play Console** → "Créer une application"
2. Langue par défaut : **Français (France)**
3. Nom : `Noor - Application Islamique`
4. Type d'application : **Application**
5. Gratuite ou payante : **Gratuite**

### Étape 5 — Configurer la fiche Play Store
**Dans "Présence dans le Play Store" → "Fiche principale du Play Store" :**

| Champ | Valeur |
|-------|--------|
| Titre | `Noor - Application Islamique` |
| Résumé court | `Prières, Coran, Azkar, Tasbih & Calendrier Islamique — نور` |
| Description | (Copier depuis `store/google_play/store_listing_fr.md`) |
| Catégorie | `Mode de vie` |
| Email | `contact@noor-app.com` |
| Site web | `https://noor-app.com` |
| Politique de confidentialité | `https://noor-app.com/privacy` |

**Ajouter les visuels :**
- Icône (512×512 px)
- Feature Graphic (1024×500 px)
- 8 screenshots (1080×1920 px)

### Étape 6 — Questionnaire de contenu
**"Contenu de l'application" → Évaluations du contenu :**
- Remplir le questionnaire (violence, contenu adulte, etc.)
- Pour Noor : tout à "Non" → Classification **PEGI 3 / Everyone**

**"Accès à l'application" :**
- Accès complet sans identifiants

**"Publicités" :**
- Cocher : "Cette application ne contient pas de publicités"

### Étape 7 — Configuration de la tarification
- Distribution : **Monde entier**
- Prix : **Gratuit**
- Pays prioritaires : France, Belgique, Maroc, Algérie, Tunisie, Sénégal, Côte d'Ivoire...

### Étape 8 — Upload et publication
1. **Version de production** → "Créer une version"
2. Importer le fichier `.aab`
3. Ajouter les notes de version :
```
Version 1.0.0 — Lancement officiel de Noor 🌙

✨ Application islamique complète :
• Horaires de prière par GPS
• Coran complet avec traduction française
• Azkar quotidiens avec suivi
• Tasbih électronique
• Calendrier Hijri
• Boussole Qibla
• Communauté Ummah
```
4. **"Examiner la version"** → **"Commencer le déploiement en production"**

**Délai de review Google Play : 1-3 jours ouvrés**

---

## PARTIE 3 — APPLE APP STORE

### Étape 1 — Compte développeur Apple
1. Aller sur **https://developer.apple.com**
2. S'inscrire au **Apple Developer Program** (**99 USD/an**)
3. Attendre l'approbation (quelques heures à 48h)

### Étape 2 — Créer l'App ID
1. **Developer Portal** → "Certificates, IDs & Profiles"
2. **Identifiers** → "+" → **App IDs**
3. Bundle ID : `com.noor.app` (Explicit)
4. Capabilities à activer :
   - ☑ Push Notifications
   - ☑ Background Modes
   - ☑ Sign in with Apple (optionnel)

### Étape 3 — Créer les certificats
**Option A — Manuelle :**
1. **Certificates** → "+" → iOS Distribution
2. Créer un CSR depuis Keychain Access sur Mac
3. Télécharger et installer le certificat

**Option B — Via Fastlane Match (recommandé) :**
```bash
gem install fastlane
fastlane match init    # Configurer le repo de certificats
fastlane match appstore
```

### Étape 4 — Créer le Provisioning Profile
1. **Provisioning Profiles** → "+" → **App Store**
2. Sélectionner l'App ID `com.noor.app`
3. Sélectionner votre certificat de distribution
4. Télécharger et installer

### Étape 5 — Créer l'app dans App Store Connect
1. Aller sur **https://appstoreconnect.apple.com**
2. **Mes apps** → "+" → **Nouvelle app**
3. Plateforme : **iOS**
4. Nom : `Noor - Application Islamique`
5. Langue principale : **Français**
6. Bundle ID : `com.noor.app`
7. SKU : `noor-islamic-app-2026`

### Étape 6 — Informations App Store
**Onglet "Informations sur l'app" :**
- Sous-titre : `Prière, Coran & Azkar`
- Catégorie principale : **Références**
- Catégorie secondaire : **Utilitaires**
- URL de confidentialité : `https://noor-app.com/privacy`
- URL de support : `https://noor-app.com/support`

**Onglet "Tarification et disponibilité" :**
- Prix : **Gratuit**
- Disponibilité : Tous les pays

### Étape 7 — Informations sur la version (1.0.0)

**Description :**
(Copier depuis `store/app_store/store_listing_fr.md`)

**Mots-clés :**
```
priere,coran,islam,azkar,tasbih,qibla,muslim,adhan,ramadan,hijri,dua,zikr
```

**Notes de version :**
```
🎉 Version 1.0.0 — Lancement officiel

Bienvenue dans Noor, votre compagnon islamique !
• Horaires de prière par GPS
• Coran complet avec traduction
• Azkar quotidiens
• Tasbih électronique
• Calendrier Hijri
• Qibla
```

**Informations de review Apple :**
- Email : `contact@noor-app.com`
- Téléphone : (votre numéro)
- Notes : "Application islamique qui calcule les horaires de prière selon la position GPS. Pas de compte requis."

### Étape 8 — Build iOS et upload

```bash
# Sur Mac avec Xcode installé
flutter build ios --release

# Dans Xcode :
# 1. Ouvrir ios/Runner.xcworkspace
# 2. Sélectionner "Any iOS Device" comme cible
# 3. Product → Archive
# 4. Organizer → Distribute App → App Store Connect
# 5. Upload
```

**Ou via Fastlane :**
```bash
fastlane ios beta    # Pour TestFlight d'abord (recommandé)
fastlane ios deploy  # Pour App Store direct
```

### Étape 9 — Questionnaire de confidentialité Apple
Dans App Store Connect → "Confidentialité des apps" :

| Type de données | Collectée | Utilisée pour |
|----------------|-----------|---------------|
| Données de localisation | Oui | Fonctionnalités de l'app |
| Données d'utilisation | Non | — |
| Diagnostics | Non | — |
| Données d'identité | Non | — |
| Données financières | Non | — |

### Étape 10 — Soumettre pour review
1. Sélectionner le build uploadé
2. Ajouter les screenshots
3. **"Ajouter à la review"** → **"Soumettre pour review"**

**Délai de review Apple : 1-7 jours ouvrés**

---

## PARTIE 4 — HÉBERGER LA PRIVACY POLICY

La Privacy Policy doit être accessible via une URL publique.

### Option A — GitHub Pages (gratuit)
```bash
# 1. Créer un repo public "noor-app.github.io" ou "privacy-policy"
# 2. Uploader privacy_policy.html comme index.html
# 3. Activer GitHub Pages dans les paramètres
# URL : https://sowalseny841-dev.github.io/noor-privacy/
```

### Option B — Netlify (gratuit)
```bash
# 1. Créer un compte sur netlify.com
# 2. Drag & drop le fichier privacy_policy.html
# URL : https://noor-privacy.netlify.app/
```

### Option C — Domaine propre
```bash
# Acheter noor-app.com (~10€/an)
# Héberger sur Netlify, Vercel ou tout hébergeur
# URL : https://noor-app.com/privacy
```

---

## PARTIE 5 — APRÈS LA PUBLICATION

### Surveiller les avis et notes
- Répondre aux avis dans les 24h
- Google Play Console → Avis
- App Store Connect → Avis

### Métriques à suivre
- **Taux d'installation** (impressions → installations)
- **Rétention D1, D7, D30**
- **Note moyenne** (objectif : 4.5+)
- **Crashes** (Firebase Crashlytics recommandé)

### Prochaines mises à jour
Planifier pour la v1.1 :
- [ ] Récitations audio téléchargeables hors ligne
- [ ] 99 Noms d'Allah complets
- [ ] Widget écran d'accueil (prochaine prière)
- [ ] Apple Watch / WearOS support
- [ ] Partage de récitations audio
- [ ] Notifier les utilisateurs des nouvelles fonctionnalités

---

## Contacts & Ressources

| Ressource | URL |
|-----------|-----|
| Google Play Console | https://play.google.com/console |
| Apple Developer | https://developer.apple.com |
| App Store Connect | https://appstoreconnect.apple.com |
| Firebase Console | https://console.firebase.google.com |
| Fastlane Docs | https://docs.fastlane.tools |
| Flutter Deployment | https://docs.flutter.dev/deployment |

---

**بارك الله فيكم — Qu'Allah bénisse votre travail** 🌙
