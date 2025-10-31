import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const GroceryApp());

/* ============================ APP ROOT ============================ */
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
    Color(0xFF22C55E), // emerald
    Color(0xFFF472B6), // pink
    Color(0xFFFF7849), // orange
    Color(0xFF14B8A6), // teal
    Color(0xFF6366F1), // indigo
    Color(0xFFA3E635), // lime
  ];

  ThemeData _theme(Brightness b) {
  final seed = _GroceryAppState.kBrandColors[brandIndex];
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: b);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: GoogleFonts.interTextTheme(),
    scaffoldBackgroundColor:
        b == Brightness.dark ? const Color(0xFF0E1628) : const Color(0xFFF6F7F9),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
    // HAPUS cardTheme custom → pakai default bawaan supaya kompatibel di semua versi
  );
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery Look-alike',
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

/* ============================ ROOT + NAV ============================ */
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
  final cart = <String, int>{}; // productId -> qty
  final fav = <String>{};

  void addToCart(Product p) =>
      setState(() => cart.update(p.id, (v) => v + 1, ifAbsent: () => 1));
  void removeFromCart(Product p) =>
      setState(() => cart.update(p.id, (v) => math.max(0, v - 1), ifAbsent: () => 0));
  void toggleFav(Product p) =>
      setState(() => fav.contains(p.id) ? fav.remove(p.id) : fav.add(p.id));

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        cart: cart,
        fav: fav,
        onAdd: addToCart,
        onFav: toggleFav,
        onOpenColorPicker: () => _openCustomizer(context),
        onOpenDetail: (p) => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailPage(p: p, onAdd: addToCart)),
        ),
      ),
      OrdersPage(),
      CartPage(
        cart: cart,
        onAdd: (p) => addToCart(p),
        onRemove: (p) => removeFromCart(p),
      ),
      FavoritesPage(
        fav: fav,
        onFav: toggleFav,
        onAdd: addToCart,
        onOpenDetail: (p) => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailPage(p: p, onAdd: addToCart)),
        ),
      ),
      ProfilePage(onOpenOrders: () => setState(() => _tab = 1)),
    ];

    return Scaffold(
      body: pages[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.shopping_bag_rounded), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.favorite_rounded), label: 'Fav'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCustomizer(context),
        icon: const Icon(Icons.tune),
        label: const Text('Customize'),
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
              Text('Select Color',
                  style:
                      Theme.of(ctx).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800)),
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
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: active ? cs.onPrimary : Colors.white,
                          width: active ? 2.5 : 2,
                        ),
                        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
                      ),
                      child: active
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: widget.onToggleDark,
                      icon: Icon(Theme.of(context).brightness == Brightness.dark
                          ? Icons.wb_sunny
                          : Icons.nightlight_round),
                      label: Text(Theme.of(context).brightness == Brightness.dark
                          ? 'Light Mode'
                          : 'Dark Mode'),
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

/* ============================ DATA MOCK ============================ */
class Product {
  final String id, name, img, tag;
  final double price, oldPrice;
  const Product(this.id, this.name, this.img, this.price, this.oldPrice, this.tag);
}

const kPromoImages = [
  'https://images.unsplash.com/photo-1586201375754-1421e0aa2f63?auto=format&fit=crop&w=1600&q=80',
  'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?auto=format&fit=crop&w=1600&q=80',
  'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=1600&q=80',
];

