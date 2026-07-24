import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/lullaby.dart';

/// Reads the bundled catalogue.json from app assets. Local-first: the catalogue
/// ships inside the app, so browsing works with zero connectivity.
class CatalogueRepository {
  List<Lullaby>? _cache;

  Future<List<Lullaby>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/catalogue.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = (json['lullabies'] as List<dynamic>)
        .map((e) => Lullaby.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cache = list;
  }
}
