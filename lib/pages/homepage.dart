import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/common_widgets.dart';

class HomePage extends StatelessWidget {
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
                final (name, icon, color) = kCategories[i];
                return Container(
                  width: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(.22), color.withOpacity(.08)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: color),
                      const Spacer(),
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const Text('45 Items', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),

          // Popular products grid
          const Text('Popular', style: TextStyle(fontWeight: FontWeight.w800)),
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
            itemCount: kProducts.length,
            itemBuilder: (_, i) {
              final p = kProducts[i];
              return ProductCard(
                p: p,
                inFav: fav.contains(p.id),
                onFav: () => onFav(p),
                onAdd: () => onAdd(p),
                onOpen: () => onOpenDetail(p),
              );
            },
          ),
        ],
      ),
    );
  }
}
