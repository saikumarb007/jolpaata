import 'package:flutter_test/flutter_test.dart';
import 'package:jolpaata/core/models/lullaby.dart';

void main() {
  test('Lullaby.fromJson parses a catalogue entry and prefixes asset paths', () {
    final l = Lullaby.fromJson(const {
      'id': 'lullaby_001',
      'title': 'Jo Achyutananda',
      'title_telugu': 'జో అచ్యుతానంద',
      'category_id': 'annamacharya',
      'composer': 'Annamacharya',
      'first_line': 'జో అచ్యుతానంద జోజో ముకుందా',
      'description': 'The most beloved Telugu lullaby.',
      'audio_file': 'audio/telugu/lullaby_001.mp3',
      'lyrics_file': 'lyrics/lullaby_001.json',
      'is_featured': true,
    });

    expect(l.id, 'lullaby_001');
    expect(l.titleTelugu, 'జో అచ్యుతానంద');
    expect(l.composer, 'Annamacharya');
    expect(l.audioAsset, 'assets/audio/telugu/lullaby_001.mp3');
    expect(l.lyricsAsset, 'assets/lyrics/lullaby_001.json');
    expect(l.isFeatured, isTrue);
  });

  test('Lullaby.fromJson tolerates missing optional fields', () {
    final l = Lullaby.fromJson(const {'id': 'x', 'title': 'X'});

    expect(l.composer, '');
    expect(l.firstLine, '');
    expect(l.audioAsset, '');
    expect(l.isFeatured, isFalse);
  });
}
