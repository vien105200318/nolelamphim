import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/episode.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_panel.dart';

class EpisodeList extends StatefulWidget {
  final String movieSlug;
  final String movieName;
  final List<EpisodeServer> servers;

  const EpisodeList({
    super.key,
    required this.movieSlug,
    required this.movieName,
    required this.servers,
  });

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  int _selectedServer = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.servers.isEmpty) return const SizedBox.shrink();

    final server = widget.servers[_selectedServer];
    final dataWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.servers.length > 1)
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.servers.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final isSelected = index == _selectedServer;
                return ChoiceChip(
                  label: Text(
                    widget.servers[index].serverName.trim(),
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.gradientMid,
                  backgroundColor: AppColors.glassWhite,
                  onSelected: (_) => setState(() => _selectedServer = index),
                );
              },
            ),
          ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: server.serverData.map((ep) {
            final size = dataWidth > 600 ? 60.0 : 52.0;
            return SizedBox(
              width: size,
              height: size,
              child: GlassPanel(
                blur: 6,
                borderOpacity: 0.08,
                borderRadius: BorderRadius.circular(8),
                padding: EdgeInsets.zero,
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () {
                    context.push('/xem/${widget.movieSlug}/${ep.slug}',
                        extra: widget.movieName);
                  },
                  child: Text(
                    ep.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
