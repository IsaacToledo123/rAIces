import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/hospedaje_item.dart';

class HospedajeDetailScreen extends StatelessWidget {
  final HospedajeItem item;

  const HospedajeDetailScreen({Key? key, required this.item})
      : super(key: key);

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace')),
        );
      }
    }
  }

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
    return Scaffold(
      backgroundColor: AppColors.blancoHueso,
      body: CustomScrollView(
        slivers: [
          // ── Hero AppBar ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.verdeSelva,
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
                    icon: const Icon(Icons.share_outlined,
                        color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
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
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
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
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.type == 'casa_huespedes'
                                  ? Icons.home_outlined
                                  : Icons.hotel_outlined,
                              size: 60,
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
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
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
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────
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
                          style: AppTextStyles.headline2
                              .copyWith(fontSize: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.arena,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 16, color: AppColors.terracota),
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 15, color: AppColors.verdeSelva),
                      const SizedBox(width: 4),
                      Text(
                        item.location,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.verdeSelva,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Price card
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
                                'Precio por noche',
                                style: AppTextStyles.caption,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${item.pricePerNight.toInt()} MXN',
                                style: AppTextStyles.headline2.copyWith(
                                  color: AppColors.terracota,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 48,
                          color: AppColors.neutralLight,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dirección',
                                style: AppTextStyles.caption),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 130,
                              child: Text(
                                item.address,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.neutralDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
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

                  // Amenities
                  const SizedBox(height: 24),
                  Text(
                    'Servicios incluidos',
                    style: AppTextStyles.subtitle.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: item.amenities.map((a) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.verdeSelva.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.verdeSelva.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _amenityIcon(a),
                              size: 14,
                              color: AppColors.verdeSelva,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              a,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.neutralDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom CTA ─────────────────────────────────────────────────────────
      bottomNavigationBar: Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Booking button (primary)
            ElevatedButton.icon(
              onPressed: () => _launchUrl(context, item.bookingUrl),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: const Text('Ver disponibilidad en Booking.com'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003580),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 10),
            // Maps button (secondary)
            if (item.mapsUrl != null)
              OutlinedButton.icon(
                onPressed: () => _launchUrl(context, item.mapsUrl!),
                icon: const Icon(Icons.map_outlined, size: 16),
                label: const Text('Ver en Google Maps'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.verdeSelva,
                  side: const BorderSide(color: AppColors.verdeSelva),
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _amenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi_outlined;
      case 'alberca':
        return Icons.pool_outlined;
      case 'restaurante':
        return Icons.restaurant_outlined;
      case 'estacionamiento':
        return Icons.local_parking_outlined;
      case 'ac':
      case 'aire acondicionado':
        return Icons.ac_unit_outlined;
      case 'desayuno incluido':
      case 'desayuno':
        return Icons.free_breakfast_outlined;
      case 'bar':
        return Icons.local_bar_outlined;
      case 'tv':
        return Icons.tv_outlined;
      case 'cocina compartida':
        return Icons.kitchen_outlined;
      case 'hamacas':
        return Icons.beach_access_outlined;
      case 'jardín':
      case 'patio':
        return Icons.yard_outlined;
      case 'bicicletas':
        return Icons.directions_bike_outlined;
      case 'vista al mar':
        return Icons.water_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }
}