const kProducts = <Product>[
  Product(
      'p1',
      'Fresh Grapes',
      'https://images.unsplash.com/photo-1519996529931-28324d5a630e?auto=format&fit=crop&w=1200&q=80',
      10.9,
      12.9,
      'Fruits'),
  Product(
      'p2',
      'Gurame Fish',
      'https://images.unsplash.com/photo-1603064752734-4b7aef0b0b0d?auto=format&fit=crop&w=1200&q=80',
      10.9,
      12.0,
      'Fish'),
  Product(
      'p3',
      'Tomatoes',
      'https://images.unsplash.com/photo-1542838038-3b3b4f31c2c3?auto=format&fit=crop&w=1200&q=80',
      10.9,
      12.0,
      'Vegetables'),
  Product(
      'p4',
      'Chicken Village',
      'https://images.unsplash.com/photo-1609137144813-7d99208993a1?auto=format&fit=crop&w=1200&q=80',
      10.9,
      11.9,
      'Meat'),
  Product(
      'p5',
      'Sweet Young Coconut',
      'https://images.unsplash.com/photo-1586201375754-1421e0aa2f63?auto=format&fit=crop&w=1200&q=80',
      4.0,
      8.9,
      'Fruits'),
  Product(
      'p6',
      'Fresh Spinach',
      'https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=1200&q=80',
      7.2,
      8.9,
      'Vegetables'),
  Product(
      'p7',
      'Chocolate Chips',
      'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=1200&q=80',
      12.0,
      12.0,
      'Bakery'),
];

const kCategories = <(String, IconData, Color)>[
  ('Fruits', Icons.apple_rounded, Color(0xFF34D399)),
  ('Fish', Icons.set_meal_rounded, Color(0xFF60A5FA)),
  ('Chicken', Icons.lunch_dining_rounded, Color(0xFFF472B6)),
  ('Pizza', Icons.local_pizza_rounded, Color(0xFFFFA34D)),
  ('Drinks', Icons.local_drink_rounded, Color(0xFF38BDF8)),
];

