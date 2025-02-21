import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
import '../models/bag_item.dart';
import '../provider/bag_provider.dart';
import '../core/checkout_page.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  // Optional: For testing purposes, you can add items using this method
  /*void _addSampleItems() {
    final bagProvider = Provider.of<BagProvider>(context, listen: false);
    bagProvider.addItem(
      BagItem(
        id: '3',
        watchName: 'Rolex Submariner',
        imageUrl: 'assets/rolex_submariner.jpg',
        price: 12000.00,
        quantity: 1,
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    final bagProvider = Provider.of<BagProvider>(context);
    final bagItems = bagProvider.bagItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bag'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff004CFF)),
        elevation: 0,
        actions: [
          // Optional: Add a button to add sample items for testing
          /*IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSampleItems,
            tooltip: 'Add Sample Item',
          ),*/
        ],
      ),
      body: bagItems.isEmpty ? _buildEmptyBag() : _buildBagList(bagItems),
      bottomNavigationBar:
          bagItems.isEmpty ? null : _buildCheckoutSection(bagProvider),
    );
  }

  Widget _buildEmptyBag() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'Your bag is empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start adding watches to your bag now.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF156BC1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Shop Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBagList(List<BagItem> bagItems) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
      child: ListView.builder(
        itemCount: bagItems.length,
        itemBuilder: (context, index) {
          return _buildBagItem(bagItems[index]);
        },
      ),
    );
  }

  Widget _buildBagItem(BagItem item) {
    final bagProvider = Provider.of<BagProvider>(context, listen: false);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Checkbox(
              value: item.isSelected,
              onChanged: (value) {
                bagProvider.toggleItemSelection(item.id, value ?? false);
              },
            ),
            // Watch Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: AssetImage(item.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Watch Details
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
                    'RM${item.price.toString()}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff004CFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Quantity Selector
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => bagProvider.decreaseQuantity(item.id),
                      ),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => bagProvider.increaseQuantity(item.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Remove Button
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => bagProvider.removeItem(item.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(BagProvider bagProvider) {
    final selectedItems =
        bagProvider.bagItems.where((item) => item.isSelected).toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'RM${selectedItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff004CFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Pass bag items to checkout
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutPage(),
                      settings: RouteSettings(arguments: selectedItems),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff004CFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // String _formatPrice(double price) {
  //   final NumberFormat formatter = NumberFormat.simpleCurrency();
  //   return formatter.format(price);
  // }
}
