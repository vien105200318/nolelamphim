import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/category.dart';
import '../../../core/models/country.dart';
import '../../search/providers/search_provider.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        title: const Text('Danh mục'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(text: 'Thể loại'),
            Tab(text: 'Quốc gia'),
            Tab(text: 'Năm'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CategoriesTab(),
          _CountriesTab(),
          _YearsTab(),
        ],
      ),
    );
  }
}

class _CategoriesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(categoriesProvider);
    return async.when(
      data: (items) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(categoriesProvider),
        child: _buildGrid(context, items),
      ),
      loading: () => const _ShimmerGrid(),
      error: (_, _) => _ErrorState(
        onRetry: () => ref.invalidate(categoriesProvider),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Category> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _CategoryChip(
          label: item.name,
          onTap: () => context.push('/category/the-loai/${item.slug}'),
        );
      },
    );
  }
}

class _CountriesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(countriesProvider);
    return async.when(
      data: (items) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(countriesProvider),
        child: _buildGrid(context, items),
      ),
      loading: () => const _ShimmerGrid(),
      error: (_, _) => _ErrorState(
        onRetry: () => ref.invalidate(countriesProvider),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Country> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _CategoryChip(
          label: item.name,
          onTap: () => context.push('/category/quoc-gia/${item.slug}'),
        );
      },
    );
  }
}

class _YearsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(yearsProvider);
    return async.when(
      data: (items) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(yearsProvider),
        child: _buildGrid(context, items),
      ),
      loading: () => const _ShimmerGrid(),
      error: (_, _) => _ErrorState(
        onRetry: () => ref.invalidate(yearsProvider),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<String> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final year = items[index];
        return _CategoryChip(
          label: year,
          onTap: () => context.push('/category/nam/$year'),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CategoryChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgCard,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _ShimmerGrid extends StatelessWidget {
  const _ShimmerGrid();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgSurface,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 9,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback? onRetry;

  const _ErrorState({this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          const Text(
            'Không thể tải danh mục',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ],
      ),
    );
  }
}
