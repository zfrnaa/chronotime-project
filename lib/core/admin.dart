import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../helper/order_database_helper.dart';
import '../helper/watch_database_helper.dart';
import '../models/order_item.dart';
import '../models/watch_item.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final GlobalKey<_AdminPageState> myWidgetKey = GlobalKey();
  // Form controllers
  final _addFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();
  final _watchNameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _featuresController = TextEditingController();
  final _warrantyYearsController = TextEditingController();

  // Data
  List<WatchItem> _watchList = [];
  WatchItem? _editingWatchItem;
  List<Order> orders = [];
  final OrderDatabaseHelper _databaseHelper = OrderDatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadWatchItems();
    _loadOrders();
  }

  Future<void> _loadWatchItems() async {
    final items = await WatchDatabaseHelper().watchItems();
    setState(() {
      _watchList = items;
    });
  }

  Future<void> _loadOrders() async {
    final loadedOrders = await _databaseHelper.orders();
    setState(() {
      orders = loadedOrders;
    });
  }

  void _editWatchItem(WatchItem watch) {
    setState(() {
      _editingWatchItem = watch;
      _watchNameController.text = watch.name;
      _imageUrlController.text = watch.imageUrl;
      _priceController.text = watch.price.toString();
      _descriptionController.text = watch.description;
      _featuresController.text = watch.features.join(',');
      _warrantyYearsController.text = watch.warrantyYears.toString();
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Watch'),
        content: SingleChildScrollView(
          child: Form(
            key: _editFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageUrlController.text.isNotEmpty
                      ? _imageUrlController.text.startsWith('http') ||
                              _imageUrlController.text.startsWith('https')
                          ? Image.network(_imageUrlController.text,
                              fit: BoxFit.cover)
                          : _imageUrlController.text.startsWith('assets')
                              ? Image.asset(_imageUrlController.text,
                                  fit: BoxFit.cover)
                              : Image.file(File(_imageUrlController.text),
                                  fit: BoxFit.cover)
                      : const Icon(Icons.image),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Image Source',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'url', child: Text('URL')),
                    DropdownMenuItem(
                        value: 'assets', child: Text('Asset Path')),
                    DropdownMenuItem(value: 'gallery', child: Text('Gallery')),
                  ],
                  onChanged: (value) async {
                    if (value == null) return;
                    String? imagePath;

                    switch (value) {
                      case 'url':
                        final controller = TextEditingController();
                        imagePath = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Enter Image URL'),
                            content: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                hintText: 'https://example.com/image.jpg',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, controller.text),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        break;

                      case 'assets':
                        final controller = TextEditingController();
                        imagePath = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Enter Asset Path'),
                            content: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                hintText: 'watches/watch1.jpg',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(
                                    context, 'assets/${controller.text}'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        break;

                      case 'gallery':
                        final picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imagePath = image.path;
                        }
                        break;
                    }

                    if (imagePath != null) {
                      setState(() {
                        _imageUrlController.text = imagePath!;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // ... rest of your form fields ...
                TextFormField(
                  controller: _watchNameController,
                  decoration: const InputDecoration(
                    labelText: 'Watch Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter watch name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => double.tryParse(value ?? '') == null
                      ? 'Please enter valid price'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter description'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _featuresController,
                  decoration: const InputDecoration(
                    labelText: 'Features (comma separated)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter features' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _warrantyYearsController,
                  decoration: const InputDecoration(
                    labelText: 'Warranty Years',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => int.tryParse(value ?? '') == null
                      ? 'Invalid number'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff004CFF),
            ),
            onPressed: () async {
              if (_editFormKey.currentState?.validate() ?? false) {
                await _updateWatchItem();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(WatchItem watch) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${watch.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () async {
              await WatchDatabaseHelper().deleteWatchItem(watch.id);
              await _loadWatchItems();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Watch deleted successfully')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: order.status,
                  items: <String>['Processing', 'Shipped', 'Delivered']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) async {
                    if (newValue != null) {
                      try {
                        await _databaseHelper.updateOrderStatus(
                            order.id, newValue);
                        setState(() {
                          order.status = newValue;
                        });
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Order status updated successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to update order status'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: order.imageUrl.startsWith('http') ||
                              order.imageUrl.startsWith('https')
                          ? NetworkImage(order.imageUrl)
                          : AssetImage(order.imageUrl) as ImageProvider,
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
                        order.watchName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('Quantity: ${order.quantity}'),
                      const SizedBox(height: 8),
                      Text(
                        'RM${order.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff004CFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                  'Order Date',
                  DateFormat('MMM dd, yyyy').format(order.orderDate),
                ),
                _buildInfoColumn(
                  'Status',
                  order.status,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: GoogleFonts.ibmPlexMono().fontFamily,
          textTheme: GoogleFonts.ibmPlexMonoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Admin Panel'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed('/login'),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Watch Item',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _addFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _watchNameController,
                          decoration: const InputDecoration(
                            labelText: 'Watch Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter watch name'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _imageUrlController.text.isNotEmpty
                                  ? _imageUrlController.text.startsWith('http') ||
                                          _imageUrlController.text
                                              .startsWith('https')
                                      ? Image.network(_imageUrlController.text,
                                          fit: BoxFit.cover)
                                      : _imageUrlController.text
                                              .startsWith('assets')
                                          ? Image.asset(
                                              _imageUrlController.text,
                                              fit: BoxFit.cover)
                                          : Image.file(
                                              File(_imageUrlController.text),
                                              fit: BoxFit.cover)
                                  : const Icon(Icons.photo_camera,
                                      size: 40),
                            ),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Select Image Source',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  _imageUrlController.text.isEmpty
                                      ? 'Please select an image'
                                      : null,
                              items: const [
                                DropdownMenuItem(
                                    value: 'url', child: Text('URL')),
                                DropdownMenuItem(
                                    value: 'assets', child: Text('Asset Path')),
                                DropdownMenuItem(
                                    value: 'gallery', child: Text('Gallery')),
                              ],
                              onChanged: (value) async {
                                if (value == null) return;
                                String? imagePath;

                                switch (value) {
                                  case 'url':
                                    final urlController =
                                        TextEditingController();
                                    imagePath = await showDialog<String>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Enter Image URL'),
                                        content: TextField(
                                          controller: urlController,
                                          decoration: const InputDecoration(
                                            hintText:
                                                'https://example.com/image.jpg',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, urlController.text),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    break;

                                  case 'assets':
                                    imagePath = await showDialog<String>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Enter Asset Path'),
                                        content: TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'watches/watch1.jpg',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              final controller =
                                                  TextEditingController();
                                              Navigator.pop(context,
                                                  'assets/${controller.text}');
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    break;

                                  case 'gallery':
                                    final picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery,
                                    );
                                    if (image != null) {
                                      imagePath = image.path;
                                    }
                                    break;
                                }

                                if (imagePath != null) {
                                  setState(() {
                                    _imageUrlController.text = imagePath!;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              double.tryParse(value ?? '') == null
                                  ? 'Please enter valid price'
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter description'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _featuresController,
                          decoration: const InputDecoration(
                            labelText: 'Features (comma separated)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter features'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _warrantyYearsController,
                          decoration: const InputDecoration(
                            labelText: 'Warranty Years',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              int.tryParse(value ?? '') == null
                                  ? 'Invalid number'
                                  : null,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            if (_addFormKey.currentState?.validate() ?? false) {
                              await _saveNewWatch();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff004CFF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 134,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Add Watch Item',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Edit Watch Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _watchList.length,
                    itemBuilder: (context, index) {
                      final watch = _watchList[index];
                      return Card(
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                  image: DecorationImage(
                                    image: watch.imageUrl.startsWith('http') ||
                                            watch.imageUrl.startsWith('https')
                                        ? NetworkImage(watch.imageUrl)
                                        : watch.imageUrl.startsWith('assets')
                                            ? AssetImage(watch.imageUrl)
                                                as ImageProvider
                                            : FileImage(File(watch.imageUrl)),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    watch.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text('RM${watch.price}'),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _editWatchItem(watch),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () => _confirmDelete(watch),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Manage Order Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  orders.isEmpty
                      ? const Center(child: Text('No orders yet'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return _buildOrderCard(order);
                          },
                        ),
                ],
              ),
            ),
          );
        }));
  }

  Future<void> _updateWatchItem() async {
    if (_editingWatchItem != null) {
      try {
        final updatedWatch = WatchItem(
          id: _editingWatchItem!.id,
          name: _watchNameController.text,
          imageUrl: _imageUrlController.text,
          price: double.parse(_priceController.text),
          description: _descriptionController.text,
          features: _featuresController.text.split(','),
          warrantyYears: int.parse(_warrantyYearsController.text),
        );

        await WatchDatabaseHelper().updateWatchItem(updatedWatch);
        await _loadWatchItems();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Watch updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update watch: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _saveNewWatch() async {
    final newWatch = WatchItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _watchNameController.text,
      imageUrl: _imageUrlController.text,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      features: _featuresController.text.split(','),
      warrantyYears: int.parse(_warrantyYearsController.text),
    );

    await WatchDatabaseHelper().insertWatchItem(newWatch);
    await _loadWatchItems();
    if (mounted) {
      _addFormKey.currentState?.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Watch added successfully')),
      );
    }
  }
}
