import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/user_preferences_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../catalog/domain/entities/catalog_item.dart';
import '../../domain/entities/planner_entities.dart';
import '../states/planner_state.dart';
import '../viewmodels/planner_viewmodel.dart';

// ─── Planner Config Screen ────────────────────────────────────────────────────

class PlannerConfigScreen extends StatefulWidget {
  const PlannerConfigScreen({Key? key}) : super(key: key);

  @override
  State<PlannerConfigScreen> createState() => _PlannerConfigScreenState();
}

class _PlannerConfigScreenState extends State<PlannerConfigScreen> {
  late TextEditingController _originController;
  double _budget = 3000;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _detectingLocation = false;

  final List<String> _interestOptions = [
    'Naturaleza',
    'Cultura',
    'Compras',
    'Playa',
    'Gastronomía',
  ];
  final List<IconData> _interestIcons = [
    Icons.nature_people_outlined,
    Icons.palette_outlined,
    Icons.shopping_bag_outlined,
    Icons.beach_access_outlined,
    Icons.restaurant_outlined,
  ];
  final List<String> _selectedInterests = [];

  @override
  void initState() {
    super.initState();
    _originController = TextEditingController();
  }

  @override
  void dispose() {
    _originController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initial = isStart
        ? DateTime.now()
        : (_startDate ?? DateTime.now()).add(const Duration(days: 1));
    final first =
        isStart ? DateTime.now() : (_startDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.accent,
            onPrimary: Colors.white,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  bool get _canGenerate =>
      _startDate != null &&
      _endDate != null &&
      _originController.text.isNotEmpty;

  Future<void> _detectLocation() async {
    setState(() => _detectingLocation = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      final placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty && mounted) {
        final p = placemarks.first;
        final city = (p.locality?.isNotEmpty == true)
            ? p.locality!
            : p.subAdministrativeArea ?? p.administrativeArea ?? '';
        if (city.isNotEmpty) {
          _originController.text = city;
          setState(() {});
        }
      }
    } catch (_) {
      // GPS no disponible
    } finally {
      if (mounted) setState(() => _detectingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                      child: Text(
                        'PLANEAR',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.accent,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 4, 28, 0),
                      child: Text(
                        'Diseña tu viaje.',
                        style: AppTextStyles.headline1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 6, 28, 24),
                      child: Text(
                        'Itinerario generado con inteligencia artificial.',
                        style: AppTextStyles.body,
                      ),
                    ),
                    Container(height: 1, color: AppColors.border),
                  ],
                ),
              ),
            ),
          ),

          // ── Form ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Origin
                  Text('¿Desde dónde sales?', style: AppTextStyles.subtitle),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _originController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Ciudad de origen (ej. Ciudad de México)',
                      prefixIcon: const Icon(
                        Icons.flight_takeoff_outlined,
                        color: AppColors.accent,
                      ),
                      suffixIcon: _detectingLocation
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.accent,
                                ),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.my_location_outlined,
                                size: 20,
                                color: AppColors.stone,
                              ),
                              tooltip: 'Detectar mi ubicación',
                              onPressed: _detectLocation,
                            ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Dates
                  Text('¿Cuándo viajas?', style: AppTextStyles.subtitle),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _DatePickerTile(
                          label: 'Salida',
                          date: _startDate,
                          icon: Icons.flight_takeoff_outlined,
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DatePickerTile(
                          label: 'Regreso',
                          date: _endDate,
                          icon: Icons.flight_land_outlined,
                          onTap: () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  ),
                  if (_startDate != null && _endDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 14,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_endDate!.difference(_startDate!).inDays + 1} días de aventura',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 28),

                  // Budget
                  Text('Presupuesto total', style: AppTextStyles.subtitle),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${_budget.toInt()}',
                        style: AppTextStyles.headline2.copyWith(
                          color: AppColors.accent,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('MXN por persona', style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.accent,
                      inactiveTrackColor: AppColors.border,
                      thumbColor: AppColors.accent,
                      overlayColor: AppColors.accent.withOpacity(0.12),
                      trackHeight: 4,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 10),
                    ),
                    child: Slider(
                      value: _budget,
                      min: 500,
                      max: 15000,
                      divisions: 29,
                      onChanged: (value) => setState(() => _budget = value),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$500', style: AppTextStyles.caption),
                      Text('\$15,000', style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Pinned experiences
                  Consumer<UserPreferencesService>(
                    builder: (context, prefs, _) {
                      if (!prefs.hasPinnedItems) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.bookmark_rounded,
                                size: 14,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Experiencias guardadas',
                                style: AppTextStyles.subtitle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'La IA las incluirá en tu itinerario.',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: prefs.pinnedItems.map((item) {
                              return _PinnedItemChip(
                                item: item,
                                onRemove: () =>
                                    prefs.removePinnedItem(item.id),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 28),
                        ],
                      );
                    },
                  ),

                  // Interests
                  Text('¿Qué te interesa?', style: AppTextStyles.subtitle),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      _interestOptions.length,
                      (index) {
                        final interest = _interestOptions[index];
                        final icon = _interestIcons[index];
                        final isSelected =
                            _selectedInterests.contains(interest);
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (isSelected) {
                              _selectedInterests.remove(interest);
                            } else {
                              _selectedInterests.add(interest);
                            }
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.ink
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.ink
                                    : AppColors.border,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  size: 16,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.stone,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  interest,
                                  style: AppTextStyles.caption.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.ink,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 44),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Consumer<PlannerViewModel>(
          builder: (context, viewModel, _) {
            final isLoading =
                viewModel.state.status == PlannerStatus.loading;
            return ElevatedButton.icon(
              onPressed: _canGenerate && !isLoading
                  ? () {
                      final config = TripConfig(
                        origin: _originController.text,
                        startDate: _startDate!,
                        endDate: _endDate!,
                        budget: _budget,
                        interests: List.from(_selectedInterests),
                      );
                      // Save profile so catalog can personalize
                      final prefs = context.read<UserPreferencesService>();
                      prefs.savePreferences(
                        interests: List.from(_selectedInterests),
                        budget: _budget,
                      );
                      viewModel.generateItinerary(
                        config,
                        pinnedItems: prefs.pinnedItems.toList(),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ItineraryResultScreen(),
                        ),
                      );
                    }
                  : null,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.auto_awesome_outlined, size: 18),
              label: Text(isLoading ? 'Generando...' : 'Generar con IA'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _canGenerate ? AppColors.ink : AppColors.border,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.border,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Pinned Item Chip ─────────────────────────────────────────────────────────

class _PinnedItemChip extends StatelessWidget {
  final CatalogItem item;
  final VoidCallback onRemove;

  const _PinnedItemChip({required this.item, required this.onRemove});

  Color _categoryColor() {
    switch (item.category.toLowerCase()) {
      case 'cultura':    return const Color(0xFF2C1F14);
      case 'naturaleza': return const Color(0xFF142318);
      case 'playa':      return const Color(0xFF0F1E2E);
      case 'compras':    return const Color(0xFF251C10);
      default:           return const Color(0xFF1C1C1C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 52,
            color: _categoryColor(),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.name,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item.price > 0
                    ? '\$${item.price.toInt()} MXN · ${item.community}'
                    : 'Gratis · ${item.community}',
                style: AppTextStyles.caption.copyWith(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 10, 12),
              child: Icon(
                Icons.close,
                size: 14,
                color: AppColors.stone,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Date Picker Tile ─────────────────────────────────────────────────────────

class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final IconData icon;
  final VoidCallback onTap;

  const _DatePickerTile({
    required this.label,
    required this.date,
    required this.icon,
    required this.onTap,
  });

  static const _months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  String _format(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final active = date != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: active
              ? AppColors.accent.withOpacity(0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active
                ? AppColors.accent.withOpacity(0.4)
                : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: active ? AppColors.accent : AppColors.stone,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    active ? _format(date!) : 'Seleccionar',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 12,
                      color: active ? AppColors.ink : AppColors.stone,
                    ),
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

// ─── Itinerary Result Screen ──────────────────────────────────────────────────

class ItineraryResultScreen extends StatelessWidget {
  final bool readOnly;
  const ItineraryResultScreen({Key? key, this.readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<PlannerViewModel>(
        builder: (context, viewModel, _) {
          final state = viewModel.state;

          if (state.status == PlannerStatus.loading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.accent),
                  const SizedBox(height: 24),
                  Text(
                    'Diseñando tu itinerario\nperfecto...',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state.status == PlannerStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 56,
                      color: AppColors.stone,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Error generando itinerario',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Volver'),
                    ),
                  ],
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 170,
                backgroundColor: const Color(0xFF1C110A),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome,
                                  size: 12, color: Colors.white38),
                              const SizedBox(width: 6),
                              Text(
                                'Generado por IA',
                                style: AppTextStyles.label.copyWith(
                                  color: Colors.white38,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tu itinerario.',
                            style: AppTextStyles.headline1.copyWith(
                              color: Colors.white,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${state.itinerary.length} días en el Istmo de Tehuantepec',
                            style: AppTextStyles.body
                                .copyWith(color: Colors.white38),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _SummaryCard(state: state),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _DayCard(day: state.itinerary[index]),
                    childCount: state.itinerary.length,
                  ),
                ),
              ),
              if (state.aiTips.isNotEmpty)
                SliverToBoxAdapter(
                  child: _AiTipsCard(tips: state.aiTips),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: readOnly
            ? OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_outlined, size: 18),
                label: const Text('Volver'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.ink,
                  side: const BorderSide(color: AppColors.border, width: 1.5),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.tune_outlined, size: 18),
                      label: const Text('Ajustar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.ink,
                        side: const BorderSide(
                            color: AppColors.border, width: 1.5),
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Builder(
                      builder: (context) => ElevatedButton.icon(
                        onPressed: () {
                          final vm = context.read<PlannerViewModel>();
                          final state = vm.state;
                          if (state.tripConfig == null ||
                              state.itinerary.isEmpty) return;

                          context
                              .read<UserPreferencesService>()
                              .saveActiveTrip(
                            days: state.itinerary,
                            config: state.tripConfig!,
                            summary: state.aiSummary,
                            budgetProgress: state.budgetProgress,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  '¡Viaje guardado! Revísalo en Inicio.'),
                              backgroundColor: AppColors.ink,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text('Confirmar viaje'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.ink,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final PlannerState state;

  const _SummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final progress = ((state.budgetProgress ?? 0) / 100).clamp(0.0, 1.0);
    final spent = (state.tripConfig?.budget ?? 0) * progress;
    final overBudget = progress > 0.8;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          if (state.aiSummary != null && state.aiSummary!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome,
                      size: 14, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.aiSummary!,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Origen',
                    value: state.tripConfig?.origin ?? '—',
                    icon: Icons.location_on_outlined,
                  ),
                ),
                Container(
                    width: 1, height: 40, color: AppColors.border),
                Expanded(
                  child: _StatItem(
                    label: 'Días',
                    value: '${state.itinerary.length} días',
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
                Container(
                    width: 1, height: 40, color: AppColors.border),
                Expanded(
                  child: _StatItem(
                    label: 'Presupuesto',
                    value: '\$${state.tripConfig?.budget.toInt() ?? 0}',
                    icon: Icons.attach_money_outlined,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Costo estimado del viaje',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      '${state.budgetProgress?.toStringAsFixed(0) ?? 0}% utilizado',
                      style: AppTextStyles.caption.copyWith(
                        color: overBudget
                            ? AppColors.accent
                            : AppColors.graphite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    color: overBudget
                        ? AppColors.accent
                        : AppColors.graphite,
                    backgroundColor: AppColors.border,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${spent.toInt()} MXN de \$${state.tripConfig?.budget.toInt() ?? 0} MXN',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 13, color: AppColors.accent),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Day Card ─────────────────────────────────────────────────────────────────

class _DayCard extends StatelessWidget {
  final ItineraryDay day;

  const _DayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  day.title != null
                      ? 'Día ${day.dayNumber} · ${day.title}'
                      : 'Día ${day.dayNumber}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: day.activities.length,
              itemBuilder: (context, index) {
                final activity = day.activities[index];
                final isLast = index == day.activities.length - 1;
                return _ActivityRow(activity: activity, isLast: isLast);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Activity Row ─────────────────────────────────────────────────────────────

class _ActivityRow extends StatelessWidget {
  final ItineraryActivity activity;
  final bool isLast;

  const _ActivityRow({required this.activity, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 12,
                bottom: isLast ? 20 : 12,
                right: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            activity.time,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          activity.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: AppColors.stone,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                activity.place,
                                style: AppTextStyles.caption,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (activity.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            activity.description!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.stone,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$${activity.estimatedCost.toInt()}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AI Tips Card ─────────────────────────────────────────────────────────────

class _AiTipsCard extends StatelessWidget {
  final List<String> tips;

  const _AiTipsCard({required this.tips});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 15, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(
                'Consejos de tu IA',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
