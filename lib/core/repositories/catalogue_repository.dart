import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/category.dart';
import '../models/lullaby.dart';

/// Reads the bundled catalogue.json from app assets. Local-first: the catalogue
/// ships inside the app, so browsing works with zero connectivity.
class CatalogueRepository {
  List<Lullaby>? _lullabies;
  List<Category>? _categories;

  Future<void> _ensure() async {
    if (_lullabies != null) return;
    final raw = await rootBundle.loadString('assets/catalogue.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _lullabies = (json['lullabies'] as List<dynamic>)
        .map((e) => Lullaby.fromJson(e as Map<String, dynamic>))
        .toList();
    _categories = (json['categories'] as List<dynamic>? ?? const [])
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Lullaby>> load() async {
    await _ensure();
    return _lullabies!;
  }

  Future<List<Category>> categories() async {
    await _ensure();
    return _categories!;
  }
}
