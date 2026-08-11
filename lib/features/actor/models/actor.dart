class Actor {
  final int id;
  final String name;
  final String slug;
  final String? thumbUrl;

  const Actor({
    required this.id,
    required this.name,
    required this.slug,
    this.thumbUrl,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    final rawId = json['_id'];
    return Actor(
      id: rawId is num
          ? rawId.toInt()
          : int.tryParse('$rawId') ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      thumbUrl: json['thumb_url'] as String?,
    );
  }

  String get initials {
    final parts = name
        .replaceAll(RegExp("['\"`]"), '')
        .trim()
        .split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}
