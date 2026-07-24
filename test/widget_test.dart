import 'package:flutter_test/flutter_test.dart';
import 'package:jolpaata/core/models/lullaby.dart';

void main() {
  test('Lullaby.fromJson parses a catalogue entry', () {
    final l = Lullaby.fromJson(const {
      'id': 'jo-001',
      'title': 'Chandamama Raave',
      'titleTelugu': 'చందమామ రావే',
      'artist': 'Traditional',
      'durationSeconds': 180,
      'audioAsset': 'assets/audio/telugu/chandamama_raave.mp3',
      'lyricsAsset': 'assets/lyrics/chandamama_raave.txt',
      'tags': ['classic', 'moon'],
    });

    expect(l.id, 'jo-001');
    expect(l.titleTelugu, 'చందమామ రావే');
    expect(l.tags, ['classic', 'moon']);
  });

  test('Lullaby.fromJson tolerates missing optional fields', () {
    final l = Lullaby.fromJson(const {
      'id': 'jo-002',
      'title': 'Untitled',
      'audioAsset': 'assets/audio/telugu/x.mp3',
    });

    expect(l.artist, '');
    expect(l.durationSeconds, 0);
    expect(l.tags, isEmpty);
  });
}
