import 'package:flutter/material.dart';

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
    final orders = _mockOrders
        .where((o) => statusFilter == null || o.status == statusFilter)
        .toList();
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
            Row(
              children: [
                Icon(Icons.local_shipping_rounded, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  'Order ID ${data.id}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                Text(
                  data.status,
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < data.steps.length; i++)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    i <= 2 ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: i <= 2
                        ? cs.primary
                        : Theme.of(context).textTheme.bodySmall!.color,
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
