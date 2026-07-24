import 'package:equatable/equatable.dart';

/// A single lullaby entry. Loaded from the bundled catalogue.json asset —
/// no network, fully offline.
class Lullaby extends Equatable {
  const Lullaby({
    required this.id,
    required this.title,
    required this.titleTelugu,
    required this.artist,
    required this.durationSeconds,
    required this.audioAsset,
    required this.lyricsAsset,
    required this.tags,
  });

  final String id;
  final String title;
  final String titleTelugu;
  final String artist;
  final int durationSeconds;
  final String audioAsset;
  final String lyricsAsset;
  final List<String> tags;

  factory Lullaby.fromJson(Map<String, dynamic> json) => Lullaby(
        id: json['id'] as String,
        title: json['title'] as String,
        titleTelugu: json['titleTelugu'] as String? ?? '',
        artist: json['artist'] as String? ?? '',
        durationSeconds: json['durationSeconds'] as int? ?? 0,
        audioAsset: json['audioAsset'] as String,
        lyricsAsset: json['lyricsAsset'] as String? ?? '',
        tags: (json['tags'] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toList(),
      );

  @override
  List<Object?> get props => [id];
}
