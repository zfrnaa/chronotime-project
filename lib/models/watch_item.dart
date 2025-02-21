class WatchItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final List<String> features;
  final int warrantyYears;

  WatchItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.features,
    required this.warrantyYears,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
      'features': features.join(','), // Convert list to comma-separated string
      'warrantyYears': warrantyYears,
    };
  }

  factory WatchItem.fromMap(Map<String, dynamic> map) {
    return WatchItem(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      description: map['description'],
      features: map['features'].split(','), // Convert comma-separated string to list
      warrantyYears: map['warrantyYears'],
    );
  }
}