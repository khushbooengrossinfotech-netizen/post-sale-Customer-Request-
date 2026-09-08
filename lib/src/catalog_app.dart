import 'package:flutter/material.dart';

import 'product.dart';
import 'product_art.dart';
import 'shop_controller.dart';

const ink = Color(0xFF203C35);
const paper = Color(0xFFFAF9F6);
const muted = Color(0xFF69726C);

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Forme • Everyday essentials',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ink,
        primary: ink,
        surface: paper,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
        elevation: 0,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: ink,
        displayColor: ink,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E5DF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E5DF)),
        ),
      ),
    ),
    home: const ShopPage(),
  );
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});
  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final shop = ShopController();
  final search = TextEditingController();
  final scroll = ScrollController();
  final collectionKey = GlobalKey();
  int page = 0;
  String category = 'All';
  CatalogSort sort = CatalogSort.featured;

  @override
  void dispose() {
    shop.dispose();
    search.dispose();
    scroll.dispose();
    super.dispose();
  }

  void selectPage(int index) {
    setState(() => page = index);
    if (scroll.hasClients) scroll.jumpTo(0);
  }

  void add(Product product) {
    shop.add(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} added to your bag'),
          action: SnackBarAction(
            label: 'View bag',
            onPressed: () => selectPage(2),
          ),
        ),
      );
  }

  void showProduct(Product product) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 640),
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'A closer look',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close product details',
                    onPressed: () => Navigator.pop(sheetContext),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 230,
                  width: double.infinity,
                  child: ProductArt(product: product),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product.category.toUpperCase(),
                style: const TextStyle(
                  color: muted,
                  letterSpacing: 2,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${money(product.priceCents)}   ·   ★ ${product.rating}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text(
                product.description,
                style: const TextStyle(color: muted, height: 1.6),
              ),
              const SizedBox(height: 16),
              Text(
                product.material,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        add(product);
                      },
                      icon: const Icon(Icons.add_shopping_cart_outlined),
                      label: const Text('Add to bag'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ListenableBuilder(
                    listenable: shop,
                    builder: (context, _) =>
                        _FavoriteButton(product: product, shop: shop),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: shop,
    builder: (context, _) => LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            titleSpacing: wide ? 40 : 20,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: ink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'forme',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.5,
                  ),
                ),
              ],
            ),
            actions: [
              if (wide) ...[
                TextButton(
                  onPressed: () => selectPage(0),
                  child: Text(
                    'Discover',
                    style: TextStyle(
                      fontWeight: page == 0 ? FontWeight.w800 : FontWeight.w400,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => selectPage(1),
                  child: Text(
                    'Favorites',
                    style: TextStyle(
                      fontWeight: page == 1 ? FontWeight.w800 : FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
              IconButton(
                key: const Key('open-bag'),
                tooltip: 'Shopping bag',
                onPressed: () => selectPage(2),
                icon: Badge(
                  isLabelVisible: shop.itemCount > 0,
                  label: Text('${shop.itemCount}'),
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
              SizedBox(width: wide ? 32 : 12),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: page,
                  onDestinationSelected: selectPage,
                  destinations: [
                    const NavigationDestination(
                      icon: Icon(Icons.grid_view_outlined),
                      selectedIcon: Icon(Icons.grid_view_rounded),
                      label: 'Discover',
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                    NavigationDestination(
                      icon: Badge(
                        isLabelVisible: shop.itemCount > 0,
                        label: Text('${shop.itemCount}'),
                        child: const Icon(Icons.shopping_bag_outlined),
                      ),
                      label: 'Bag',
                    ),
                  ],
                ),
          body: SafeArea(
            top: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: page == 2
                    ? _CartPage(shop: shop, onContinue: () => selectPage(0))
                    : SingleChildScrollView(
                        controller: scroll,
                        padding: EdgeInsets.fromLTRB(
                          wide ? 40 : 20,
                          12,
                          wide ? 40 : 20,
                          36,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (page == 0) ...[
                              _HeroBanner(
                                onExplore: () => Scrollable.ensureVisible(
                                  collectionKey.currentContext!,
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeOut,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Wrap(
                                spacing: 26,
                                runSpacing: 12,
                                children: [
                                  _Perk(
                                    icon: Icons.local_shipping_outlined,
                                    text: 'Free shipping over \$100',
                                  ),
                                  _Perk(
                                    icon: Icons.eco_outlined,
                                    text: 'Thoughtful everyday design',
                                  ),
                                  _Perk(
                                    icon: Icons.auto_awesome_outlined,
                                    text: 'A curated collection',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 36),
                            ],
                            Text(
                              page == 0
                                  ? 'Find your everyday favorite.'
                                  : 'Your favorites.',
                              key: collectionKey,
                              style: TextStyle(
                                fontSize: wide ? 30 : 25,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              page == 0
                                  ? 'Good things. Considered details. Made for your day.'
                                  : 'A little collection of things you love.',
                              style: const TextStyle(color: muted, height: 1.5),
                            ),
                            const SizedBox(height: 24),
                            if (page == 0) ...[
                              TextField(
                                key: const Key('catalog-search'),
                                controller: search,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'Search the collection',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: search.text.isEmpty
                                      ? null
                                      : IconButton(
                                          tooltip: 'Clear search',
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            search.clear();
                                            setState(() {});
                                          },
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: ['All', 'Home', 'Tech', 'Accessories']
                                    .map(
                                      (label) => ChoiceChip(
                                        label: Text(label),
                                        selected: category == label,
                                        showCheckmark: false,
                                        onSelected: (_) =>
                                            setState(() => category = label),
                                        selectedColor: ink,
                                        labelStyle: TextStyle(
                                          color: category == label
                                              ? Colors.white
                                              : ink,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        shape: const StadiumBorder(),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 12),
                            ],
                            _collection(),
                            const SizedBox(height: 40),
                            const Divider(color: Color(0xFFE3E5DF)),
                            const SizedBox(height: 16),
                            const Text(
                              'FORME / A Flutter shopping demo',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.4,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    ),
  );

  Widget _collection() {
    final visible = shop.catalog(
      query: page == 0 ? search.text : '',
      category: page == 0 ? category : 'All',
      sort: sort,
      favoritesOnly: page == 1,
    );
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${visible.length} ${visible.length == 1 ? 'piece' : 'pieces'}',
                style: const TextStyle(color: muted),
              ),
            ),
            Expanded(
              flex: 2,
              child: DropdownButton<CatalogSort>(
                isExpanded: true,
                value: sort,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(
                    value: CatalogSort.featured,
                    child: Text('Featured'),
                  ),
                  DropdownMenuItem(
                    value: CatalogSort.priceLow,
                    child: Text(
                      'Price: low to high',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DropdownMenuItem(
                    value: CatalogSort.priceHigh,
                    child: Text(
                      'Price: high to low',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => sort = value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (visible.isEmpty)
          _EmptyState(
            icon: page == 1 ? Icons.favorite_border : Icons.search_off,
            title: page == 1
                ? 'Save a little inspiration.'
                : 'No pieces found.',
            description: page == 1
                ? 'Tap the heart on any product to keep it here.'
                : 'Try another search or explore all categories.',
            action: page == 1 ? 'Explore the collection' : 'Reset filters',
            onAction: () {
              search.clear();
              setState(() {
                category = 'All';
                page = 0;
              });
            },
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 900
                  ? 3
                  : constraints.maxWidth > 430
                  ? 2
                  : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 20) / columns;
              return Wrap(
                spacing: 20,
                runSpacing: 24,
                children: visible
                    .map(
                      (product) => SizedBox(
                        width: width,
                        child: _ProductCard(
                          product: product,
                          shop: shop,
                          onOpen: () => showProduct(product),
                          onAdd: () => add(product),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onExplore});
  final VoidCallback onExplore;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth > 650;
      final copy = Padding(
        padding: EdgeInsets.all(wide ? 36 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LESS, BUT BETTER. / VOL. 01',
              style: TextStyle(
                color: Color(0xFFBFD2C7),
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Objects for\neveryday living.',
              style: TextStyle(
                color: Colors.white,
                fontSize: wide ? 45 : 34,
                height: 1.1,
                letterSpacing: -1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thoughtful essentials for the spaces\nand moments that are yours.',
              style: TextStyle(color: Color(0xFFD4DED8), height: 1.6),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onExplore,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF4EBDD),
                foregroundColor: ink,
              ),
              label: const Text('Explore the collection'),
              icon: const Icon(Icons.arrow_forward, size: 18),
            ),
          ],
        ),
      );
      final art = Stack(
        children: [
          Positioned.fill(child: ProductArt(product: products[1])),
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: paper,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'THE ARC CHAIR\nA softer place to land.',
                style: TextStyle(fontSize: 11, height: 1.8, letterSpacing: 0.8),
              ),
            ),
          ),
        ],
      );
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: ColoredBox(
          color: ink,
          child: wide
              ? Row(
                  children: [
                    Expanded(flex: 6, child: copy),
                    Expanded(flex: 4, child: SizedBox(height: 348, child: art)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    copy,
                    SizedBox(height: 220, child: art),
                  ],
                ),
        ),
      );
    },
  );
}

class _Perk extends StatelessWidget {
  const _Perk({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: muted),
      const SizedBox(width: 8),
      Flexible(
        child: Text(text, style: const TextStyle(color: muted, fontSize: 12)),
      ),
    ],
  );
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.shop,
    required this.onOpen,
    required this.onAdd,
  });
  final Product product;
  final ShopController shop;
  final VoidCallback onOpen;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Semantics(
              button: true,
              label: 'View ${product.name}',
              child: Material(
                color: product.color,
                child: InkWell(
                  key: Key('product-${product.id}'),
                  onTap: onOpen,
                  child: SizedBox(
                    height: 230,
                    child: IgnorePointer(child: ProductArt(product: product)),
                  ),
                ),
              ),
            ),
            if (product.badge != null)
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: paper.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.badge!,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 6,
              right: 6,
              child: _FavoriteButton(product: product, shop: shop),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: Text(
              product.category.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                color: muted,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Text(
            '★ ${product.rating}',
            style: const TextStyle(fontSize: 12, color: muted),
          ),
        ],
      ),
      const SizedBox(height: 6),
      TextButton(
        onPressed: onOpen,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 32),
          alignment: Alignment.centerLeft,
        ),
        child: Text(
          product.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      Row(
        children: [
          Expanded(
            child: Text(
              money(product.priceCents),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton.outlined(
            key: Key('add-${product.id}'),
            tooltip: 'Add ${product.name} to bag',
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 20),
          ),
        ],
      ),
    ],
  );
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.product, required this.shop});
  final Product product;
  final ShopController shop;
  @override
  Widget build(BuildContext context) => IconButton(
    key: Key('favorite-${product.id}'),
    tooltip: shop.isFavorite(product)
        ? 'Remove ${product.name} from favorites'
        : 'Save ${product.name} to favorites',
    style: IconButton.styleFrom(backgroundColor: paper.withValues(alpha: 0.9)),
    onPressed: () => shop.toggleFavorite(product),
    icon: Icon(
      shop.isFavorite(product) ? Icons.favorite : Icons.favorite_border,
      size: 21,
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.description,
    required this.action,
    required this.onAction,
  });
  final IconData icon;
  final String title;
  final String description;
  final String action;
  final VoidCallback onAction;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 56),
    child: Center(
      child: Column(
        children: [
          Icon(icon, size: 48, color: muted),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: muted, height: 1.5),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: onAction, child: Text(action)),
        ],
      ),
    ),
  );
}

class _CartPage extends StatelessWidget {
  const _CartPage({required this.shop, required this.onContinue});
  final ShopController shop;
  final VoidCallback onContinue;

  Future<void> checkout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Place a demo order?'),
        content: Text(
          '${shop.itemCount} items · ${money(shop.totalCents)}\n\nThis simulates checkout. No payment is collected and no real order will be placed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep shopping'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Place demo order'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    shop.completeDemoOrder();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle_outline, color: ink, size: 48),
        title: const Text('Demo order complete'),
        content: const Text(
          'You tried the full shopping flow. Your bag is now empty. No payment was taken.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue exploring'),
          ),
        ],
      ),
    );
    if (context.mounted) onContinue();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your shopping bag.',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${shop.itemCount} ${shop.itemCount == 1 ? 'item' : 'items'} to make the everyday better.',
          style: const TextStyle(color: muted),
        ),
        const SizedBox(height: 24),
        if (shop.itemCount == 0)
          _EmptyState(
            icon: Icons.shopping_bag_outlined,
            title: 'Good things belong here.',
            description: 'Explore the collection and add something you love.',
            action: 'Explore the collection',
            onAction: onContinue,
          )
        else ...[
          ...products
              .where((p) => shop.quantityFor(p) > 0)
              .map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 88,
                          height: 106,
                          child: ProductArt(product: product),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              money(product.priceCents),
                              style: const TextStyle(color: muted),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                IconButton(
                                  key: Key('decrease-${product.id}'),
                                  tooltip: 'Decrease ${product.name} quantity',
                                  onPressed: () => shop.decrease(product),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text(
                                  '${shop.quantityFor(product)}',
                                  key: Key('quantity-${product.id}'),
                                ),
                                IconButton(
                                  key: Key('increase-${product.id}'),
                                  tooltip: 'Increase ${product.name} quantity',
                                  onPressed: () => shop.add(product),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                                IconButton(
                                  tooltip: 'Remove ${product.name}',
                                  onPressed: () => shop.remove(product),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 21,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              money(
                                product.priceCents * shop.quantityFor(product),
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const Divider(),
          const SizedBox(height: 16),
          _TotalLine(label: 'Subtotal', value: money(shop.subtotalCents)),
          _TotalLine(
            label: 'Shipping',
            value: shop.shippingCents == 0 ? 'Free' : money(shop.shippingCents),
          ),
          const SizedBox(height: 12),
          _TotalLine(label: 'Total', value: money(shop.totalCents), bold: true),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const Key('checkout'),
              onPressed: () => checkout(context),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Demo checkout'),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sample prices in USD. Shipping is \$5, or free on orders of \$100 or more. No taxes or payments are processed in this demo.',
            style: TextStyle(fontSize: 12, color: muted, height: 1.6),
          ),
        ],
      ],
    ),
  );
}

class _TotalLine extends StatelessWidget {
  const _TotalLine({
    required this.label,
    required this.value,
    this.bold = false,
  });
  final String label;
  final String value;
  final bool bold;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: bold ? 20 : 15,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 20 : 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
