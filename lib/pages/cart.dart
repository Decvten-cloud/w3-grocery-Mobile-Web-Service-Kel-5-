import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/common_widgets.dart';

class CartPage extends StatelessWidget {
  const CartPage({
    super.key,
    required this.cart,
    required this.onAdd,
    required this.onRemove,
  });
  final Map<String, int> cart;
  final void Function(Product) onAdd;
  final void Function(Product) onRemove;

  @override
  Widget build(BuildContext context) {
    final items = kProducts
        .where((p) => cart[p.id] != null && cart[p.id]! > 0)
        .toList();
    final subtotal = items.fold<double>(
      0,
      (s, p) => s + p.price * cart[p.id]!.toDouble(),
    );
    final tax = subtotal * 0.02;
    final total = subtotal - 1.08 + tax;

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
        child: FilledButton(onPressed: () {}, child: const Text('CHECKOUT')),
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({
    required this.p,
    required this.qty,
    required this.onInc,
    required this.onDec,
  });
  final Product p;
  final int qty;
  final VoidCallback onInc, onDec;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: SizedBox(
          width: 62,
          height: 62,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              p.img,
              width: 62,
              height: 62,
              fit: BoxFit.cover,
              loadingBuilder: (c, child, progress) =>
                  progress == null ? child : const ImgPlaceholder(),
              errorBuilder: (c, e, s) => const ImgBroken(),
            ),
          ),
        ),
        title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(p.tag),
        trailing: SizedBox(
          width: 130,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              QtyBtn(icon: Icons.remove, onTap: onDec),
              Text('$qty', style: const TextStyle(fontWeight: FontWeight.w800)),
              QtyBtn(icon: Icons.add, onTap: onInc),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.bold = false,
  });
  final String label;
  final double value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          label,
          style: bold
              ? t.titleMedium!.copyWith(fontWeight: FontWeight.w800)
              : t.bodyMedium,
        ),
        const Spacer(),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: bold
              ? t.titleMedium!.copyWith(fontWeight: FontWeight.w900)
              : t.bodyMedium,
        ),
      ],
    );
  }
}
