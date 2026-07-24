import 'package:equatable/equatable.dart';

/// A single lullaby entry from the bundled catalogue.json — fully offline.
/// Asset paths in the JSON are relative to the assets/ root; we prefix them so
/// the loaders get a valid asset key.
class Lullaby extends Equatable {
  const Lullaby({
    required this.id,
    required this.title,
    required this.titleTelugu,
    required this.categoryId,
    required this.composer,
    required this.firstLine,
    required this.description,
    required this.audioAsset,
    required this.lyricsAsset,
    required this.isFeatured,
  });

  final String id;
  final String title;
  final String titleTelugu;
  final String categoryId;
  final String composer;
  final String firstLine;
  final String description;
  final String audioAsset;
  final String lyricsAsset;
  final bool isFeatured;

  factory Lullaby.fromJson(Map<String, dynamic> json) => Lullaby(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        titleTelugu: json['title_telugu'] as String? ?? '',
        categoryId: json['category_id'] as String? ?? '',
        composer: json['composer'] as String? ?? '',
        firstLine: json['first_line'] as String? ?? '',
        description: json['description'] as String? ?? '',
        audioAsset: _asset(json['audio_file'] as String?),
        lyricsAsset: _asset(json['lyrics_file'] as String?),
        isFeatured: json['is_featured'] as bool? ?? false,
      );

  static String _asset(String? path) =>
      (path == null || path.isEmpty) ? '' : 'assets/$path';

  @override
  List<Object?> get props => [id];
}
