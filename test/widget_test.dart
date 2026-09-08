import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_catalog_demo/src/catalog_app.dart';

void main() {
  testWidgets(
    'search, save, inspect, add, change quantity and complete checkout',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const CatalogApp());
      await tester.enterText(
        find.byKey(const Key('catalog-search')),
        'headphones',
      );
      await tester.pumpAndSettle();
      expect(find.text('1 piece'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key('favorite-sound-01')));
      await tester.tap(find.byKey(const Key('favorite-sound-01')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(find.text('Studio headphones'), findsOneWidget);
      await tester.tap(find.byKey(const Key('product-sound-01')));
      await tester.pumpAndSettle();
      expect(find.text('A closer look'), findsOneWidget);
      await tester.tap(find.text('Add to bag'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('open-bag')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('increase-sound-01')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('quantity-sound-01'))).data,
        '2',
      );
      expect(find.text('\$258.00'), findsWidgets);
      await tester.tap(find.byKey(const Key('checkout')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep shopping'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('quantity-sound-01')), findsOneWidget);
      await tester.tap(find.byKey(const Key('checkout')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Place demo order'));
      await tester.pumpAndSettle();
      expect(find.text('Demo order complete'), findsOneWidget);
      await tester.tap(find.text('Continue exploring'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('open-bag')));
      await tester.pumpAndSettle();
      expect(find.text('Good things belong here.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('empty search can reset and narrow layouts remain usable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const CatalogApp());
    await tester.ensureVisible(find.byKey(const Key('catalog-search')));
    await tester.enterText(
      find.byKey(const Key('catalog-search')),
      'nothing-matches',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Reset filters'));
    await tester.tap(find.text('Reset filters'));
    await tester.pumpAndSettle();
    expect(find.text('6 pieces'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('add-sound-01')));
    await tester.tap(find.byKey(const Key('add-sound-01')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-bag')));
    await tester.pumpAndSettle();
    expect(find.text('Your shopping bag.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
