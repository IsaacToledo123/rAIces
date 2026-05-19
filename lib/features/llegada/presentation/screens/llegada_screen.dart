import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/datasource/llegada_datasource.dart';
import '../../domain/entities/arrival_point.dart';

class LlegadaScreen extends StatefulWidget {
  const LlegadaScreen({Key? key}) : super(key: key);

  @override
  State<LlegadaScreen> createState() => _LlegadaScreenState();
}

class _LlegadaScreenState extends State<LlegadaScreen> {
  final List<ArrivalPoint> _points = LlegadaDatasourceImpl().getArrivalPoints();
  ArrivalPoint? _selected;

  static const _destQuery = 'Juchitán de Zaragoza, Oaxaca, México';

  Future<void> _openMaps(String origin, String destination) async {
    final url = 'https://www.google.com/maps/dir/?api=1'
        '&origin=${Uri.encodeComponent(origin)}'
        '&destination=${Uri.encodeComponent(destination)}'
        '&travelmode=driving';
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir Maps')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blancoHueso,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            backgroundColor: AppColors.terracota,
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
                'Ya llegaste al Istmo',
                style: AppTextStyles.headline2.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB5451B), AppColors.terracota],
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
                        Icons.location_city_outlined,
                        size: 52,
                        color: Colors.white24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 72, 24, 0),
                      child: Row(
                        children: [
                          const Icon(Icons.pin_drop_outlined,
                              size: 14, color: Colors.white70),
                          const SizedBox(width: 6),
                          Text(
                            'Istmo de Tehuantepec, Oaxaca',
                            style: AppTextStyles.caption
                                .copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Round-corner transition ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.terracota,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.blancoHueso,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¿Dónde llegaste?', style: AppTextStyles.subtitle),
                    const SizedBox(height: 4),
                    Text(
                      'Selecciona tu punto de llegada para ver cómo moverte.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.neutralMedium,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Arrival point cards
                    ..._points.map((p) => _ArrivalPointCard(
                          point: p,
                          isSelected: _selected?.id == p.id,
                          onTap: () =>
                              setState(() => _selected = p),
                        )),
                  ],
                ),
              ),
            ),
          ),

          // ── Transport options (when selected) ────────────────────────────
          if (_selected != null)
            SliverToBoxAdapter(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.terracota,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Transporte desde ${_selected!.city}',
                            style: AppTextStyles.subtitle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._selected!.transports
                          .map((t) => _TransportRow(transport: t)),
                    ],
                  ),
                ),
              ),
            ),

          // ── Quick Actions ────────────────────────────────────────────────
          if (_selected != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.verdeSelva,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('Rutas rápidas', style: AppTextStyles.subtitle),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _QuickActionButton(
                      icon: Icons.place_outlined,
                      label: 'Ver terminal en Google Maps',
                      onTap: () => _openMaps(
                          _selected!.mapsQuery, _destQuery),
                    ),
                    const SizedBox(height: 10),
                    _QuickActionButton(
                      icon: Icons.account_balance_outlined,
                      label: 'Llegar al centro de ${_selected!.city}',
                      color: AppColors.verdeSelva,
                      onTap: () => _openMaps(
                          _selected!.mapsQuery,
                          _selected!.centerMapsQuery),
                    ),
                  ],
                ),
              ),
            ),

          // ── Tips card ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: _TipsCard(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Arrival Point Card ───────────────────────────────────────────────────────

class _ArrivalPointCard extends StatelessWidget {
  final ArrivalPoint point;
  final bool isSelected;
  final VoidCallback onTap;

  const _ArrivalPointCard({
    required this.point,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBus = point.type == 'bus';
    final color = isSelected ? AppColors.terracota : AppColors.neutralMedium;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.terracota.withOpacity(0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.terracota
                : AppColors.neutralLight,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isBus
                    ? Icons.directions_bus_outlined
                    : Icons.flight_land_outlined,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.terracota
                          : AppColors.neutralDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    point.address,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.neutralMedium,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppColors.terracota
                  : AppColors.neutralLight,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Transport Row ────────────────────────────────────────────────────────────

class _TransportRow extends StatelessWidget {
  final LocalTransport transport;

  const _TransportRow({required this.transport});

  IconData _icon(String type) {
    switch (type) {
      case 'moto_taxi':
        return Icons.two_wheeler_outlined;
      case 'colectivo':
        return Icons.airport_shuttle_outlined;
      default:
        return Icons.local_taxi_outlined;
    }
  }

  Color _color(String type) {
    switch (type) {
      case 'moto_taxi':
        return AppColors.terracota;
      case 'colectivo':
        return AppColors.verdeSelva;
      default:
        return const Color(0xFF1B3A6B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _color(transport.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.neutralLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: c.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon(transport.type), color: c, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  transport.label,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transport.priceRange,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: c,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    transport.duration,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.neutralMedium),
                  ),
                ],
              ),
            ],
          ),
          if (transport.notes != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline,
                    size: 13, color: AppColors.neutralMedium),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    transport.notes!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.neutralMedium,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Quick Action Button ──────────────────────────────────────────────────────

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = const Color(0xFF1B3A6B),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.5)),
          minimumSize: const Size(0, 48),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ─── Tips Card ────────────────────────────────────────────────────────────────

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context) {
    const tips = [
      '🛵  El moto-taxi es el transporte emblema del Istmo — rápido, barato y parte de la cultura local.',
      '💬  Negocia el precio del taxi antes de subir. Es la norma aquí.',
      '🌞  Los colectivos a veces cambian de ruta en festividades. Pregunta siempre al chofer.',
      '📍  Si llegas de noche, el taxi es la opción más segura desde la terminal.',
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.arena,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.neutralLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline,
                  size: 18, color: AppColors.terracota),
              const SizedBox(width: 8),
              Text(
                'Consejos para moverte',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                t,
                style: AppTextStyles.body.copyWith(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
