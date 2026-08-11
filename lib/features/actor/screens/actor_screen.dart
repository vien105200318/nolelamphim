import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/skeletons.dart';
import '../models/actor.dart';
import '../providers/actor_provider.dart';

class ActorScreen extends ConsumerStatefulWidget {
  const ActorScreen({super.key});

  @override
  ConsumerState<ActorScreen> createState() => _ActorScreenState();
}

class _ActorScreenState extends ConsumerState<ActorScreen> {
  static const _pageSize = 30;

  final _searchController = TextEditingController();
  String _query = '';
  int _visibleCount = _pageSize;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Actor> _filtered(List<Actor> actors) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return actors;
    return actors
        .where((a) => a.name.toLowerCase().contains(q))
        .toList();
  }

  void _showActorInfo(Actor actor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: actor.thumbUrl == null || actor.thumbUrl!.isEmpty
                    ? Container(
                        width: 88,
                        height: 88,
                        color: AppColors.bgCard,
                        alignment: Alignment.center,
                        child: Text(
                          actor.initials,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Image.network(
                        actor.thumbUrl!,
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 88,
                          height: 88,
                          color: AppColors.bgCard,
                          alignment: Alignment.center,
                          child: Text(
                            actor.initials,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 14),
              Text(
                actor.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Danh sách phim của diễn viên sẽ sớm được cập nhật',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final actorsAsync = ref.watch(actorsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        title: const Text('Diễn viên'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textPrimary),
              onChanged: (value) => setState(() {
                _query = value;
                _visibleCount = _pageSize;
              }),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm diễn viên...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppColors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _query = '';
                            _visibleCount = _pageSize;
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.bgSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: actorsAsync.when(
              data: (actors) {
                final filtered = _filtered(actors);
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_outline,
                            size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          _query.trim().isEmpty
                              ? 'Không có diễn viên nào'
                              : 'Không tìm thấy diễn viên',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return _buildGrid(filtered);
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: GridSkeleton(columns: 3, count: 18),
                ),
              ),
              error: (_, _) => _buildError(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<Actor> actors) {
    final visible = actors.take(_visibleCount).toList();
    final hasMore = _visibleCount < actors.length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemCount: visible.length,
          itemBuilder: (context, index) {
            final actor = visible[index];
            return _ActorCard(
              actor: actor,
              onTap: () => _showActorInfo(actor),
            );
          },
        ),
        if (hasMore) ...[
          const SizedBox(height: 12),
          Center(
            child: GlassTile(
              onTap: () => setState(() => _visibleCount += _pageSize),
              radius: 20,
              child: const Text(
                'Xem thêm',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline,
              size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          const Text(
            'Có lỗi xảy ra',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => ref.invalidate(actorsProvider),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

class _ActorCard extends StatelessWidget {
  final Actor actor;
  final VoidCallback onTap;

  const _ActorCard({required this.actor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipOval(
            child: actor.thumbUrl == null || actor.thumbUrl!.isEmpty
                ? Container(
                    width: 72,
                    height: 72,
                    color: AppColors.glassWhite,
                    alignment: Alignment.center,
                    child: Text(
                      actor.initials,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Image.network(
                    actor.thumbUrl!,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 72,
                      height: 72,
                      color: AppColors.glassWhite,
                      alignment: Alignment.center,
                      child: Text(
                        actor.initials,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            actor.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
