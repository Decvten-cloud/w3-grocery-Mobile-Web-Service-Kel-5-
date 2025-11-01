import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/common_widgets.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
    required this.fav,
    required this.onFav,
    required this.onAdd,
    required this.onOpenDetail,
  });

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
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: .72,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) => ProductCard(
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
