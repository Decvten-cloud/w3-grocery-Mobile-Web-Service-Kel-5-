import 'package:flutter/material.dart';

class Product {
  final String id, name, img, tag;
  final double price, oldPrice;
  const Product(
    this.id,
    this.name,
    this.img,
    this.price,
    this.oldPrice,
    this.tag,
  );
}

const kPromoImages = [
  'https://images.unsplash.com/photo-1586201375754-1421e0aa2f63?auto=format&fit=crop&w=1600&q=80',
  'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?auto=format&fit=crop&w=1600&q=80',
  'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=1600&q=80',
];

const kProducts = <Product>[
  Product(
    'p1',
    'Fresh Grapes',
    'https://images.unsplash.com/photo-1519996529931-28324d5a630e?auto=format&fit=crop&w=1200&q=80',
    10.9,
    12.9,
    'Fruits',
  ),
  Product(
    'p2',
    'Gurame Fish',
    'https://images.unsplash.com/photo-1603064752734-4b7aef0b0b0d?auto=format&fit=crop&w=1200&q=80',
    10.9,
    12.0,
    'Fish',
  ),
  Product(
    'p3',
    'Tomatoes',
    'https://images.unsplash.com/photo-1542838038-3b3b4f31c2c3?auto=format&fit=crop&w=1200&q=80',
    10.9,
    12.0,
    'Vegetables',
  ),
  Product(
    'p4',
    'Chicken Village',
    'https://images.unsplash.com/photo-1609137144813-7d99208993a1?auto=format&fit=crop&w=1200&q=80',
    10.9,
    11.9,
    'Meat',
  ),
  Product(
    'p5',
    'Sweet Young Coconut',
    'https://images.unsplash.com/photo-1586201375754-1421e0aa2f63?auto=format&fit=crop&w=1200&q=80',
    4.0,
    8.9,
    'Fruits',
  ),
  Product(
    'p6',
    'Fresh Spinach',
    'https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=1200&q=80',
    7.2,
    8.9,
    'Vegetables',
  ),
  Product(
    'p7',
    'Chocolate Chips',
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=1200&q=80',
    12.0,
    12.0,
    'Bakery',
  ),
];

const kCategories = <(String, IconData, Color)>[
  ('Fruits', Icons.apple_rounded, Color(0xFF34D399)),
  ('Fish', Icons.set_meal_rounded, Color(0xFF60A5FA)),
  ('Chicken', Icons.lunch_dining_rounded, Color(0xFFF472B6)),
  ('Pizza', Icons.local_pizza_rounded, Color(0xFFFFA34D)),
  ('Drinks', Icons.local_drink_rounded, Color(0xFF38BDF8)),
];
