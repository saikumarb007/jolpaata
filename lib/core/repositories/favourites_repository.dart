import 'package:hive_flutter/hive_flutter.dart';

/// Favourites live in a local Hive box (a set of lullaby ids). No server, no
/// account — the device is the source of truth.
///
// ponytail: Hive box of ids is enough for a favourites list. drift is already
// in the deps for when local data grows relations (play history, downloads).
class FavouritesRepository {
  static const _boxName = 'favourites';

  Box<bool> get _box => Hive.box<bool>(_boxName);

  static Future<void> init() async {
    await Hive.openBox<bool>(_boxName);
  }

  Set<String> all() => _box.keys.cast<String>().toSet();

  bool isFavourite(String id) => _box.get(id, defaultValue: false)!;

  Future<void> toggle(String id) async {
    if (isFavourite(id)) {
      await _box.delete(id);
    } else {
      await _box.put(id, true);
    }
  }
}
