import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/transport_option.dart';
import '../states/transport_state.dart';
import '../viewmodels/transport_viewmodel.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({Key? key}) : super(key: key);

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  static const _typeFilters = ['Todos', 'bus', 'flight_bus'];
  static const _typeLabels = ['Todos', 'Autobús', 'Vuelo + Bus'];

  final TextEditingController _searchController = TextEditingController();
  bool _detectingLocation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransportViewModel>().loadOptions();
    });
    _searchController.addListener(() {
      if (mounted) {
        context.read<TransportViewModel>().applyOriginFilter(_searchController.text);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── URL helpers ────────────────────────────────────────────────────────────

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

  Future<void> _openMaps(
      BuildContext context, String origin, String dest) async {
    final url =
        'https://www.google.com/maps/dir/?api=1'
        '&origin=${Uri.encodeComponent(origin)}'
        '&destination=${Uri.encodeComponent(dest)}'
        '&travelmode=transit';
    await _launchUrl(context, url);
  }

  // ── Location detection ─────────────────────────────────────────────────────

  Future<void> _detectLocation(BuildContext context) async {
    setState(() => _detectingLocation = true);

    try {
      // 1. Verificar si el servicio de ubicación está habilitado
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!context.mounted) return;
      if (!serviceEnabled) {
        _showError(context, 'Activa el GPS en tu dispositivo');
        return;
      }

      // 2. Verificar / pedir permiso
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (!context.mounted) return;
      if (permission == LocationPermission.deniedForever) {
        _showError(
          context,
          'Permiso de ubicación denegado. Actívalo en Ajustes.',
        );
        return;
      }
      if (permission == LocationPermission.denied) {
        _showError(context, 'Se necesita permiso de ubicación');
        return;
      }

      // 3. Obtener posición
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // 4. Geocoding inverso → nombre de ciudad
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final city = placemarks.isNotEmpty
          ? (placemarks.first.locality ??
              placemarks.first.administrativeArea ??
              '')
          : '';

      // 5. Mapear a término de búsqueda
      if (!context.mounted) return;
      final vm = context.read<TransportViewModel>();
      final searchTerm = vm.mapCityToFilter(city);

      _searchController.text = searchTerm.isNotEmpty ? searchTerm : city;
      // El listener del controller ya llama applyOriginFilter, pero lo
      // llamamos explícitamente aquí por si el texto no cambió.
      vm.applyOriginFilter(_searchController.text);

      _showSuccess(
        context,
        searchTerm.isEmpty
            ? 'Ubicación detectada: $city — sin rutas directas'
            : 'Ubicación detectada: $city',
      );
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'No se pudo obtener la ubicación');
      }
    } finally {
      if (mounted) setState(() => _detectingLocation = false);
    }
  }

  void _showError(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.terracota,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.verdeSelva,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blancoHueso,
      body: Consumer<TransportViewModel>(
        builder: (context, vm, _) {
          final state = vm.state;

          return CustomScrollView(
            slivers: [
              // ── AppBar ────────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 140,
                backgroundColor: const Color(0xFF1B3A6B),
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      const EdgeInsets.fromLTRB(24, 0, 0, 16),
                  title: Text(
                    '¿Cómo llegarás?',
                    style: AppTextStyles.headline2.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B3A6B), Color(0xFF2D6A4F)],
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
                          right: 24,
                          bottom: 20,
                          child: Icon(
                            Icons.directions_bus_outlined,
                            size: 48,
                            color: Colors.white24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Filters panel ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: const Color(0xFF1B3A6B),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.blancoHueso,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Origin search ────────────────────────────────────
                        _OriginSearchBar(
                          controller: _searchController,
                          detectingLocation: _detectingLocation,
                          onDetect: () => _detectLocation(context),
                        ),

                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 14),

                        // ── Type filter ──────────────────────────────────────
                        Text(
                          'Tipo de transporte',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutralMedium,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              _typeFilters.length,
                              (i) {
                                final selected =
                                    state.selectedType == _typeFilters[i];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () =>
                                        vm.applyTypeFilter(_typeFilters[i]),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 180),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? const Color(0xFF1B3A6B)
                                            : AppColors.arena,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                          color: selected
                                              ? const Color(0xFF1B3A6B)
                                              : AppColors.neutralLight,
                                        ),
                                      ),
                                      child: Text(
                                        _typeLabels[i],
                                        style: AppTextStyles.caption.copyWith(
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
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Results count ─────────────────────────────────────────────
              if (state.status == TransportStatus.success)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 16, 20, 4),
                    child: Text(
                      '${state.options.length} opciones disponibles',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutralMedium,
                      ),
                    ),
                  ),
                ),

              // ── Content ───────────────────────────────────────────────────
              if (state.status == TransportStatus.loading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.terracota),
                  ),
                )
              else if (state.status == TransportStatus.error)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      state.errorMessage ?? 'Error al cargar',
                      style: AppTextStyles.body,
                    ),
                  ),
                )
              else if (state.options.isEmpty)
                SliverFillRemaining(
                  child: _EmptyState(
                    searchQuery: _searchController.text,
                    onOpenMaps: () => _openMaps(
                      context,
                      '${_searchController.text}, México',
                      'Juchitán de Zaragoza, Oaxaca, México',
                    ),
                    onClearSearch: () {
                      _searchController.clear();
                      vm.applyOriginFilter('');
                    },
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final option = state.options[index];
                        return _TransportCard(
                          option: option,
                          onBuy: () =>
                              _launchUrl(context, option.bookingUrl),
                          onMaps: () => _openMaps(
                            context,
                            option.mapsOriginQuery,
                            option.mapsDestQuery,
                          ),
                        );
                      },
                      childCount: state.options.length,
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

// ─── Origin Search Bar ────────────────────────────────────────────────────────

class _OriginSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool detectingLocation;
  final VoidCallback onDetect;

  const _OriginSearchBar({
    required this.controller,
    required this.detectingLocation,
    required this.onDetect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Desde dónde sales?',
          style: AppTextStyles.subtitle.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 10),

        // Search field
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            return TextField(
              controller: controller,
              style: AppTextStyles.bodyLarge.copyWith(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Ej. Ciudad de México, Puebla, Veracruz...',
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.neutralMedium,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.neutralMedium,
                  size: 20,
                ),
                suffixIcon: value.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close,
                            size: 18, color: AppColors.neutralMedium),
                        onPressed: () => controller.clear(),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.arena,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF1B3A6B),
                    width: 1.5,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 10),

        // GPS detect button
        GestureDetector(
          onTap: detectingLocation ? null : onDetect,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: detectingLocation
                  ? AppColors.neutralLight
                  : AppColors.verdeSelva.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: detectingLocation
                    ? AppColors.neutralLight
                    : AppColors.verdeSelva.withOpacity(0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                detectingLocation
                    ? const SizedBox(
                        width: 13,
                        height: 13,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.verdeSelva,
                        ),
                      )
                    : const Icon(
                        Icons.my_location_outlined,
                        size: 15,
                        color: AppColors.verdeSelva,
                      ),
                const SizedBox(width: 6),
                Text(
                  detectingLocation
                      ? 'Detectando tu ubicación...'
                      : 'Detectar mi ubicación',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.verdeSelva,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onOpenMaps;
  final VoidCallback onClearSearch;

  const _EmptyState({
    required this.searchQuery,
    required this.onOpenMaps,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final hasQuery = searchQuery.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.arena,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_bus_outlined,
                size: 38,
                color: AppColors.neutralMedium.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasQuery
                  ? 'Sin rutas registradas desde "$searchQuery"'
                  : 'Sin opciones disponibles',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasQuery
                  ? 'Puede que haya opciones en Google Maps.\nBúscalas con transporte público.'
                  : 'Intenta con otra ciudad de origen.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.neutralMedium,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasQuery) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onOpenMaps,
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: Text('Buscar desde "$searchQuery" en Maps'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3A6B),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ] else
              const SizedBox(height: 24),
            TextButton(
              onPressed: onClearSearch,
              child: const Text('Ver todas las rutas disponibles'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Transport Card ───────────────────────────────────────────────────────────

class _TransportCard extends StatelessWidget {
  final TransportOption option;
  final VoidCallback onBuy;
  final VoidCallback onMaps;

  const _TransportCard({
    required this.option,
    required this.onBuy,
    required this.onMaps,
  });

  @override
  Widget build(BuildContext context) {
    final isBus = option.type == 'bus';
    final accentColor =
        isBus ? const Color(0xFF1B3A6B) : AppColors.terracota;

    return Container(
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
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isBus
                        ? Icons.directions_bus_outlined
                        : Icons.connecting_airports_outlined,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.company,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${option.origin} → ${option.destination}',
                        style: AppTextStyles.caption.copyWith(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isBus ? 'Autobús' : 'Vuelo+Bus',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Price + Duration ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Precio', style: AppTextStyles.caption),
                      const SizedBox(height: 2),
                      Text(
                        '\$${option.price.toInt()} MXN',
                        style: AppTextStyles.headline2.copyWith(
                          color: accentColor,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: 1, height: 40, color: AppColors.neutralLight),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Duración', style: AppTextStyles.caption),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.schedule_outlined,
                                size: 15,
                                color: AppColors.neutralMedium),
                            const SizedBox(width: 4),
                            Text(
                              option.duration,
                              style: AppTextStyles.bodyLarge
                                  .copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Departure times ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.access_time_outlined,
                    size: 14, color: AppColors.neutralMedium),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    option.departureTimes,
                    style: AppTextStyles.caption
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          // ── Includes ────────────────────────────────────────────────────
          if (option.includes != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 14, color: AppColors.verdeSelva),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      option.includes!,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.neutralMedium),
                    ),
                  ),
                ],
              ),
            ),

          // ── Buttons ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onMaps,
                    icon: const Icon(Icons.map_outlined, size: 16),
                    label: const Text('Ver ruta'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.verdeSelva,
                      side:
                          const BorderSide(color: AppColors.verdeSelva),
                      minimumSize: const Size(0, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: onBuy,
                    icon: const Icon(Icons.open_in_new, size: 15),
                    label: const Text('Comprar boleto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 44),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