/* ============================ PAGES ============================ */
// HOME
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.cart,
    required this.fav,
    required this.onAdd,
    required this.onFav,
    required this.onOpenColorPicker,
    required this.onOpenDetail,
  });

  final Map<String, int> cart;
  final Set<String> fav;
  final void Function(Product) onAdd;
  final void Function(Product) onFav;
  final VoidCallback onOpenColorPicker;
  final void Function(Product) onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final content = CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const Text('Grocery'),
          actions: [
            IconButton(onPressed: onOpenColorPicker, icon: const Icon(Icons.color_lens_rounded)),
            Stack(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
                Positioned(right: 10, top: 10, child: _Dot(color: cs.primary)),
              ],
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  const Expanded(child: _SearchBox(hint: 'Search beverages or foods')),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: cs.primaryContainer,
                    radius: 18,
                    child: Text('6',
                        style: TextStyle(
                            color: cs.onPrimaryContainer, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: _GreetingCard()),
        SliverToBoxAdapter(
          child: _PromoBannerCarousel(
            images: kPromoImages,
            title: 'Happy Weekend\n20% OFF',
            caption: '*for All Menus',
            onTap: () {},
          ),
        ),
        SliverToBoxAdapter(
          child: const _SectionTitle(
            'Categories',
            trailing: Icon(Icons.chevron_right_rounded),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 96,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => _CategoryChip(item: kCategories[i]),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: kCategories.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: _SectionTitle('Popular Deals')),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverGrid.extent(
            maxCrossAxisExtent: 260,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: .68, // lebih tinggi supaya tidak overflow
            children: [
              for (final p in kProducts)
                _ProductCard(
                  p: p,
                  inFav: fav.contains(p.id),
                  onFav: () => onFav(p),
                  onAdd: () => onAdd(p),
                  onOpen: () => onOpenDetail(p),
                ),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );

    return Stack(
      children: [
        content,
        Positioned(
          right: 8,
          top: MediaQuery.of(context).size.height * 0.35,
          child: _SideRailButton(
            label: 'View Product',
            onTap: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (_) => const _QuickPreviewSheet(),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ORDERS
class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});
  final tabs = const ['All', 'On Delivery', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          leading: const SizedBox(),
          bottom: TabBar(tabs: [for (final t in tabs) Tab(text: t)]),
        ),
        body: const TabBarView(
          children: [
            _OrdersList(statusFilter: null),
            _OrdersList(statusFilter: 'On Delivery'),
            _OrdersList(statusFilter: 'Completed'),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: FilledButton(
            onPressed: () {},
            child: const Text('TRACK ORDER'),
          ),
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({this.statusFilter});
  final String? statusFilter;

  @override
  Widget build(BuildContext context) {
    final orders =
        _mockOrders.where((o) => statusFilter == null || o.status == statusFilter).toList();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemBuilder: (_, i) => _OrderCard(orders[i]),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: orders.length,
    );
  }
}

class OrderData {
  final String id;
  final String status;
  final List<String> steps;
  OrderData(this.id, this.status, this.steps);
}

final _mockOrders = <OrderData>[
  OrderData('#0012345', 'On Delivery', [
    'Order Placed',
    'Order Confirmed',
    'Your Order On Delivery by Courier',
    'Order Delivered',
  ]),
  OrderData('#0012346', 'Completed', [
    'Order Placed',
    'Order Confirmed',
    'Your Order On Delivery by Courier',
    'Order Delivered',
  ]),
];

class _OrderCard extends StatelessWidget {
  const _OrderCard(this.data);
  final OrderData data;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.local_shipping_rounded, color: cs.primary),
              const SizedBox(width: 8),
              Text('Order ID ${data.id}', style: const TextStyle(fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(data.status, style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 10),
            for (int i = 0; i < data.steps.length; i++)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    i <= 2 ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: i <= 2 ? cs.primary : Theme.of(context).textTheme.bodySmall!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(data.steps[i])),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// CART
class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.cart, required this.onAdd, required this.onRemove});
  final Map<String, int> cart;
  final void Function(Product) onAdd;
  final void Function(Product) onRemove;

  @override
  Widget build(BuildContext context) {
    final items = kProducts.where((p) => cart[p.id] != null && cart[p.id]! > 0).toList();
    final subtotal =
        items.fold<double>(0, (s, p) => s + p.price * cart[p.id]!.toDouble());
    final tax = subtotal * 0.02;
    final total = subtotal - 1.08 + tax; // meniru contoh

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          for (final p in items)
            _CartRow(
              p: p,
              qty: cart[p.id]!,
              onInc: () => onAdd(p),
              onDec: () => onRemove(p),
            ),
          const SizedBox(height: 14),
          _SummaryLine(label: 'Subtotal', value: subtotal),
          _SummaryLine(label: 'TAX (2%)', value: -1.08 + tax),
          const Divider(height: 24),
          _SummaryLine(label: 'Total', value: total, bold: true),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sell_outlined),
            label: const Text('Apply Promotion Code    2 Promos'),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: FilledButton(
          onPressed: () {},
          child: const Text('CHECKOUT'),
        ),
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({required this.p, required this.qty, required this.onInc, required this.onDec});
  final Product p;
  final int qty;
  final VoidCallback onInc, onDec;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            p.img,
            width: 62,
            height: 62,
            fit: BoxFit.cover,
            loadingBuilder: (c, child, progress) =>
                progress == null ? child : const _ImgPlaceholder(),
            errorBuilder: (c, e, s) => const _ImgBroken(),
          ),
        ),
        title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(p.tag),
        trailing: SizedBox(
          width: 130,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _QtyBtn(icon: Icons.remove, onTap: onDec),
              Text('$qty', style: const TextStyle(fontWeight: FontWeight.w800)),
              _QtyBtn(icon: Icons.add, onTap: onInc),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value, this.bold = false});
  final String label;
  final double value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(label,
            style: bold
                ? t.titleMedium!.copyWith(fontWeight: FontWeight.w800)
                : t.bodyMedium),
        const Spacer(),
        Text('\$${value.toStringAsFixed(2)}',
            style: bold
                ? t.titleMedium!.copyWith(fontWeight: FontWeight.w900)
                : t.bodyMedium),
      ],
    );
  }
}

