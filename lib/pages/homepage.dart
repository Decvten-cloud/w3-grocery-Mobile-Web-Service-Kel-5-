import 'package:flutter/material.dart';
import '../models/product.dart';
import 'category_page.dart';
import '../widgets/common_widgets.dart';

class HomePage extends StatefulWidget {
  final Map<String, int> cart;
  final Set<String> fav;
  final Function(dynamic) onAdd;
  final Function(dynamic) onFav;
  final Function(dynamic) onOpenDetail;

  const HomePage({
    super.key,
    required this.cart,
    required this.fav,
    required this.onAdd,
    required this.onFav,
    required this.onOpenDetail,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;

  List<Product> get filteredProducts {
    // When no category selected, show a curated "popular" list on homepage
    if (selectedCategory == null) return getProductsByIds(kPopularProductIds);
    return getProductsByCategory(selectedCategory!);
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = selectedCategory == category ? null : category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final promos = kPromoImages;

    return Scaffold(
      appBar: null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          // Search + user avatar row
          Row(
            children: [
              Expanded(child: SearchBox(hint: 'Search for products')),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 22,
                backgroundImage: const NetworkImage(
                  'https://i.pravatar.cc/150?img=5',
                ),
                backgroundColor: cs.primaryContainer,
                onBackgroundImageError: (_, __) {},
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Promo carousel
          AspectRatio(
            aspectRatio: 16 / 7,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.92),
              itemCount: promos.length,
              itemBuilder: (ctx, i) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  promos[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ImgBroken(),
                  loadingBuilder: (c, child, progress) =>
                      progress == null ? child : const ImgPlaceholder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Categories
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final category = kCategories[i];
                final name = category.$1;
                final icon = category.$2;
                final color = category.$3;
                final items = category.$4;
                final isSelected = selectedCategory == name;
                return GestureDetector(
                  onTap: () {
                    // Navigate to a dedicated category page showing full list
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CategoryPage(
                          category: name,
                          cart: widget.cart,
                          fav: widget.fav,
                          onAdd: widget.onAdd,
                          onFav: widget.onFav,
                          onOpenDetail: widget.onOpenDetail,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isSelected
                              ? color.withOpacity(.3)
                              : color.withOpacity(.22),
                          isSelected
                              ? color.withOpacity(.15)
                              : color.withOpacity(.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: isSelected
                          ? Border.all(color: color.withOpacity(.5), width: 2)
                          : null,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, color: color),
                        const Spacer(),
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.w900
                                : FontWeight.w800,
                          ),
                        ),
                        Text(
                          items,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? cs.primary
                                : cs.onSurface.withOpacity(.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),

          // Products grid with filtering
          Row(
            children: [
              Text(
                selectedCategory ?? 'Favourie Products',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 8),
              Text(
                '(${filteredProducts.length} items)',
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withOpacity(.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: .72,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (_, i) {
              final p = filteredProducts[i];
              return ProductCard(
                p: p,
                inFav: widget.fav.contains(p.id),
                onFav: () => widget.onFav(p),
                onAdd: () => widget.onAdd(p),
                onOpen: () => widget.onOpenDetail(p),
              );
            },
          ),
        ],
      ),
    );
  }
}
