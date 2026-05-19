import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/hospedaje_item.dart';
import '../states/hospedaje_state.dart';
import '../viewmodels/hospedaje_viewmodel.dart';
import 'hospedaje_detail_screen.dart';

class HospedajeScreen extends StatefulWidget {
  const HospedajeScreen({Key? key}) : super(key: key);

  @override
  State<HospedajeScreen> createState() => _HospedajeScreenState();
}

class _HospedajeScreenState extends State<HospedajeScreen> {
  final List<String> _locations = [
    'Todos',
    'Juchitán',
    'Tehuantepec',
    'Salina Cruz',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HospedajeViewModel>().loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blancoHueso,
      body: Consumer<HospedajeViewModel>(
        builder: (context, vm, _) {
          final state = vm.state;

          return CustomScrollView(
            slivers: [
              // ── AppBar ──────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 140,
                backgroundColor: AppColors.verdeSelva,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(24, 0, 0, 16),
                  title: Text(
                    'Hospedaje',
                    style: AppTextStyles.headline2.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.verdeSelva, Color(0xFF1B4332)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 28,
                          bottom: 20,
                          child: Icon(
                            Icons.hotel_outlined,
                            size: 48,
                            color: Colors.white24,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(24, 70, 24, 0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Istmo de Tehuantepec, Oaxaca',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Filter chips ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.verdeSelva,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.blancoHueso,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filtrar por municipio',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutralMedium,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _locations.map((loc) {
                                final selected =
                                    state.selectedLocation == loc;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () =>
                                        vm.filterByLocation(loc),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 180),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? AppColors.verdeSelva
                                            : AppColors.arena,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                          color: selected
                                              ? AppColors.verdeSelva
                                              : AppColors.neutralLight,
                                        ),
                                      ),
                                      child: Text(
                                        loc,
                                        style:
                                            AppTextStyles.caption.copyWith(
                                          color: selected
                                              ? Colors.white
                                              : AppColors.neutralDark,
                                          fontWeight: selected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Content ──────────────────────────────────────────────────
              if (state.status == HospedajeStatus.loading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.terracota),
                  ),
                )
              else if (state.items.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hotel_outlined,
                            size: 56,
                            color:
                                AppColors.neutralMedium.withOpacity(0.4)),
                        const SizedBox(height: 16),
                        Text(
                          'Sin opciones en esta zona',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = state.items[index];
                        return _HospedajeCard(
                          item: item,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  HospedajeDetailScreen(item: item),
                            ),
                          ),
                        );
                      },
                      childCount: state.items.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Hospedaje Card ───────────────────────────────────────────────────────────

class _HospedajeCard extends StatelessWidget {
  final HospedajeItem item;
  final VoidCallback onTap;

  const _HospedajeCard({required this.item, required this.onTap});

  String _typeLabel(String type) {
    switch (type) {
      case 'posada':
        return 'Posada';
      case 'casa_huespedes':
        return 'Casa de huéspedes';
      default:
        return 'Hotel';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image area ───────────────────────────────────────────────
            Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D6A4F), Color(0xFF1B4332)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      item.type == 'casa_huespedes'
                          ? Icons.home_outlined
                          : Icons.hotel_outlined,
                      size: 52,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _typeLabel(item.type),
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 12, color: Color(0xFFFFC107)),
                          const SizedBox(width: 3),
                          Text(
                            item.rating.toString(),
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
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

            // ── Info ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${item.pricePerNight.toInt()} MXN',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.terracota,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'por noche',
                            style: AppTextStyles.caption
                                .copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.verdeSelva,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item.location,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.verdeSelva,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Amenity chips (max 4)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: item.amenities.take(4).map((a) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.arena,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          a,
                          style: AppTextStyles.caption
                              .copyWith(fontSize: 11),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.description,
                          style: AppTextStyles.body.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.verdeSelva,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
