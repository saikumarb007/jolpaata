import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/models/lullaby.dart';

/// Plays a lullaby from a bundled local asset with just_audio. No ads here —
/// nothing interrupts a sleeping baby.
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
      setState(() => _error = 'Audio file not found yet');
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.album, size: 120),
            const SizedBox(height: 16),
            Text(
              l.titleTelugu.isNotEmpty ? l.titleTelugu : l.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(l.artist),
            const SizedBox(height: 24),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.grey))
            else
              StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snap) {
                  final playing = snap.data?.playing ?? false;
                  return IconButton(
                    iconSize: 64,
                    icon: Icon(
                      playing ? Icons.pause_circle : Icons.play_circle,
                    ),
                    onPressed: () =>
                        playing ? _player.pause() : _player.play(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
