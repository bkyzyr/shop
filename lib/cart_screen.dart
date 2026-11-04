import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('All books will be removed from the cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) {
      return;
    }
    context.read<Cart>().clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            tooltip: 'Clear cart',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmClear(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<Cart>(
              builder: (context, cart, _) {
                if (cart.count == 0) {
                  return const Center(child: Text('The cart is empty'));
                }
                return ListView(
                  children: [
                    for (final b in cart.items)
                      ListTile(
                        title: Text(b.title),
                        subtitle: Text('${b.price} ₸ · ×${cart.qtyOf(b)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => cart.increment(b),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => cart.remove(b),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Consumer<Cart>(
              builder: (context, cart, child) => Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    child!,
                    const Spacer(),
                    Text(
                      '${cart.total} ₸',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.payments_outlined),
                  SizedBox(width: 8),
                  Text('Total'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
