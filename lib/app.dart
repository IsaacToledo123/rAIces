import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart' as di;
import 'core/services/auth_service.dart';
import 'core/services/user_preferences_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/catalog/presentation/viewmodels/catalog_viewmodel.dart';
import 'features/home/presentation/viewmodels/home_viewmodel.dart';
import 'features/hospedaje/presentation/viewmodels/hospedaje_viewmodel.dart';
import 'features/planner/presentation/viewmodels/planner_viewmodel.dart';
import 'features/transport/presentation/viewmodels/transport_viewmodel.dart';
import 'main_screen.dart';

class RaicesApp extends StatelessWidget {
  const RaicesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthService>()),
        ChangeNotifierProvider(create: (_) => di.sl<UserPreferencesService>()),
        ChangeNotifierProvider(create: (_) => di.sl<HomeViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<CatalogViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<PlannerViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<TransportViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<HospedajeViewModel>()),
      ],
      child: MaterialApp(
        title: 'rAIces',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Consumer<AuthService>(
          builder: (context, auth, _) =>
              auth.isLoggedIn ? const MainScreen() : const LoginScreen(),
        ),
      ),
    );
  }
}
