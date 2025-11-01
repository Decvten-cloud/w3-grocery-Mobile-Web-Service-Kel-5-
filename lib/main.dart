import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/product.dart';
import 'pages/homepage.dart';
import 'pages/orders.dart';
import 'pages/cart.dart';
import 'pages/favorites.dart';
import 'pages/profile.dart';

void main() => runApp(const GroceryApp());

class GroceryApp extends StatefulWidget {
  const GroceryApp({super.key});
  @override
  State<GroceryApp> createState() => _GroceryAppState();
}

class _GroceryAppState extends State<GroceryApp> {
  int brandIndex = 0;
  bool dark = false;

  static const kBrandColors = <Color>[
    Color(0xFF10B981), // green
    Color(0xFF3B82F6), // blue
    Color(0xFFF59E0B), // amber
    Color(0xFFEF4444), // red
    Color(0xFF06B6D4), // cyan
    Color(0xFF8B5CF6), // violet
  ];

  ThemeData _theme(Brightness b) {
    final seed =
        _GroceryAppState.kBrandColors[brandIndex % kBrandColors.length];
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: b);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: b == Brightness.dark
          ? const Color(0xFF0E1628)
          : const Color(0xFFF6F7F9),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery',
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      home: RootShell(
        onPickBrand: (i) => setState(() => brandIndex = i),
        onToggleDark: () => setState(() => dark = !dark),
        brandIndex: brandIndex,
        brandColors: _GroceryAppState.kBrandColors,
        dark: dark,
      ),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({
    super.key,
    required this.onPickBrand,
    required this.onToggleDark,
    required this.brandIndex,
    required this.brandColors,
    required this.dark,
  });

  final void Function(int) onPickBrand;
  final VoidCallback onToggleDark;
  final int brandIndex;
  final List<Color> brandColors;
  final bool dark;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _tab = 0;
  final cart = <String, int>{};
  final fav = <String>{};

  void addToCart(Product p) =>
      setState(() => cart.update(p.id, (v) => v + 1, ifAbsent: () => 1));
  void removeFromCart(Product p) => setState(
    () => cart.update(p.id, (v) => math.max(0, v - 1), ifAbsent: () => 0),
  );
  void toggleFav(Product p) =>
      setState(() => fav.contains(p.id) ? fav.remove(p.id) : fav.add(p.id));

  Widget _buildCurrentPage() {
    switch (_tab) {
      case 0:
        return HomePage(
          cart: cart,
          fav: fav,
          onAdd: (p) => addToCart(p as Product),
          onFav: (p) => toggleFav(p as Product),
          onOpenDetail: (p) {},
        );
      case 1:
        return OrdersPage();
      case 2:
        return CartPage(
          cart: cart,
          onAdd: (p) => addToCart(p),
          onRemove: (p) => removeFromCart(p),
        );
      case 3:
        return FavoritesPage(
          fav: fav,
          onFav: (p) => toggleFav(p),
          onAdd: (p) => addToCart(p),
          onOpenDetail: (p) {},
        );
      case 4:
        return ProfilePage(onOpenOrders: () => setState(() => _tab = 1));
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens_rounded),
            onPressed: () => _openCustomizer(context),
          ),
        ],
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _openCustomizer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Color',
                    style: Theme.of(ctx).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onToggleDark,
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.wb_sunny
                          : Icons.nightlight_round,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(widget.brandColors.length, (i) {
                  final c = widget.brandColors[i];
                  final active = widget.brandIndex == i;
                  return GestureDetector(
                    onTap: () {
                      widget.onPickBrand(i);
                      // Don't pop, allow user to try different colors
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: active
                              ? Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : cs.onPrimary
                              : Colors.transparent,
                          width: active ? 2.5 : 0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.black38
                                : Colors.black26,
                          ),
                        ],
                      ),
                      child: active
                          ? Icon(
                              Icons.check,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : cs.onPrimary,
                              size: 18,
                            )
                          : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
