import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'features/catalog/presentation/screens/catalog_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/planner/presentation/screens/planner_screens.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _navigate(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            onExplore: () => _navigate(1),
            onPlan: () => _navigate(2),
          ),
          const CatalogScreen(),
          const PlannerConfigScreen(),
          const _ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: _navigate,
      ),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    (icon: Icons.home_outlined,    active: Icons.home_rounded,           label: 'Inicio'),
    (icon: Icons.grid_view_outlined, active: Icons.grid_view_rounded,    label: 'Explorar'),
    (icon: Icons.auto_awesome_outlined, active: Icons.auto_awesome,      label: 'Planear'),
    (icon: Icons.person_outline,   active: Icons.person_rounded,         label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: active ? 1 : 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          active ? item.active : item.icon,
                          size: 22,
                          color: active ? AppColors.ink : AppColors.graphite,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: AppTextStyles.label.copyWith(
                            color: active ? AppColors.ink : AppColors.stone,
                            letterSpacing: 0.5,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Profile Screen ───────────────────────────────────────────────────────────

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ───────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF1C110A),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 48),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PERFIL',
                              style: AppTextStyles.label.copyWith(
                                color: Colors.white38,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Viajero\ndel Istmo.',
                              style: AppTextStyles.headline1.copyWith(
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white12, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          size: 30,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Stats ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF1C110A),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Row(
                  children: [
                    _StatTile(value: '3', label: 'Viajes'),
                    _Divider(),
                    _StatTile(value: '12', label: 'Experiencias'),
                    _Divider(),
                    _StatTile(value: '4', label: 'Comunidades'),
                  ],
                ),
              ),
            ),
          ),

          // ── Menu items ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CUENTA',
                    style: AppTextStyles.label.copyWith(letterSpacing: 2),
                  ),
                  const SizedBox(height: 12),
                  _MenuRow(icon: Icons.bookmark_outline_rounded,
                      label: 'Guardados'),
                  _MenuRow(icon: Icons.history_rounded,
                      label: 'Historial de viajes'),
                  const SizedBox(height: 28),
                  Text(
                    'SOPORTE',
                    style: AppTextStyles.label.copyWith(letterSpacing: 2),
                  ),
                  const SizedBox(height: 12),
                  _MenuRow(icon: Icons.help_outline_rounded, label: 'Ayuda'),
                  _MenuRow(icon: Icons.info_outline_rounded,
                      label: 'Acerca de rAIces'),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.headline2
                  .copyWith(color: AppColors.accent),
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const SizedBox(width: 1, height: 40,
          child: ColoredBox(color: AppColors.border));
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MenuRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        leading: Icon(icon, size: 20, color: AppColors.graphite),
        title: Text(label, style: AppTextStyles.bodyLarge),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 13, color: AppColors.stone),
        shape: Border(
            bottom: BorderSide(color: AppColors.border)),
      ),
    );
  }
}
