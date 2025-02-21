import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../helper/order_database_helper.dart';
import '../models/bag_item.dart';
import '../models/order_item.dart'; // Update import
import '../provider/order_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String name = "Adam Razman";
  String phoneNumber = "+0161234534";
  String address1 = "123 Main Street";
  String address2 = "Kuala Lumpur, Malaysia";

  @override
  Widget build(BuildContext context) {
    final List<BagItem> bagItems =
        ModalRoute.of(context)!.settings.arguments as List<BagItem>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildShippingInfo(context),
            _buildOrderSummary(bagItems),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _processStripePayment(context, bagItems),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Pay Now with Stripe',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shipping Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(name),
                Text(phoneNumber),
                Text(address1),
                Text(address2),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _showEditShippingInfoOverlay(context),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(60, 60),
                backgroundColor: const Color(0xFF156BC1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(List<BagItem> bagItems) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...bagItems.map((item) => _buildCheckoutItem(item)),
            ListTile(
              title: const Text('Bag Item'),
              trailing: Text(bagItems
                  .fold(0.0, (sum, item) => sum + item.price)
                  .toStringAsFixed(2)),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:'),
                Text(
                  'RM${bagItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff004CFF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutItem(BagItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
              image: DecorationImage(
                image: item.imageUrl.startsWith('http') ||
                        item.imageUrl.startsWith('https')
                    ? NetworkImage(item.imageUrl)
                    : AssetImage(item.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.watchName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'RM${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff004CFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Quantity: ${item.quantity}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _processStripePayment(
      BuildContext context, List<BagItem> bagItems) async {
    try {
      final double totalAmount =
          bagItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

      final String baseUrl = 'http://192.168.68.121:3000';

      final response = await http.post(
        Uri.parse('$baseUrl/create-payment-intent'),
        body: {
          'amount': (totalAmount * 100).toInt().toString(),
          'currency': 'myr',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create payment intent');
      }

      final paymentIntentData = json.decode(response.body);
      final clientSecret = paymentIntentData['clientSecret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Watch Store',
          allowsDelayedPaymentMethods: true,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      if (!context.mounted) return;

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString().substring(8, 13),
        items: bagItems,
        watchName: bagItems.map((item) => item.watchName).join(', '),
        imageUrl: bagItems.first.imageUrl,
        totalPrice: totalAmount,
        orderDate: DateTime.now(),
        quantity: bagItems.map((item) => item.quantity).join(', '),
        status: 'Processing',
        estimatedDelivery:
            DateTime.now().add(Duration(days: 2 + (Random().nextInt(9)))),
      );

      // Add order to provider
      Provider.of<OrderProvider>(context, listen: false).addOrder(order);

      // Save order to database
      await OrderDatabaseHelper().insertOrder(order);

      // Navigate to OrderConfirmation page and then to home
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/order_confirmation')
            .then((_) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Successful! Order has been placed.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showEditShippingInfoOverlay(BuildContext context) async {
    String updatedName = name;
    String updatedPhoneNumber = phoneNumber;
    String updatedAddress1 = address1;
    String updatedAddress2 = address2;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                controller: TextEditingController(text: updatedName),
                onChanged: (value) => updatedName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                controller: TextEditingController(text: updatedPhoneNumber),
                onChanged: (value) => updatedPhoneNumber = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Address Line 1'),
                controller: TextEditingController(text: updatedAddress1),
                onChanged: (value) => updatedAddress1 = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Address Line 2'),
                controller: TextEditingController(text: updatedAddress2),
                onChanged: (value) => updatedAddress2 = value,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    name = updatedName;
                    phoneNumber = updatedPhoneNumber;
                    address1 = updatedAddress1;
                    address2 = updatedAddress2;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}
