import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/common_widgets.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  final Map<String, int> cart;
  final Set<String> fav;
  final Function(dynamic) onAdd;
  final Function(dynamic) onFav;
  final Function(dynamic) onOpenDetail;

  const CategoryPage({
    required this.category,
    required this.cart,
    required this.fav,
    required this.onAdd,
    required this.onFav,
    required this.onOpenDetail,
    super.key,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final products = getProductsByCategory(widget.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        elevation: 0,
        backgroundColor: cs.background,
        foregroundColor: cs.onBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            const SearchBox(hint: 'Search beverages or foods'),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (ctx, i) {
                  final p = products[i];
                  final inFav = widget.fav.contains(p.id);
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        p.img,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const ImgBroken(),
                        loadingBuilder: (c, child, progress) =>
                            progress == null ? child : const ImgPlaceholder(),
                      ),
                    ),
                    title: Text(p.name),
                    subtitle: Text(
                      '\$ ${p.price}  \$${p.oldPrice}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            inFav ? Icons.favorite : Icons.favorite_border,
                            color: inFav ? Colors.green : null,
                          ),
                          onPressed: () {
                            widget.onFav(p);
                            setState(() {}); // Trigger rebuild to update icon
                          },
                        ),
                        FilledButton(
                          onPressed: () {
                            widget.onAdd(p);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${p.name} added to cart'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                width: 200,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          child: const Icon(Icons.shopping_cart),
                        ),
                      ],
                    ),
                    onTap: () => widget.onOpenDetail(p),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
