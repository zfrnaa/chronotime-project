// lib/data/watch_data.dart

import '../models/watch_item.dart';

final List<WatchItem> watchList = [
  WatchItem(
    id: '1',
    name: 'Suunto 5',
    imageUrl: 'assets/suunto1.jpeg',
    price: 1499.00,
    description:
        'The Suunto 5 is a compact GPS sports watch with great battery life. It has a long battery life made for your daily sports and adventures. The watch is designed to be your trusted training partner. It guides you with versatile sports features, 24/7 activity tracking, and stress and recovery insights. It has a compact design with a battery life of up to 40 hours with GPS. The watch is water-resistant up to 50 meters and has a wrist heart rate measurement.',
        features: [
          'Compact GPS sports watch',
          'Great battery life',
          'Versatile sports features',
          '24/7 activity tracking',
          'Stress and recovery insights',
          'Battery life of up to 40 hours with GPS',
          'Water-resistant up to 50 meters',
          'Wrist heart rate measurement',
        ],
        warrantyYears: 2,
  ),
  WatchItem(
    id: '2',
    name: 'Audemars Royal Oak',
    imageUrl: 'assets/audemarsroyaloak.png',
    price: 2199.00,
    description:
        'The Audemars Piguet Royal Oak is a luxury watch that is known for its octagonal bezel, exposed screws, and integrated bracelet. The watch is made of stainless steel and has a blue dial with a date window. The watch has a self-winding automatic movement and a power reserve of 60 hours. The watch is water-resistant up to 50 meters and has a sapphire crystal.',
        features: [
          'Luxury watch',
          'Octagonal bezel',
          'Exposed screws',
          'Integrated bracelet',
          'Stainless steel',
          'Blue dial with date window',
          'Self-winding automatic movement',
          'Power reserve of 60 hours',
          'Water-resistant up to 50 meters',
          'Sapphire crystal',
        ],
        warrantyYears: 5,
  ),
  WatchItem(
    id: '3',
    name: 'Rhythm F15',
    imageUrl: 'assets/rhythm1.jpg',
    price: 799.00,
    description:
        'The Rhythm F15 is a smartwatch that is designed for fitness enthusiasts. The watch has a heart rate monitor, sleep tracker, and pedometer. It has a long battery life and is water-resistant up to 50 meters. The watch has a color display and is compatible with both Android and iOS devices. The watch has a sleek design and is made of durable materials.',
        features: [
          'Watch for women',
          'Water-resistant up to 50 meters',
          'Sleek design',
          'Durable materials',
        ],
        warrantyYears: 1,
  ),
  WatchItem(
    id: '4',
    name: 'Daniel Wellington Classic Black',
    imageUrl: 'assets/dw1.jpeg',
    price: 699.00,
    description: 'The Daniel Wellington Classic Black Elegance watch combines timeless design with modern functionality. Featuring a sleek black dial, genuine leather strap, and reliable quartz movement, this watch is perfect for both casual and formal occasions.',
    features: [
      'Minimalist Design',
      'Water Resistant up to 30m',
      'Quarterly Changing Strap',
      'Sapphire Crystal',
    ],
    warrantyYears: 2,
  ),
  WatchItem(
    id: '5',
    name: 'Tissot T-Classic Everytime',
    imageUrl: 'assets/tissot1.jpg',
    price: 999.00,
    description: 'The Tissot T-Classic Everytime combines elegance with practicality. Featuring a stainless steel case, sapphire crystal, and reliable quartz movement, this watch is perfect for everyday wear.',
    features: [
      'Water Resistant up to 100m',
      'Quartz Movement',
      'Sapphire Crystal',
    ],
    warrantyYears: 2,
  ),
  // Add more watch items as needed
];