// FAVORITES
class FavoritesPage extends StatelessWidget {
  const FavoritesPage(
      {super.key,
      required this.fav,
      required this.onFav,
      required this.onAdd,
      required this.onOpenDetail});
  final Set<String> fav;
  final void Function(Product) onFav;
  final void Function(Product) onAdd;
  final void Function(Product) onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final items = kProducts.where((p) => fav.contains(p.id)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite')),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .72),
        itemCount: items.length,
        itemBuilder: (_, i) => _ProductCard(
          p: items[i],
          inFav: true,
          onFav: () => onFav(items[i]),
          onAdd: () => onAdd(items[i]),
          onOpen: () => onOpenDetail(items[i]),
        ),
      ),
    );
  }
}

// PROFILE
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onOpenOrders});
  final VoidCallback onOpenOrders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), leading: const SizedBox()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: const [
          _UserHeader(),
          SizedBox(height: 12),
          _MenuTile(icon: Icons.receipt_long_rounded, text: 'My Orders'),
          _MenuTile(icon: Icons.account_balance_wallet_rounded, text: 'Payments & Wallet'),
          _MenuTile(icon: Icons.reviews_rounded, text: 'Ratings & Review'),
          _MenuTile(
            icon: Icons.notifications_active_rounded,
            text: 'Notification',
            trailing: _Badge(number: 1),
          ),
          _MenuTile(icon: Icons.location_on_rounded, text: 'Delivery Address'),
          _MenuTile(icon: Icons.article_rounded, text: 'Blog & Blog Detail'),
          SizedBox(height: 6),
          _MenuTile(icon: Icons.logout_rounded, text: 'LogOut', isDestructive: true),
        ],
      ),
    );
  }
}

/* ============================ WIDGET KECIL ============================ */
class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.hint});
  final String hint;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_rounded),
        hintText: hint,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/120?img=12'),
            backgroundColor: cs.primaryContainer,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text.rich(TextSpan(
              text: 'Good Morning 👋\n',
              style: TextStyle(fontWeight: FontWeight.w600),
              children: [TextSpan(text: 'Louis A.', style: TextStyle(fontWeight: FontWeight.w800))],
            )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(children: [
              Icon(Icons.star_rounded, color: cs.primary, size: 18),
              const SizedBox(width: 6),
              const Text('6'),
            ]),
          ),
        ],
      ),
    );
  }
}

/* ===================== PROMO BANNER CAROUSEL ===================== */
class _PromoBannerCarousel extends StatefulWidget {
  const _PromoBannerCarousel({
    required this.images,
    required this.title,
    required this.caption,
    required this.onTap,
  });

  final List<String> images;
  final String title;
  final String caption;
  final VoidCallback onTap;

