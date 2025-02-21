class BagItem {
  final String id;
  final String watchName;
  final String imageUrl;
  final double price;
  int quantity;
  bool isSelected = false;

  BagItem({
    required this.id,
    required this.watchName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.isSelected = false,
  });
}