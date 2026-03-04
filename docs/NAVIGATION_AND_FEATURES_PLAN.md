# Plan: Coordinación de navegación y módulos por feature

## Objetivo

- **Un solo lugar** que decida qué pantalla se muestra (Router).
- **Features separados** por carpeta para que cada pantalla tenga su lógica y vistas agrupadas.

---

## 1. Router (coordinación de navegación)

### Idea

En lugar de que cada pantalla tenga su propio `NavigationLink` o `navigationDestination` y estado (`selectedMovie`, etc.), un **Router** (ObservableObject) guarda la pila de navegación. Las vistas solo dicen "navega a X"; el Router actualiza la pila y el `NavigationStack` raíz muestra la pantalla correspondiente.

### Implementación

**1.1 Definir las rutas** (enum Hashable para poder usarlas en `NavigationStack(path:)`):

```swift
// App/Navigation/AppRoute.swift
enum AppRoute: Hashable {
    case home
    case favorites
    case movieDetail(Movie)
}
```

**1.2 Router** que mantiene la pila:

```swift
// App/Navigation/AppRouter.swift
@MainActor
final class AppRouter: ObservableObject {
    @Published var path: [AppRoute] = []

    func push(_ route: AppRoute) { path.append(route) }
    func pop() { if !path.isEmpty { path.removeLast() } }
    func popToRoot() { path = [] }
}
```

**1.3 Una sola NavigationStack en el App** que lee el Router:

- Inyectar `AppRouter` en el Environment (o como StateObject en la vista raíz).
- Vista raíz: `NavigationStack(path: $router.path)` y contenido inicial = Home.
- Un único `.navigationDestination(for: AppRoute.self)` que, según el caso, muestra:
  - `.favorites` → FavoriteMoviesScreenView
  - `.movieDetail(let movie)` → MovieDetailView(movie: movie)

**1.4 Cambios en las vistas**

- **HomeScreenView**: ya no usa `@State private var selectedMovie` ni `.navigationDestination(item: $selectedMovie)`. Al tocar una película llama `router.push(.movieDetail(movie))`. El menú de favoritos llama `router.push(.favorites)` en lugar de `NavigationLink(destination: FavoriteMoviesScreenView())`.
- **FavoriteMoviesScreenView**: al tocar una película llama `router.push(.movieDetail(movie))` en lugar de `selectedMovie` + `navigationDestination`. Puede seguir teniendo estado local para qué celda se tocó, pero la decisión de "mostrar detalle" la toma el Router.
- **MovieDetailView**: sin cambios de navegación (no empuja más pantallas).

Resultado: toda la navegación sale del mismo sitio (Router + un solo `navigationDestination`), y añadir una pantalla nueva es solo un caso más en el enum y en el `navigationDestination`.

---

## 2. Módulos por feature (estructura de carpetas)

### Idea

Agrupar por **feature** (pantalla/flujo) en lugar de por tipo (todas las Views juntas, todos los ViewModels juntos). Cada feature puede contener sus vistas, ViewModels y lógica específica. Lo compartido (modelos, servicios, componentes reutilizables) queda en carpetas comunes.

### Estructura propuesta

```
MovieApp/
├── App/
│   ├── MovieAppApp.swift
│   ├── AppConfig.swift
│   ├── EnvironmentKeys.swift
│   └── Navigation/
│       ├── AppRoute.swift
│       └── AppRouter.swift
├── Core/                          # Compartido
│   ├── Model/
│   │   ├── Movie.swift
│   │   ├── MovieResponse.swift
│   │   ├── FavoriteMovie.swift
│   │   └── MovieAPIError.swift
│   ├── Services/
│   │   ├── MovieService.swift
│   │   ├── MovieServiceProtocol.swift
│   │   ├── MovieAPIClient.swift
│   │   ├── MovieAPIClientProtocol.swift
│   │   ├── FavoriteMovieService.swift
│   │   └── FavoriteMovieServiceProtocol.swift
│   └── Components/                # Subvistas reutilizables
│       ├── MovieCardView.swift
│       ├── MovieGridItemView.swift
│       ├── FavoriteButton.swift
│       └── VoteProgressView.swift
├── Features/
│   ├── Home/
│   │   ├── HomeScreenView.swift
│   │   └── MovieViewModel.swift
│   ├── Favorites/
│   │   ├── FavoriteMoviesScreenView.swift
│   │   └── FavoriteMovieViewModel.swift
│   └── Detail/
│       └── MovieDetailView.swift
```

### Ventajas

- Cada feature tiene un alcance claro (Home, Favorites, Detail).
- Al abrir la carpeta Home ves vista + ViewModel juntos.
- Core concentra modelos, red y componentes compartidos.
- Escalar = añadir una carpeta nueva en Features (ej. `Search/`) sin tocar el resto.

### Migración

- Mover archivos a la nueva estructura.
- Actualizar imports si hace falta (en un mismo target suele seguir compilando).
- Ajustar referencias en el proyecto de Xcode (grupos y membership del target).

---

## 3. Orden sugerido de implementación

1. **Router y rutas** (sin mover archivos aún):
   - Crear `AppRoute.swift` y `AppRouter.swift`.
   - Inyectar `AppRouter` en el Environment desde el App.
   - Sustituir en HomeScreenView y FavoriteMoviesScreenView la navegación actual por `router.push(...)` y un único `navigationDestination(for: AppRoute.self)` en la vista raíz (donde está el `NavigationStack`).
2. **Comprobar** que el flujo Home → Detalle, Home → Favoritos, Favoritos → Detalle y volver atrás funcionan igual que ahora.
3. **Reorganizar en Features/Core**: mover archivos a las carpetas del plan y actualizar grupos en Xcode.

Si quieres, el siguiente paso puede ser implementar solo el punto 1 (Router + una sola pantalla con coordinación de navegación) en el código actual, sin tocar aún la estructura de carpetas.
