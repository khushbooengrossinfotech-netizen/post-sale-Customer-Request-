# Forme — Flutter shopping catalog demo

A responsive shopping demo for Android, iOS, and web, made with Flutter and Material 3. It includes six original product illustrations, a curated catalog, and a complete simulated shopping flow.

## Features

- Search products, filter by category, and sort by price.
- Open product details and save favorites.
- Add products to a bag, adjust quantities, and remove items.
- See exact USD totals, with $5 shipping below $100 and free shipping at $100 or more.
- Complete or cancel a clearly labeled demo checkout.
- Responsive phone, tablet, and desktop layouts, with accessible labels and empty states.
- Product data and vector artwork bundled in the app; no API keys, accounts, or backend required.

## Run

Developed and checked with **Flutter 3.35.4 / Dart 3.9.2**. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install), then run:

```sh
flutter pub get
flutter run -d chrome
```

For an Android emulator or iOS simulator:

```sh
flutter devices
flutter run -d <device-id>
```

Android requires its SDK. iOS requires macOS and Xcode; choose your own development team and bundle ID in Xcode before installing on a physical device. The repository does not include a developer signing team.

## Check and build

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web --release
```

GitHub Actions runs these checks on pushes and pull requests. The web build is written to `build/web`. Serve that directory over HTTP rather than opening `index.html` directly.

## Code layout

| Path | Purpose |
| --- | --- |
| `lib/main.dart` | Application entry point |
| `lib/src/catalog_app.dart` | Theme, catalog, details, favorites, bag, and checkout screens |
| `lib/src/product.dart` | Immutable sample catalog and currency formatting |
| `lib/src/product_art.dart` | Original Flutter Canvas product illustrations |
| `lib/src/shop_controller.dart` | Testable filtering, favorites, quantities, and totals |
| `test/` | Shopping-flow widget tests and controller tests |
| `.github/workflows/flutter.yml` | Automated validation and web build |

## Demo scope

All product names, descriptions, ratings, and prices are fictional sample data. Cart and favorites are kept in memory and reset when the app restarts or the web page reloads. Checkout clears the cart after a simulated order; it does not contact a store, collect payment, calculate taxes, or save an order. Add a backend, persistence, real inventory, and a payment integration before adapting this into a production shop.
