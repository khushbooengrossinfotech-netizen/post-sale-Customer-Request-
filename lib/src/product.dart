import 'package:flutter/material.dart';

enum ProductKind { headphones, chair, lamp, bag, bottle, speaker }

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.priceCents,
    required this.color,
    required this.kind,
    required this.description,
    required this.material,
    this.badge,
    this.rating = 4.8,
  });

  final String id;
  final String name;
  final String category;
  final int priceCents;
  final Color color;
  final ProductKind kind;
  final String description;
  final String material;
  final String? badge;
  final double rating;
}

String money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

const products = [
  Product(
    id: 'sound-01',
    name: 'Studio headphones',
    category: 'Tech',
    priceCents: 12900,
    color: Color(0xFFE9DDD1),
    kind: ProductKind.headphones,
    description:
        'Find your own quiet. Cushioned over-ear headphones with a balanced sound profile and a comfortable, adjustable fit.',
    material: 'Soft-touch finish · 30-hour battery',
    badge: 'BESTSELLER',
  ),
  Product(
    id: 'home-01',
    name: 'Arc lounge chair',
    category: 'Home',
    priceCents: 24900,
    color: Color(0xFFE4E8DD),
    kind: ProductKind.chair,
    description:
        'A little room to unwind. The Arc pairs a sculpted seat with warm wooden legs for a comfortable corner that feels like yours.',
    material: 'Upholstered seat · Solid oak legs',
    badge: 'NEW',
    rating: 4.9,
  ),
  Product(
    id: 'home-02',
    name: 'Halo table lamp',
    category: 'Home',
    priceCents: 7900,
    color: Color(0xFFF0E1D4),
    kind: ProductKind.lamp,
    description:
        'Make room for a softer glow. A compact, sculptural table lamp for slow evenings, bedside reading, and everyday warmth.',
    material: 'Powder-coated steel · Warm LED',
    rating: 4.7,
  ),
  Product(
    id: 'carry-01',
    name: 'Everyday tote',
    category: 'Accessories',
    priceCents: 4500,
    color: Color(0xFFE8E3D9),
    kind: ProductKind.bag,
    description:
        'Your daily essentials, all together. A spacious canvas tote with reinforced handles and an inside pocket for the little things.',
    material: 'Heavyweight cotton canvas · 18 L',
    badge: 'POPULAR',
  ),
  Product(
    id: 'carry-02',
    name: 'Trail water bottle',
    category: 'Accessories',
    priceCents: 3200,
    color: Color(0xFFDEE8E4),
    kind: ProductKind.bottle,
    description:
        'A fresh start, wherever you go. A reusable insulated bottle with a comfortable grip and a leak-resistant screw cap.',
    material: 'Stainless steel · 750 ml',
    rating: 4.9,
  ),
  Product(
    id: 'sound-02',
    name: 'Pocket speaker',
    category: 'Tech',
    priceCents: 5900,
    color: Color(0xFFE5E1E9),
    kind: ProductKind.speaker,
    description:
        'Good sound follows you. A small wireless speaker with a textured fabric finish, designed for your desk and your next day out.',
    material: 'Woven fabric · 12-hour battery',
    badge: 'NEW',
    rating: 4.6,
  ),
];
