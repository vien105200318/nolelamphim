import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage_service.dart';

const _storageKey = 'ratings';

class RatingsNotifier extends StateNotifier<Map<String, int>> {
  final LocalStorageService _storage;
  Future<void>? _ready;

  RatingsNotifier(this._storage) : super({}) {
    _ready = _load();
  }

  Future<void> _load() async {
    final map = await _storage.readMap(_storageKey);
    state = map.map(
      (k, v) => MapEntry(k, (v as num).toInt()),
    );
  }

  Future<void> rate(String slug, int value) async {
    await _ready;
    state = {...state, slug: value};
    await _storage.writeMap(
      _storageKey,
      state.map((k, v) => MapEntry(k, v)),
    );
  }
}

final ratingsProvider =
    StateNotifierProvider<RatingsNotifier, Map<String, int>>((ref) {
  return RatingsNotifier(ref.read(localStorageServiceProvider));
});
