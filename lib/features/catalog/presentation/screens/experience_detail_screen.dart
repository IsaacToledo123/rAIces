import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/user_preferences_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/catalog_item.dart';

class ExperienceDetailScreen extends StatelessWidget {
  final CatalogItem item;

  const ExperienceDetailScreen({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blancoHueso,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: _getGradientStart(item.category),
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.bookmark_border_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: _getGradient(item.category),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -40,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: 20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 48),
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getCategoryIcon(item.category),
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.category,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: AppTextStyles.headline2.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.arena,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.terracota,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.rating.toString(),
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.terracota,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.verdeSelva,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.community,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.verdeSelva,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Price + schedule card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.arena,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio por persona',
                                style: AppTextStyles.caption,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.price > 0
                                    ? '\$${item.price.toInt()} MXN'
                                    : 'Entrada libre',
                                style: AppTextStyles.headline2.copyWith(
                                  color: AppColors.terracota,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (item.schedule != null) ...[
                          Container(
                            width: 1,
                            height: 48,
                            color: AppColors.neutralLight,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Horario',
                                style: AppTextStyles.caption,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule_outlined,
                                    size: 14,
                                    color: AppColors.neutralMedium,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.schedule!,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Descripción',
                    style: AppTextStyles.subtitle.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.description,
                    style: AppTextStyles.body.copyWith(height: 1.7),
                  ),

                  // Includes
                  if (item.includes != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Incluye',
                      style: AppTextStyles.subtitle.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    ...item.includes!.split(', ').map(
                          (inc) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.verdeSelva
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: AppColors.verdeSelva,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    inc,
                                    style: AppTextStyles.body,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<UserPreferencesService>(
        builder: (context, prefs, _) {
          final pinned = prefs.isPinned(item.id);
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            decoration: BoxDecoration(
              color: AppColors.blancoHueso,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                if (pinned) {
                  prefs.removePinnedItem(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} quitado del viaje'),
                      backgroundColor: AppColors.neutralMedium,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    ),
                  );
                } else {
                  prefs.addPinnedItem(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} agregado a tu viaje'),
                      backgroundColor: AppColors.verdeSelva,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    ),
                  );
                }
              },
              icon: Icon(pinned
                  ? Icons.check_circle_outline
                  : Icons.add_circle_outline),
              label: Text(pinned ? 'En tu viaje ✓' : 'Agregar a mi viaje'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    pinned ? AppColors.neutralMedium : AppColors.terracota,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getGradientStart(String category) {
    switch (category.toLowerCase()) {
      case 'naturaleza':
        return const Color(0xFF2D6A4F);
      case 'cultura':
        return const Color(0xFFC1440E);
      case 'playa':
        return const Color(0xFF1565C0);
      case 'compras':
        return const Color(0xFF6A3728);
      default:
        return AppColors.verdeSelva;
    }
  }

  LinearGradient _getGradient(String category) {
    switch (category.toLowerCase()) {
      case 'naturaleza':
        return const LinearGradient(
          colors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'cultura':
        return const LinearGradient(
          colors: [Color(0xFFC1440E), Color(0xFFE07B54)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'playa':
        return const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'compras':
        return const LinearGradient(
          colors: [Color(0xFF6A3728), Color(0xFFA0522D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [AppColors.verdeSelva, AppColors.terracota],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cultura':
        return Icons.palette_outlined;
      case 'naturaleza':
        return Icons.nature_people_outlined;
      case 'playa':
        return Icons.beach_access_outlined;
      case 'compras':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.explore_outlined;
    }
  }
}
