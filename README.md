# AnimeQuotes 🌸 - Cross-Platform Flutter App

A cross-platform Flutter application built to display daily and random anime quotes fetched from the open-source **Animechan API v1**.

---

## 🚀 Features & Implementation

- **AppBar**:
  - **Middle**: Styled Anime logo badge + **AnimeQuotes** title text.
  - **Theme Switcher**: Smooth animated toggle button between **Light Mode** (Sakura/Pastel) and **Dark Mode** (Cyberpunk/Dark Slate).
- **Search Bar**:
  - Rounded search input with magnifying **lens icon**.
  - **Hidden as comment**: The array search logic (`GET /quotes?character=...` & `GET /quotes?anime=...`) is ready and commented out as requested.
- **Quote Card**:
  - **Quote text**: Parsed from `data:content`.
  - **Character name**: Parsed from `data:character{name}` with avatar badge.
  - **Anime series**: Parsed from `data:anime{name}` with series icon.
  - **Quick actions**: 1-tap copy to clipboard with floating SnackBar confirmation.
- **Refresh Control**:
  - Animated **Next Quote** button with rotation effect.
  - Native **Pull-to-Refresh** (`RefreshIndicator`).
- **Quick Pick Chips**:
  - Pre-configured filters for **Random**, **Naruto**, **One Piece**, **Bleach**, and **Demon Slayer**.
- **Offline / Graceful Error Handling**:
  - Automatic fallback quote if offline or if network encounters delays.

---

## 📡 API Details

- **Base URL**: `https://api.animechan.io/v1/`
- **Authentication**: None

### Endpoints Used & Tested:
| Action | Method | Endpoint |
|---|---|---|
| Random Quote | `GET` | `https://api.animechan.io/v1/quotes/random` |
| Filter by Anime | `GET` | `https://api.animechan.io/v1/quotes/random?anime={name}` |
| Filter by Character | `GET` | `https://api.animechan.io/v1/quotes?character={name}` |
| Array Search | `GET` | `https://api.animechan.io/v1/quotes` |

---

## 📂 Project Architecture

```
lib/
├── main.dart                      # App entry point, state management & home view
├── models/
│   └── quote_model.dart           # Quote data model handling JSON responses
├── services/
│   └── anime_quote_service.dart   # HTTP Client service consuming Animechan v1
├── theme/
│   └── app_theme.dart             # Material 3 Light & Dark design themes
└── widgets/
    ├── anime_logo.dart            # Centered AppBar Logo & Title
    ├── quote_card.dart            # Quote display (content, character, anime)
    └── search_bar_widget.dart     # Search bar with commented array-search logic
test/
├── quote_model_test.dart          # Unit tests for JSON schema parsing
└── widget_test.dart               # Widget smoke tests
```

---

## 🔍 How to Enable Search Functionality

In [lib/widgets/search_bar_widget.dart](lib/widgets/search_bar_widget.dart) and [lib/main.dart](lib/main.dart), search functionality that populates quotes from the returned API array is preserved in comments:

1. In `lib/widgets/search_bar_widget.dart`, locate the `_handleSearch(String query)` method.
2. In `lib/main.dart`, uncomment `_searchResults`, `_performSearch()`, and render a `ListView.builder` for the array when `_searchResults.isNotEmpty`.

---

## 📱 How to Run

### Run on Web (Chrome / Edge):
```bash
flutter run -d chrome
```

### Run on Windows Desktop:
```bash
flutter run -d windows
```

### Run on Mobile (Android / iOS):
Connect your physical device or launch an emulator, then run:
```bash
flutter run
```

### Run Unit & Widget Tests:
```bash
flutter test
```
