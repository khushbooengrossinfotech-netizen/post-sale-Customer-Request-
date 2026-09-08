import 'package:flutter/foundation.dart';

import 'product.dart';

enum CatalogSort { featured, priceLow, priceHigh }

/// In-memory demo state. No account, network, or payment service is used.
class ShopController extends ChangeNotifier {
  final Map<String, int> _cart = {};
  final Set<String> _favorites = {};

  Map<String, int> get cart => Map.unmodifiable(_cart);
  int get itemCount => _cart.values.fold(0, (sum, quantity) => sum + quantity);
  int get subtotalCents => products.fold(
    0,
    (sum, product) => sum + product.priceCents * quantityFor(product),
  );
  int get shippingCents => itemCount == 0 || subtotalCents >= 10000 ? 0 : 500;
  int get totalCents => subtotalCents + shippingCents;
  int quantityFor(Product product) => _cart[product.id] ?? 0;
  bool isFavorite(Product product) => _favorites.contains(product.id);

  void toggleFavorite(Product product) {
    if (!_favorites.remove(product.id)) _favorites.add(product.id);
    notifyListeners();
  }

  void add(Product product) {
    _cart[product.id] = quantityFor(product) + 1;
    notifyListeners();
  }

  void decrease(Product product) {
    final quantity = quantityFor(product);
    if (quantity <= 1) {
      _cart.remove(product.id);
    } else {
      _cart[product.id] = quantity - 1;
    }
    notifyListeners();
  }

  void remove(Product product) {
    _cart.remove(product.id);
    notifyListeners();
  }

  void completeDemoOrder() {
    _cart.clear();
    notifyListeners();
  }

  List<Product> catalog({
    String query = '',
    String category = 'All',
    CatalogSort sort = CatalogSort.featured,
    bool favoritesOnly = false,
  }) {
    final term = query.trim().toLowerCase();
    final result = products
        .where(
          (product) =>
              (category == 'All' || product.category == category) &&
              (!favoritesOnly || isFavorite(product)) &&
              '${product.name} ${product.category} ${product.description}'
                  .toLowerCase()
                  .contains(term),
        )
        .toList();
    if (sort != CatalogSort.featured) {
      result.sort(
        (a, b) => sort == CatalogSort.priceLow
            ? a.priceCents.compareTo(b.priceCents)
            : b.priceCents.compareTo(a.priceCents),
      );
    }
    return result;
  }
}
