# Login App — Flutter

Application mobile développée avec Flutter permettant de se connecter à une API REST Node.js, de consulter son profil et de conserver sa session grâce à un JWT stocké de manière sécurisée.

## Technologies

- Flutter / Dart
- Material Design 3
- `http` — communication avec l'API REST
- `flutter_secure_storage` — stockage sécurisé du JWT

## Fonctionnalités

- Formulaire de connexion avec email et mot de passe.
- Validation des champs avant envoi.
- Affichage des erreurs de connexion.
- Affichage d'un indicateur de chargement.
- Possibilité d'afficher ou masquer le mot de passe.
- Communication HTTP avec une API Node.js.
- Récupération des informations de l'utilisateur.
- Affichage du profil (nom, email et rôle).
- Stockage sécurisé du JWT.
- Vérification de la session au démarrage.
- Reconnexion automatique si le token est valide.
- Déconnexion avec suppression du token.
- Interface responsive.

## Installation

Vérifier que Flutter est installé :

```bash
flutter doctor
```

Installer les dépendances :

```bash
flutter pub get
```

## Configuration de l'API

L'application communique avec un serveur Node.js sur le port `3000`.

Dans `lib/services/auth_service.dart`, configurer l'adresse selon la plateforme utilisée.

**Émulateur Android :**

```dart
final String baseUrl = 'http://10.0.2.2:3000';
```

**macOS ou Flutter Desktop :**

```dart
final String baseUrl = 'http://localhost:3000';
```

**Appareil Android physique :**

Utiliser l'adresse IP locale de l'ordinateur hébergeant l'API. Le téléphone et l'ordinateur doivent pouvoir communiquer sur le même réseau, et le serveur doit écouter sur une interface accessible.

### Configuration Android

Dans `android/app/src/main/AndroidManifest.xml`, vérifier la présence de :

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

Pour autoriser les connexions HTTP locales pendant le développement, ajouter dans la balise `<application>` :

```xml
android:usesCleartextTraffic="true"
```

En production, privilégier HTTPS.

## Lancement

Démarrer d'abord l'API Node.js :

```bash
node server.js
```

Puis lancer l'application Flutter :

```bash
flutter run
```

Pour cibler un émulateur Android :

```bash
flutter run -d <device_id>
```

Pour afficher les appareils disponibles :

```bash
flutter devices
```

## Comptes de test

| Email | Mot de passe |
|---|---|
| jean@example.com | userpass |
| admin@example.com | adminpass |

## Structure du projet

```text
lib/
├── main.dart
├── models/
│   └── user_model.dart
├── screens/
│   ├── login_screen.dart
│   └── profile_screen.dart
└── services/
    ├── auth_service.dart
    └── token_storage_service.dart
```

### Connexion

1. L'utilisateur saisit son email et son mot de passe.
2. Flutter vérifie les champs du formulaire.
3. Une requête `POST /api/login` est envoyée au backend.
4. Le backend vérifie les identifiants.
5. Si la connexion réussit, l'API retourne les informations utilisateur et un JWT.
6. Le JWT est enregistré avec `flutter_secure_storage`.
7. L'application affiche l'écran de profil.

### Persistance de session

Au démarrage, le widget `AuthGate` vérifie la session :

1. Il récupère le JWT enregistré.
2. Il envoie une requête `GET /api/me` avec ce token.
3. Si le token est valide, l'utilisateur accède directement à son profil.
4. Si le token est absent, expiré ou invalide, l'écran de connexion est affiché.

Le JWT expire après 1 heure. Aucun mécanisme de renouvellement automatique n'est actuellement implémenté.

### Déconnexion

Lorsque l'utilisateur clique sur « Se déconnecter » :

1. Le JWT est supprimé du stockage sécurisé.
2. L'application revient à l'écran de connexion.
3. Une nouvelle authentification est nécessaire pour accéder au profil.

## Sécurité

- Les mots de passe ne sont pas enregistrés localement.
- Le JWT est stocké avec `flutter_secure_storage`.
- Les routes protégées utilisent l'en-tête `Authorization: Bearer <JWT>`.
- La validité du token est vérifiée par le backend.
- La déconnexion supprime le token local.
