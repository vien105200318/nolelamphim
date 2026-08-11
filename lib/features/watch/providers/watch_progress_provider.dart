import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage_service.dart';

const _storageKey = 'watch_progress';

/// Nhớ tiến độ xem theo từng tập: key = "{movieSlug}/{episodeSlug}".
class WatchProgressNotifier extends StateNotifier<Map<String, int>> {
  final LocalStorageService _storage;
  Future<void>? _ready;

  WatchProgressNotifier(this._storage) : super({}) {
    _ready = _load();
  }

  Future<void> _load() async {
    final map = await _storage.readMap(_storageKey);
    state = map.map((k, v) => MapEntry(k, (v as num).toInt()));
  }

  Future<void> _persist() async {
    await _storage.writeMap(_storageKey, state);
  }

  int? progress(String movieSlug, String episodeSlug) {
    final v = state['$movieSlug/$episodeSlug'];
    return v != null && v > 0 ? v : null;
  }

  Future<void> save(String movieSlug, String episodeSlug, int seconds) async {
    if (seconds <= 0) return;
    await _ready;
    final key = '$movieSlug/$episodeSlug';
    if (state[key] == seconds) return;
    state = {...state, key: seconds};
    await _persist();
  }

  Future<void> clear(String movieSlug, String episodeSlug) async {
    await _ready;
    final key = '$movieSlug/$episodeSlug';
    if (!state.containsKey(key)) return;
    state = {...state}..remove(key);
    await _persist();
  }
}

final watchProgressProvider =
    StateNotifierProvider<WatchProgressNotifier, Map<String, int>>((ref) {
  return WatchProgressNotifier(ref.read(localStorageServiceProvider));
});
