import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/user_profile.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_preferences_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../hospedaje/presentation/screens/hospedaje_screen.dart';
import '../../../llegada/presentation/screens/llegada_screen.dart';
import '../../../planner/presentation/screens/planner_screens.dart';
import '../../../transport/presentation/screens/transport_screen.dart';
import '../../domain/entities/experience.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onExplore;
  final VoidCallback? onPlan;

  const HomeScreen({Key? key, this.onExplore, this.onPlan}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadExperiences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer2<HomeViewModel, UserPreferencesService>(
        builder: (context, vm, prefs, _) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero()),
              if (prefs.hasTrip)
                SliverToBoxAdapter(child: _buildActiveTripCard(prefs)),
              SliverToBoxAdapter(child: _buildPhaseSection(context)),
              SliverToBoxAdapter(
                child: _buildFeatured(vm.state.experiences, prefs),
              ),
              SliverToBoxAdapter(child: _buildCategories()),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }

  // ─── Hero ─────────────────────────────────────────────────────────────────

  Widget _buildHero() {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;

    return Container(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 24, 0),
              child: Row(
                children: [
                  Text(
                    'rAIces',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.accent,
                      letterSpacing: 3,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  if (user != null)
                    GestureDetector(
                      onTap: () => _showProfileSheet(context, user),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.ink,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          user.initials,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    Icon(Icons.search_rounded,
                        color: AppColors.stone, size: 22),
                    const SizedBox(width: 16),
                    Icon(Icons.notifications_none_rounded,
                        color: AppColors.stone, size: 22),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Display text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user != null) ...[
                    Text(
                      'Hola,\n${user.firstName}.',
                      style: AppTextStyles.headline1.copyWith(
                        color: AppColors.ink,
                        fontSize: 40,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '¿Listo para explorar el Istmo?',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.stone,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ] else ...[
                    Text(
                      'ISTMO DE\nTEHUANTEPEC.',
                      style: AppTextStyles.headline1.copyWith(
                        color: AppColors.ink,
                        fontSize: 40,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Turismo comunitario en el\ncorazón de Oaxaca.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.stone,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            // CTAs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                children: [
                  _HeroButton(
                    label: 'Planear viaje',
                    filled: true,
                    onTap: widget.onPlan,
                  ),
                  const SizedBox(width: 12),
                  _HeroButton(
                    label: 'Explorar',
                    filled: false,
                    onTap: widget.onExplore,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // Accent separator
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 28),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(1),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.25,
                child: Container(color: AppColors.accent),
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  // ─── Active Trip Card ─────────────────────────────────────────────────────

  Widget _buildActiveTripCard(UserPreferencesService prefs) {
    final config = prefs.activeConfig!;
    final progress =
        ((prefs.activeBudgetProgress ?? 0) / 100).clamp(0.0, 1.0);
    final totalDays =
        config.endDate.difference(config.startDate).inDays + 1;

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Container(
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
                const Icon(Icons.auto_awesome,
                    size: 12, color: AppColors.accent),
                const SizedBox(width: 6),
                Text(
                  'TU VIAJE ACTIVO',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.accent,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'De ${config.origin} al Istmo.',
              style: AppTextStyles.subtitle.copyWith(
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$totalDays días · \$${config.budget.toInt()} MXN presupuesto',
              style: AppTextStyles.caption
                  .copyWith(color: Colors.white38),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                color: AppColors.accent,
                backgroundColor: Colors.white12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${(progress * 100).toInt()}% del presupuesto utilizado',
              style: AppTextStyles.caption.copyWith(
                color: Colors.white38,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const ItineraryResultScreen(readOnly: true)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver itinerario completo',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 10, color: AppColors.accent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Phase Section ────────────────────────────────────────────────────────

  Widget _buildPhaseSection(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fase 1
            _SectionLabel(label: 'FASE 01', title: 'Antes de salir'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _PhaseCard(
                    icon: Icons.directions_bus_outlined,
                    title: 'Transporte',
                    detail: '13 rutas',
                    onTap: () => Navigator.push(context,
                        _route(const TransportScreen())),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PhaseCard(
                    icon: Icons.hotel_outlined,
                    title: 'Hospedaje',
                    detail: '6 opciones',
                    onTap: () => Navigator.push(context,
                        _route(const HospedajeScreen())),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 36),

            // Fase 2
            _SectionLabel(label: 'FASE 02', title: 'Al llegar'),
            const SizedBox(height: 16),
            _ArrivalCard(
              onTap: () => Navigator.push(
                  context, _route(const LlegadaScreen())),
            ),

            const SizedBox(height: 36),
          ],
        ),
    );
  }

  // ─── Featured ─────────────────────────────────────────────────────────────

  Widget _buildFeatured(
      List<Experience> experiences, UserPreferencesService prefs) {
    if (experiences.isEmpty) return const SizedBox.shrink();

    final label =
        prefs.hasInterests ? 'RECOMENDACIONES' : 'CATÁLOGO';
    final title = prefs.hasInterests ? 'Para ti' : 'Experiencias';

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _SectionLabel(
                        label: label, title: title, compact: true),
                    if (prefs.hasInterests) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.auto_awesome,
                          size: 13, color: AppColors.accent),
                    ],
                  ],
                ),
                GestureDetector(
                  onTap: widget.onExplore,
                  child: Text(
                    'Ver todo →',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: experiences.length,
              itemBuilder: (context, i) =>
                  _ExperienceCard(experience: experiences[i]),
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  // ─── Categories ───────────────────────────────────────────────────────────

  Widget _buildCategories() {
    final items = [
      (icon: Icons.nature_people_outlined, label: 'Naturaleza'),
      (icon: Icons.palette_outlined,       label: 'Cultura'),
      (icon: Icons.beach_access_outlined,  label: 'Playa'),
      (icon: Icons.shopping_bag_outlined,  label: 'Compras'),
      (icon: Icons.restaurant_outlined,    label: 'Gastronomía'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
              label: 'CATEGORÍAS', title: 'Explorar', compact: true),
          const SizedBox(height: 16),
          ...items.map(
            (item) => GestureDetector(
              onTap: widget.onExplore,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(item.icon,
                        size: 18, color: AppColors.graphite),
                    const SizedBox(width: 16),
                    Text(item.label, style: AppTextStyles.bodyLarge),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 12, color: AppColors.stone),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileSheet(BuildContext context, UserProfile user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ProfileSheet(user: user),
    );
  }

  MaterialPageRoute _route(Widget screen) =>
      MaterialPageRoute(builder: (_) => screen);
}

// ─── Hero Button ──────────────────────────────────────────────────────────────

class _HeroButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback? onTap;

  const _HeroButton({
    required this.label,
    required this.filled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: BoxDecoration(
          color: filled ? AppColors.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: filled
              ? null
              : Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            color: filled ? Colors.white : AppColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final String title;
  final bool compact;

  const _SectionLabel({
    required this.label,
    required this.title,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.accent,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style:
              compact ? AppTextStyles.subtitle : AppTextStyles.headline2,
        ),
      ],
    );
  }
}

// ─── Phase Card ───────────────────────────────────────────────────────────────

class _PhaseCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  const _PhaseCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: AppColors.ink),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(detail, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

// ─── Arrival Card ─────────────────────────────────────────────────────────────

class _ArrivalCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ArrivalCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF2A1A12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ya llegué al Istmo.',
                    style: AppTextStyles.headline2.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cómo moverte desde la terminal\no aeropuerto.',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white38,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      'Cómo llegar →',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            const Icon(
              Icons.where_to_vote_outlined,
              size: 48,
              color: Colors.white12,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Experience Card ──────────────────────────────────────────────────────────

class _ExperienceCard extends StatelessWidget {
  final Experience experience;
  const _ExperienceCard({required this.experience});

  Color _cardColor() {
    switch (experience.category) {
      case 'cultura':
        return const Color(0xFF2C1F14);
      case 'naturaleza':
        return const Color(0xFF142318);
      case 'playa':
        return const Color(0xFF0F1E2E);
      case 'compras':
        return const Color(0xFF251C10);
      default:
        return const Color(0xFF1C1C1C);
    }
  }

  IconData _categoryIcon() {
    switch (experience.category) {
      case 'cultura':    return Icons.palette_outlined;
      case 'naturaleza': return Icons.nature_people_outlined;
      case 'playa':      return Icons.beach_access_outlined;
      case 'compras':    return Icons.shopping_bag_outlined;
      default:           return Icons.explore_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_categoryIcon(), size: 18, color: Colors.white70),
          ),
          const Spacer(),
          Text(
            experience.category.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              color: Colors.white24,
              letterSpacing: 1.5,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            experience.name,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontSize: 14,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '\$${experience.price.toInt()} MXN',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Profile Bottom Sheet ─────────────────────────────────────────────────────

class _ProfileSheet extends StatelessWidget {
  final UserProfile user;
  const _ProfileSheet({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),

          // Avatar + name
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: AppColors.ink,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              user.initials,
              style: AppTextStyles.headline2.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(user.fullName, style: AppTextStyles.headline2),
          const SizedBox(height: 4),
          Text(
            '@${user.username}',
            style: AppTextStyles.caption.copyWith(color: AppColors.stone),
          ),
          const SizedBox(height: 20),

          // Stats row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Stat(label: 'Edad', value: '${user.age} años'),
                Container(width: 1, height: 32, color: AppColors.border),
                _Stat(label: 'Género', value: user.gender),
                Container(width: 1, height: 32, color: AppColors.border),
                _Stat(
                    label: 'Presupuesto',
                    value: '\$${user.defaultBudget.toInt()} MXN'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Interests
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Intereses', style: AppTextStyles.caption),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.interests
                .map((i) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        i,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 28),

          // Logout
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.read<UserPreferencesService>().reset();
              context.read<AuthService>().logout();
            },
            icon: const Icon(Icons.logout_outlined, size: 16),
            label: const Text('Cerrar sesión'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accent,
              side: const BorderSide(color: AppColors.accent),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
