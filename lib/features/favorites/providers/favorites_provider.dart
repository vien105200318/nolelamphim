import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/models/movie.dart';

const _storageKey = 'favorites';

class FavoritesNotifier extends StateNotifier<List<Movie>> {
  final LocalStorageService _storage;
  Future<void>? _ready;

  FavoritesNotifier(this._storage) : super([]) {
    _ready = _load();
  }

  Future<void> _load() async {
    final items = await _storage.readList(_storageKey);
    state = items.map((e) => Movie.fromJson(e)).toList();
  }

  Future<void> _persist() async {
    await _storage.writeList(
      _storageKey,
      state.map((e) => {
        '_id': e.id,
        'name': e.name,
        'slug': e.slug,
        if (e.posterUrl != null) 'poster_url': e.posterUrl,
        if (e.thumbUrl != null) 'thumb_url': e.thumbUrl,
        if (e.year != null) 'year': e.year,
      }).toList(),
    );
  }

  bool isFavorite(int id) => state.any((m) => m.id == id);

  Future<void> get ready => _ready ?? Future.value();

  Future<void> toggle(Movie movie) async {
    await _ready;
    if (isFavorite(movie.id)) {
      state = state.where((m) => m.id != movie.id).toList();
    } else {
      state = [movie, ...state];
    }
    await _persist();
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Movie>>((ref) {
  final storage = ref.read(localStorageServiceProvider);
  return FavoritesNotifier(storage);
});