  @override
  State<_PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<_PromoBannerCarousel> {
  final _pc = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 8.5,
              child: PageView.builder(
                controller: _pc,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: widget.images.length,
                itemBuilder: (_, i) => _BannerImage(url: widget.images[i]),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(.45), Colors.transparent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          height: 1.05)),
                  const SizedBox(height: 4),
                  Text(widget.caption, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: Row(
                children: List.generate(widget.images.length, (i) {
                  final active = i == _index;
                  return Container(
                    width: active ? 10 : 8,
                    height: active ? 10 : 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white54,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: widget.onTap),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => const _ImgBroken(),
      loadingBuilder: (ctx, child, progress) =>
          progress == null ? child : const _ImgPlaceholder(),
    );
  }
}

/* ============================ PRODUCT CARD + HELPERS ============================ */
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      trailing: trailing,
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.item});
  final (String, IconData, Color) item;

  @override
  Widget build(BuildContext context) {
    final (name, icon, color) = item;
    return Container(
      width: 132,
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [color.withOpacity(.22), color.withOpacity(.08)]),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const Spacer(),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
          const Text('45 Items', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.p,
    required this.inFav,
    required this.onFav,
    required this.onAdd,
    required this.onOpen,
  });
  final Product p;
  final bool inFav;
  final VoidCallback onFav, onAdd, onOpen;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen,
        child: Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 11,
                  child: Image.network(
                    p.img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (c, e, s) => const _ImgBroken(),
                    loadingBuilder: (c, child, progress) =>
                        progress == null ? child : const _ImgPlaceholder(),
                  ),
                ),
                const Positioned(left: 8, top: 8, child: _SaleBadge(text: '5% OFF')),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: onFav,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(
                        inFav ? Icons.favorite : Icons.favorite_border,
                        color: cs.primary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text('\$ ${p.price}', style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(width: 6),
                      Text('\$ ${p.oldPrice}',
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Theme.of(context).textTheme.bodySmall!.color)),
                      const Spacer(),
                      const Icon(Icons.star, size: 16),
                      const SizedBox(width: 2),
                      const Text('(243)'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: FilledButton.tonal(
                      onPressed: onAdd,
                      child: const Text('Add to cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleBadge extends StatelessWidget {
  const _SaleBadge({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration:
          BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(6)),
      child: Text(text,
          style:
              TextStyle(color: cs.onPrimary, fontWeight: FontWeight.w800, fontSize: 11)),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [Colors.green.shade800, Colors.green.shade400]),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: const [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5')),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'James Hawkins\njameshawkins@mail.com\n8854760544',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile(
      {required this.icon, required this.text, this.trailing, this.isDestructive = false, this.onTap});
  final IconData icon;
  final String text;
  final Widget? trailing;
  final bool isDestructive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : Theme.of(context).colorScheme.primary;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(text,
            style:
                TextStyle(color: isDestructive ? Colors.red : null, fontWeight: FontWeight.w600)),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.number});
  final int number;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(999)),
      child: Text('$number',
          style: TextStyle(color: cs.onPrimary, fontWeight: FontWeight.w800)),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      style: IconButton.styleFrom(padding: const EdgeInsets.all(6)),
    );
    }
}

class _ImgPlaceholder extends StatelessWidget {
  const _ImgPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFECEFF1),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class _ImgBroken extends StatelessWidget {
  const _ImgBroken();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFCFD8DC),
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image_outlined, size: 40, color: Colors.white),
    );
  }
}

/* ============================ SIDE RAIL & QUICK PREVIEW ============================ */
class _SideRailButton extends StatelessWidget {
  const _SideRailButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
        ),
        child: RotatedBox(
          quarterTurns: 3,
          child:
              Text(label, style: TextStyle(color: cs.onPrimary, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}

class _QuickPreviewSheet extends StatelessWidget {
  const _QuickPreviewSheet();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        scrollDirection: Axis.horizontal,
        itemCount: kProducts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final p = kProducts[i];
          return SizedBox(
            width: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.network(
                      p.img,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const _ImgBroken(),
                      loadingBuilder: (c, child, progress) =>
                          progress == null ? child : const _ImgPlaceholder(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                Text('\$ ${p.price}', style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
          );
        },
      ),
    );
  }
}

/* ============================ PRODUCT DETAIL ============================ */
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.p, required this.onAdd});
  final Product p;
  final void Function(Product) onAdd;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 11,
              child: Image.network(
                p.img,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const _ImgBroken(),
                loadingBuilder: (c, child, progress) =>
                    progress == null ? child : const _ImgPlaceholder(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(p.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('\$ ${p.price}',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(width: 8),
              Text('\$ ${p.oldPrice}',
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Theme.of(context).textTheme.bodySmall!.color)),
              const Spacer(),
              const Icon(Icons.star, size: 18),
              const SizedBox(width: 4),
              const Text('4.8 (243)'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Fresh, hand-picked ${p.tag.toLowerCase()} with premium quality. Stored in cold chain to keep it crisp and tasty.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _QtyBtn(icon: Icons.remove, onTap: () => setState(() => qty = qty > 1 ? qty - 1 : 1)),
              Text('$qty', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              _QtyBtn(icon: Icons.add, onTap: () => setState(() => qty++)),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {
                  for (var i = 0; i < qty; i++) widget.onAdd(p);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Added to cart')));
                },
                icon: const Icon(Icons.shopping_bag_rounded),
                label: const Text('Add to cart'),
                style: FilledButton.styleFrom(
                    backgroundColor: cs.primary, foregroundColor: cs.onPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}