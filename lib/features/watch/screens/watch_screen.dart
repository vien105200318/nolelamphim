import 'package:flutter/material.dart';

class WatchScreen extends StatelessWidget {
  final String slug;
  final String episode;

  const WatchScreen({
    super.key,
    required this.slug,
    required this.episode,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Watch: $slug - $episode'),
    );
  }
}
