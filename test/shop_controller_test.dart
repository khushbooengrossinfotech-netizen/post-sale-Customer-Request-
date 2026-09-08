import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_catalog_demo/src/product.dart';
import 'package:shopping_catalog_demo/src/shop_controller.dart';

void main() {
  late ShopController shop;
  setUp(() => shop = ShopController());
  tearDown(() => shop.dispose());

  test('search, category and favorites compose; price sort is numeric', () {
    shop.toggleFavorite(products[2]);
    shop.toggleFavorite(products[1]);
    expect(
      shop.catalog(query: '  LAMP ', category: 'Home', favoritesOnly: true),
      [products[2]],
    );
    expect(shop.catalog(query: 'lamp', category: 'Tech'), isEmpty);
    expect(shop.catalog(sort: CatalogSort.priceLow).first, products[4]);
    expect(shop.catalog(sort: CatalogSort.priceHigh).first, products[1]);
    shop.toggleFavorite(products[2]);
    expect(shop.catalog(favoritesOnly: true), [products[1]]);
  });

  test(
    'cart quantities, shipping threshold and removal update exact totals',
    () {
      expect(shop.totalCents, 0);
      shop.add(products[4]);
      expect(shop.totalCents, 3700);
      shop.add(products[4]);
      shop.add(products[3]);
      expect(shop.itemCount, 3);
      expect(shop.subtotalCents, 10900);
      expect(shop.shippingCents, 0);
      shop.decrease(products[4]);
      expect(shop.totalCents, 8200);
      shop.remove(products[3]);
      shop.decrease(products[4]);
      shop.decrease(products[4]);
      expect(shop.cart, isEmpty);
      expect(shop.totalCents, 0);
    },
  );

  test('demo checkout clears the bag and preserves favorites', () {
    shop.toggleFavorite(products.first);
    shop.add(products.first);
    shop.completeDemoOrder();
    expect(shop.itemCount, 0);
    expect(shop.totalCents, 0);
    expect(shop.isFavorite(products.first), isTrue);
  });
}
