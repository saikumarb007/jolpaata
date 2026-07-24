import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Color;

/// A lullaby category from catalogue.json (Annamacharya, Ramadasu, Folk, …).
class Category extends Equatable {
  const Category({
    required this.id,
    required this.label,
    required this.labelTelugu,
    required this.color,
  });

  final String id;
  final String label;
  final String labelTelugu;
  final Color color;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        label: json['label'] as String? ?? '',
        labelTelugu: json['label_telugu'] as String? ?? '',
        color: _hex(json['color'] as String?),
      );

  static Color _hex(String? s) {
    if (s == null || !s.startsWith('#')) return const Color(0xFF888888);
    return Color(int.parse('FF${s.substring(1)}', radix: 16));
  }

  @override
  List<Object?> get props => [id];
}
