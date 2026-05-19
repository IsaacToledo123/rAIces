# rAIces - Frontend Flutter

App de turismo comunitario para el Istmo de Tehuantepec, México.

## Estructura del Proyecto

```
lib/
├── main.dart                 ← Punto de entrada
├── app.dart                  ← MaterialApp + MultiProvider
│
├── core/
│   ├── di/
│   │   └── injection_container.dart  ← GetIt + setup
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── errors/
│   │   └── failures.dart
│   └── widgets/
│       └── (common_widgets.dart - próximos)
│
├── features/
│   ├── onboarding/
│   │   ├── domain/
│   │   │   ├── entities/onboarding_slide.dart
│   │   │   ├── repository/i_onboarding_repository.dart
│   │   │   └── usecases/get_onboarding_slides.dart
│   │   ├── data/
│   │   │   ├── datasource/onboarding_local_datasource.dart
│   │   │   ├── model/onboarding_slide_model.dart
│   │   │   └── repository/onboarding_repository_impl.dart
│   │   └── presentation/
│   │       ├── states/onboarding_state.dart
│   │       ├── viewmodels/onboarding_viewmodel.dart
│   │       └── screens/
│   │           ├── onboarding_screen.dart
│   │           └── login_screen.dart
│   │
│   ├── home/
│   │   ├── domain/
│   │   │   ├── entities/experience.dart
│   │   │   ├── repository/i_home_repository.dart
│   │   │   └── usecases/get_featured_experiences.dart
│   │   ├── data/
│   │   │   ├── datasource/home_local_datasource.dart
│   │   │   ├── model/experience_model.dart
│   │   │   └── repository/home_repository_impl.dart
│   │   └── presentation/
│   │       ├── states/home_state.dart
│   │       ├── viewmodels/home_viewmodel.dart
│   │       └── screens/home_screen.dart
│   │
│   ├── catalog/
│   │   ├── domain/
│   │   │   ├── entities/catalog_item.dart
│   │   │   ├── repository/i_catalog_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_catalog_items.dart
│   │   │       └── filter_catalog_by_category.dart
│   │   ├── data/
│   │   │   ├── datasource/catalog_local_datasource.dart
│   │   │   ├── model/catalog_item_model.dart
│   │   │   └── repository/catalog_repository_impl.dart
│   │   └── presentation/
│   │       ├── states/catalog_state.dart
│   │       ├── viewmodels/catalog_viewmodel.dart
│   │       └── screens/catalog_screen.dart
│   │
│   └── planner/
│       ├── domain/
│       │   ├── entities/planner_entities.dart
│       │   ├── repository/i_planner_repository.dart
│       │   └── usecases/
│       │       ├── generate_itinerary.dart
│       │       └── calculate_budget_progress.dart
│       ├── data/
│       │   ├── datasource/planner_local_datasource.dart
│       │   ├── model/planner_models.dart
│       │   └── repository/planner_repository_impl.dart
│       └── presentation/
│           ├── states/planner_state.dart
│           ├── viewmodels/planner_viewmodel.dart
│           └── screens/planner_screens.dart
```

## Arquitectura: Clean Architecture + MVVM

### Capas

- **Domain (independiente)**: Entities, Repository interfaces, UseCases
- **Data (infraestructura)**: Datasources, Models, Repository implementations
- **Presentation (UI)**: Screens, ViewModels (ChangeNotifier), States

## Dependencias

```yaml
provider: ^6.1.2              # State Management
get_it: ^7.7.0                # Service Locator / DI
google_fonts: ^6.2.1          # Custom fonts
intl: ^0.19.0                 # Localización
equatable: ^2.0.5             # Comparación de objetos
```

## Identidad Visual

- **Nombre**: rAIces (IA intencional en mayúsculas)
- **Colores**:
  - Terracota: #C1440E
  - Verde Selva: #2D6A4F
  - Arena: #F2E8D9
  - Blanco Hueso: #FAFAF5
- **Tipografía**:
  - Títulos: Playfair Display
  - Cuerpo: Inter

## Features

### Onboarding
- Pantalla de bienvenida con carrusel de slides
- Pantalla de login

### Home
- Experiencias destacadas del Istmo
- Datos de comunidades reales

### Catalog
- Catálogo completo de experiencias
- Filtrado por categoría (Naturaleza, Cultura, Compras, Playa)
- Detalles de experiencias

### Planner
- Configuración del viaje (origen, fechas, presupuesto, intereses)
- Generación de itinerario IA-optimizado
- Cálculo de presupuesto y progreso

## Datos Mock

Todas las datasources locales retornan datos de lugares reales del Istmo:
- Mercado Benito Juárez (Juchitán)
- Laguna Superior (Santo Domingo Tehuantepec)
- Playa La Ventosa (Salina Cruz)
- Cerro del Tigre
- Museo Ferrocarril de Tehuantepec

## Próximos Pasos

1. Agregar `common_widgets.dart` en `core/widgets/`
2. Integración con API REST (reemplazar mock datasources)
3. Autenticación Firebase
4. Persistencia local (Hive/Drift)
5. Testing (unit + widget tests)
6. Animaciones y transiciones pulidas
