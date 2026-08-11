import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage_service.dart';

const _storageKey = 'recent';

class HistoryItem {
  final int id;
  final String slug;
  final String name;
  final String? thumbUrl;
  final String episode;
  final String episodeSlug;
  final String? tmdbVote;
  final int watchedAt;

  HistoryItem({
    required this.id,
    required this.slug,
    required this.name,
    this.thumbUrl,
    required this.episode,
    this.episodeSlug = '',
    this.tmdbVote,
    required this.watchedAt,
  });

  /// Slug tập để điều hướng `/xem/{slug}/{episodeSlug}`; fallback từ tên tập
  /// (web: "Tập 5" → "tap-5", cuối cùng "tap-1").
  String get resolveEpisodeSlug {
    if (episodeSlug.isNotEmpty) return episodeSlug;
    final clean = episode.replaceFirst('Tập ', '').trim();
    if (clean.isNotEmpty) return 'tap-$clean';
    return 'tap-1';
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'slug': slug,
        'name': name,
        if (thumbUrl != null) 'thumb_url': thumbUrl,
        'episode': episode,
        if (episodeSlug.isNotEmpty) 'episodeSlug': episodeSlug,
        if (tmdbVote != null) 'tmdb_vote': tmdbVote,
        'watchedAt': watchedAt,
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        id: json['_id'] as int,
        slug: json['slug'] as String,
        name: json['name'] as String,
        thumbUrl: json['thumb_url'] as String?,
        episode: json['episode'] as String? ?? '',
        episodeSlug: json['episodeSlug'] as String? ?? '',
        tmdbVote: json['tmdb_vote'] as String?,
        watchedAt: json['watchedAt'] as int? ?? 0,
      );
}

class HistoryNotifier extends StateNotifier<List<HistoryItem>> {
  final LocalStorageService _storage;
  Future<void>? _ready;

  HistoryNotifier(this._storage) : super([]) {
    _ready = _load();
  }

  Future<void> _load() async {
    final items = await _storage.readList(_storageKey);
    state = items.map((e) => HistoryItem.fromJson(e)).toList();
  }

  Future<void> _persist() async {
    await _storage.writeList(
      _storageKey,
      state.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> add(HistoryItem item) async {
    await _ready;
    state = [item, ...state.where((e) => e.slug != item.slug)];
    if (state.length > 20) state = state.sublist(0, 20);
    await _persist();
  }

  Future<void> remove(String slug) async {
    await _ready;
    state = state.where((e) => e.slug != slug).toList();
    await _persist();
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<HistoryItem>>((ref) {
  final storage = ref.read(localStorageServiceProvider);
  return HistoryNotifier(storage);
});
