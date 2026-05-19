import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/models/ai_recommendation.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/services/user_preferences_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/catalog_item.dart';
import '../states/catalog_state.dart';
import '../viewmodels/catalog_viewmodel.dart';
import 'experience_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final List<String> _categories = [
    'Todos',
    'Naturaleza',
    'Cultura',
    'Compras',
    'Playa',
  ];

  UserPreferencesService? _prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefs = context.read<UserPreferencesService>();
      _prefs!.addListener(_onPrefsChanged);
      context.read<CatalogViewModel>().loadItems();
      // Try loading AI recs after catalog items have loaded (500ms mock + buffer)
      Future.delayed(const Duration(milliseconds: 800), _maybeLoadRecs);
    });
  }

  @override
  void dispose() {
    _prefs?.removeListener(_onPrefsChanged);
    super.dispose();
  }

  void _onPrefsChanged() {
    if (!mounted) return;
    final prefs = _prefs!;
    // Reload recs when interests changed (savePreferences clears old recs)
    if (prefs.hasInterests && !prefs.hasRecommendations && !prefs.loadingRecs) {
      final items = context.read<CatalogViewModel>().state.items;
      if (items.isNotEmpty) _maybeLoadRecs();
    }
  }

  Future<void> _maybeLoadRecs() async {
    if (!mounted) return;
    final prefs = context.read<UserPreferencesService>();
    final vm = context.read<CatalogViewModel>();
    final items = vm.state.items;

    if (!prefs.hasInterests ||
        prefs.hasRecommendations ||
        prefs.loadingRecs ||
        items.isEmpty) return;

    prefs.setLoadingRecs(true);
    try {
      final recs = await di.sl<AiService>().getRecommendations(
        interests: prefs.interests,
        budget: prefs.budget,
        items: items,
      );
      if (mounted) prefs.setRecommendations(recs);
    } catch (_) {
      if (mounted) prefs.setLoadingRecs(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer2<CatalogViewModel, UserPreferencesService>(
        builder: (context, vm, prefs, _) {
          final state = vm.state;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(state, vm)),
              if (prefs.hasInterests)
                SliverToBoxAdapter(
                  child: _buildParaTi(state, prefs),
                ),
              _buildContent(state, context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(CatalogState state, CatalogViewModel viewModel) {
    return Container(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
              child: Text(
                'CATÁLOGO',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 4, 28, 20),
              child: Text('Explorar', style: AppTextStyles.headline1),
            ),
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == state.selectedCategory;
                  return GestureDetector(
                    onTap: () => viewModel.filterByCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 28),
                      padding: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? AppColors.accent
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        cat,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isSelected
                              ? AppColors.ink
                              : AppColors.stone,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(height: 1, color: AppColors.border),
          ],
        ),
      ),
    );
  }

  // ─── Para Ti Section ───────────────────────────────────────────────────────

  Widget _buildParaTi(CatalogState state, UserPreferencesService prefs) {
    final recs = prefs.recommendations;
    final loading = prefs.loadingRecs;

    final recItems = recs
        .map((r) => _findById(state.items, r.itemId))
        .where((i) => i != null)
        .cast<CatalogItem>()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome,
                  size: 13, color: AppColors.accent),
              const SizedBox(width: 6),
              Text(
                'PARA TI',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 2,
                ),
              ),
              if (loading) ...[
                const SizedBox(width: 10),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (recItems.isNotEmpty)
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              itemCount: recItems.length,
              itemBuilder: (context, i) {
                final item = recItems[i];
                final rec = recs.firstWhere((r) => r.itemId == item.id);
                return _ParaTiChip(
                  item: item,
                  rec: rec,
                  isPinned: prefs.isPinned(item.id),
                  onAdd: () => prefs.isPinned(item.id)
                      ? prefs.removePinnedItem(item.id)
                      : prefs.addPinnedItem(item),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExperienceDetailScreen(item: item),
                    ),
                  ),
                );
              },
            ),
          )
        else if (!loading)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Text(
              'Genera un itinerario para ver recomendaciones.',
              style: AppTextStyles.caption,
            ),
          ),
        const SizedBox(height: 16),
        Container(height: 1, color: AppColors.border),
      ],
    );
  }

  CatalogItem? _findById(List<CatalogItem> items, String id) {
    try {
      return items.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  // ─── Main Content ──────────────────────────────────────────────────────────

  Widget _buildContent(CatalogState state, BuildContext context) {
    if (state.status == CatalogStatus.loading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    if (state.status == CatalogStatus.error) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            state.errorMessage ?? 'Error al cargar',
            style: AppTextStyles.body,
          ),
        ),
      );
    }

    if (state.items.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_outlined,
                  size: 56, color: AppColors.stone),
              SizedBox(height: 16),
              Text(
                'No hay experiencias\nen esta categoría',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = state.items[index];
            return CatalogGridCard(
              item: item,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExperienceDetailScreen(item: item),
                ),
              ),
            );
          },
          childCount: state.items.length,
        ),
      ),
    );
  }
}

// ─── Para Ti Chip ─────────────────────────────────────────────────────────────

class _ParaTiChip extends StatelessWidget {
  final CatalogItem item;
  final AiRecommendation rec;
  final bool isPinned;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const _ParaTiChip({
    required this.item,
    required this.rec,
    required this.isPinned,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPinned ? AppColors.accent.withOpacity(0.5) : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Para ti',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.accent,
                      fontSize: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onAdd,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isPinned
                          ? AppColors.accent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isPinned
                            ? AppColors.accent
                            : AppColors.border,
                      ),
                    ),
                    child: Icon(
                      isPinned ? Icons.check : Icons.add,
                      size: 14,
                      color: isPinned ? Colors.white : AppColors.stone,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              rec.reason,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                color: AppColors.stone,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grid Card ────────────────────────────────────────────────────────────────

class CatalogGridCard extends StatelessWidget {
  final CatalogItem item;
  final VoidCallback onTap;

  const CatalogGridCard({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  Color _darkColor() {
    switch (item.category.toLowerCase()) {
      case 'cultura':    return const Color(0xFF2C1F14);
      case 'naturaleza': return const Color(0xFF142318);
      case 'playa':      return const Color(0xFF0F1E2E);
      case 'compras':    return const Color(0xFF251C10);
      default:           return const Color(0xFF1C1C1C);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cultura':    return Icons.palette_outlined;
      case 'naturaleza': return Icons.nature_people_outlined;
      case 'playa':      return Icons.beach_access_outlined;
      case 'compras':    return Icons.shopping_bag_outlined;
      default:           return Icons.explore_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: double.infinity,
              color: _darkColor(),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _getCategoryIcon(item.category),
                      size: 42,
                      color: Colors.white24,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 10, color: Color(0xFFFFC107)),
                          const SizedBox(width: 2),
                          Text(
                            item.rating.toString(),
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.community,
                      style: AppTextStyles.caption.copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      item.price > 0
                          ? '\$${item.price.toInt()} MXN'
                          : 'Gratis',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
