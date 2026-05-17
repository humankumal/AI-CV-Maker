# AI CV Maker

A minimalistic, AI-powered CV/resume builder for **UK, USA, Canada, Australia, and India**.
Built with Flutter for Android, iOS, and web.

- 50 ATS-friendly templates (10 per country)
- Step-by-step guided form with auto-save
- AI rewriting via Google Gemini — never invents new facts
- Live preview + clean PDF export
- Manage multiple CVs locally (rename, duplicate, edit, delete)

## Stack

| Concern | Choice |
|---|---|
| State management | `provider` |
| Routing | `go_router` |
| AI | Google Gemini (`google_generative_ai`) — BYOK |
| PDF | `pdf` + `printing` |
| Local storage | JSON files via `path_provider` |
| Secure key store | `flutter_secure_storage` |
| Typography | `google_fonts` + Material 3 |

## Getting Started

```bash
# 1. Generate platform folders (preserves lib/)
flutter create .

# 2. Install dependencies
flutter pub get

# 3. Run
flutter run -d chrome      # web
flutter run                # connected device
```

## AI Key (optional)

The rewrite features use Google Gemini. To enable them:

1. Get a free key at https://aistudio.google.com/apikey
2. Open the app → **Settings** → paste the key

The rest of the app works without a key.

## Project Layout

```
lib/
├── main.dart, app.dart
├── core/         theme, routing, constants
├── models/       immutable data classes with JSON
├── services/     repository, AI, PDF, settings, country catalog
├── state/        ChangeNotifier providers
├── features/     one folder per screen
├── shared/       reusable widgets
└── utils/        helpers
```

## Tests

```bash
flutter test
```

## License

Proprietary.
