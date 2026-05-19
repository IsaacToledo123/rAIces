import 'package:get_it/get_it.dart';

// Services
import '../services/ai_service.dart';
import '../services/auth_service.dart';
import '../services/user_preferences_service.dart';

// Onboarding
import '../../features/onboarding/data/datasource/onboarding_local_datasource.dart';
import '../../features/onboarding/data/repository/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repository/i_onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/get_onboarding_slides.dart';
import '../../features/onboarding/presentation/viewmodels/onboarding_viewmodel.dart';

// Home
import '../../features/home/data/datasource/home_local_datasource.dart';
import '../../features/home/data/repository/home_repository_impl.dart';
import '../../features/home/domain/repository/i_home_repository.dart';
import '../../features/home/domain/usecases/get_featured_experiences.dart';
import '../../features/home/presentation/viewmodels/home_viewmodel.dart';

// Catalog
import '../../features/catalog/data/datasource/catalog_local_datasource.dart';
import '../../features/catalog/data/repository/catalog_repository_impl.dart';
import '../../features/catalog/domain/repository/i_catalog_repository.dart';
import '../../features/catalog/domain/usecases/filter_catalog_by_category.dart';
import '../../features/catalog/domain/usecases/get_catalog_items.dart';
import '../../features/catalog/presentation/viewmodels/catalog_viewmodel.dart';

// Planner
import '../../features/planner/data/datasource/planner_local_datasource.dart';
import '../../features/planner/data/repository/planner_repository_impl.dart';
import '../../features/planner/domain/repository/i_planner_repository.dart';
import '../../features/planner/domain/usecases/calculate_budget_progress.dart';
import '../../features/planner/domain/usecases/generate_itinerary.dart';
import '../../features/planner/presentation/viewmodels/planner_viewmodel.dart';

// Transport
import '../../features/transport/data/datasource/transport_local_datasource.dart';
import '../../features/transport/data/repository/transport_repository_impl.dart';
import '../../features/transport/domain/repository/i_transport_repository.dart';
import '../../features/transport/domain/usecases/get_transport_options.dart';
import '../../features/transport/presentation/viewmodels/transport_viewmodel.dart';

// Hospedaje
import '../../features/hospedaje/data/datasource/hospedaje_local_datasource.dart';
import '../../features/hospedaje/data/repository/hospedaje_repository_impl.dart';
import '../../features/hospedaje/domain/repository/i_hospedaje_repository.dart';
import '../../features/hospedaje/domain/usecases/get_hospedaje_items.dart';
import '../../features/hospedaje/presentation/viewmodels/hospedaje_viewmodel.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ═══════════════ Services ═══════════════
  sl.registerLazySingleton(() => AiService());
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => UserPreferencesService());

  // ═══════════════ ViewModels ═══════════════
  sl.registerFactory(() => OnboardingViewModel(sl()));
  sl.registerFactory(() => HomeViewModel(sl()));
  sl.registerFactory(() => CatalogViewModel(sl(), sl()));
  sl.registerFactory(() => PlannerViewModel(sl<AiService>(), sl<CalculateBudgetProgress>()));
  sl.registerFactory(() => TransportViewModel(sl()));
  sl.registerFactory(() => HospedajeViewModel(sl()));

  // ═══════════════ UseCases ═══════════════
  sl.registerLazySingleton(() => GetOnboardingSlides(sl()));
  sl.registerLazySingleton(() => GetFeaturedExperiences(sl()));
  sl.registerLazySingleton(() => GetCatalogItems(sl()));
  sl.registerLazySingleton(() => FilterCatalogByCategory(sl()));
  sl.registerLazySingleton(() => GenerateItinerary(sl()));
  sl.registerLazySingleton(() => CalculateBudgetProgress(sl()));
  sl.registerLazySingleton(() => GetTransportOptions(sl()));
  sl.registerLazySingleton(() => GetHospedajeItems(sl()));

  // ═══════════════ Repositories ═══════════════
  sl.registerLazySingleton<IOnboardingRepository>(
      () => OnboardingRepositoryImpl(sl()));
  sl.registerLazySingleton<IHomeRepository>(
      () => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<ICatalogRepository>(
      () => CatalogRepositoryImpl(sl()));
  sl.registerLazySingleton<IPlannerRepository>(
      () => PlannerRepositoryImpl(sl()));
  sl.registerLazySingleton<ITransportRepository>(
      () => TransportRepositoryImpl(sl()));
  sl.registerLazySingleton<IHospedajeRepository>(
      () => HospedajeRepositoryImpl(sl()));

  // ═══════════════ Datasources ═══════════════
  sl.registerLazySingleton<OnboardingLocalDatasource>(
      () => OnboardingLocalDatasourceImpl());
  sl.registerLazySingleton<HomeLocalDatasource>(
      () => HomeLocalDatasourceImpl());
  sl.registerLazySingleton<CatalogLocalDatasource>(
      () => CatalogLocalDatasourceImpl());
  sl.registerLazySingleton<PlannerLocalDatasource>(
      () => PlannerLocalDatasourceImpl());
  sl.registerLazySingleton<TransportLocalDatasource>(
      () => TransportLocalDatasourceImpl());
  sl.registerLazySingleton<HospedajeLocalDatasource>(
      () => HospedajeLocalDatasourceImpl());
}
