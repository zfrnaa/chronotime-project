import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/bag_provider.dart';

class OrderConfirmation extends StatelessWidget {
  const OrderConfirmation({super.key});

  @override
  Widget build(BuildContext context) {

  return Scaffold(
    body: Center(
    child: AlertDialog(
      title: const Text('Order Placed'),
      icon: const Icon(Icons.check_circle, color: Colors.green),
      content: const Text('Your order has been placed successfully!'),
      actions: [
      TextButton(
        onPressed: () {
          // Clear the bag
        Provider.of<BagProvider>(context, listen: false).clearCart();

          Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, '/home');
        },
        child: const Text('OK'),
      ),
      ],
    ),
    ),
  );
  }
}