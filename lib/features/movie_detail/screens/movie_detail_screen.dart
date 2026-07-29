import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final String slug;

  const MovieDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Movie Detail: $slug'),
    );
  }
}
