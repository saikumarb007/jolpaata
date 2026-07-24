import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';

import '../../core/models/lullaby.dart';

/// Plays a lullaby from a bundled local asset and shows its lyrics. No ads here
/// — nothing interrupts a sleeping baby. Works as a lyrics reader even with no
/// audio file present, so the app is useful before any recordings exist.
///
// ponytail: foreground playback only. Wire audio_service (already a dep) for
// background/lockscreen playback when you need play-with-screen-off.
class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.lullaby});

  final Lullaby lullaby;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final _player = AudioPlayer();
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      // Local asset — plays fully offline.
      await _player.setAsset(widget.lullaby.audioAsset);
    } catch (e) {
      // Expected until real audio files are dropped into assets/audio/telugu/.
      setState(() => _error = 'Audio file not added yet');
    }
  }

  // Lyrics are a bundled JSON asset:
  //   { "lines": [...telugu...], "complete": true|false }
  // Public-domain traditional verses, offline. Returns the joined text plus the
  // `complete` flag; when the file is missing the text is empty and the view
  // falls back to the catalogue's first_line.
  Future<(String, bool)> _lyrics() async {
    try {
      final raw = await rootBundle.loadString(widget.lullaby.lyricsAsset);
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final lines = (json['lines'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList();
      return (lines.join('\n'), json['complete'] as bool? ?? false);
    } catch (_) {
      return ('', false);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.lullaby;
    return Scaffold(
      appBar: AppBar(title: Text(l.title)),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.album, size: 96),
          const SizedBox(height: 8),
          Text(
            l.titleTelugu.isNotEmpty ? l.titleTelugu : l.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(l.composer),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_error!, style: const TextStyle(color: Colors.grey)),
            )
          else
            StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snap) {
                final playing = snap.data?.playing ?? false;
                return IconButton(
                  iconSize: 56,
                  icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                  onPressed: () =>
                      playing ? _player.pause() : _player.play(),
                );
              },
            ),
          const Divider(),
          Expanded(child: _LyricsView(future: _lyrics(), lullaby: l)),
        ],
      ),
    );
  }
}

class _LyricsView extends StatelessWidget {
  const _LyricsView({required this.future, required this.lullaby});

  final Future<(String, bool)> future;
  final Lullaby lullaby;

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.7);
    return FutureBuilder<(String, bool)>(
      future: future,
      builder: (context, snap) {
        final (text, complete) = snap.data ?? ('', false);
        final shown = text.trim().isNotEmpty ? text : lullaby.firstLine;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(shown, textAlign: TextAlign.center, style: body),
              // Partial (only the opening line) until someone finishes the file
              // and sets "complete": true.
              if (!complete) ...[
                const SizedBox(height: 24),
                Text(
                  lullaby.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Full lyrics coming soon',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
