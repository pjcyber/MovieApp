# MovieApp

A small iOS app demo for browsing now-playing movies and managing favorites (SwiftUI + SwiftData).

---

## Architecture

- **Stack:** SwiftUI, SwiftData, async/await. Networking with `URLSession`; API key via environment or Info.plist.
- **Pattern:** MVVM. Views observe ViewModels; services (MovieService, FavoriteMovieService) are behind protocols for testability.
- **Navigation:** Single `AppRouter` (ObservableObject) holds the navigation path. One `NavigationStack(path:)` and one `.navigationDestination(for: AppRoute.self)` at the root; screens call `router.push(.favorites)` or `router.push(.movieDetail(movie))` instead of owning navigation state.
- **Dependencies:** `MovieService` and `FavoriteMovieViewModel` are created in the root and injected via SwiftUI Environment so tests can inject mocks.
- **At scale:** Next step would be grouping by feature (e.g. Features/Home, Features/Favorites) and/or a dedicated module for shared models and services.

### High-level layers

```mermaid
flowchart TB
    subgraph UI["UI Layer"]
        HomeScreenView
        FavoriteMoviesScreenView
        MovieDetailView
        MovieGridItemView
        FavoriteButton
    end

    subgraph ViewModels["ViewModels"]
        MovieViewModel
        FavoriteMovieViewModel
    end

    subgraph Services["Services"]
        MovieService
        FavoriteMovieService
        MovieAPIClient
    end

    subgraph Data["Data / Models"]
        Movie
        MovieResponse
        FavoriteMovie
        SwiftData["SwiftData ModelContext"]
    end

    subgraph Infrastructure["Infrastructure"]
        AppRouter
        AppConfig
        Environment["SwiftUI Environment"]
    end

    HomeScreenView --> MovieViewModel
    HomeScreenView --> FavoriteMovieViewModel
    FavoriteMoviesScreenView --> FavoriteMovieViewModel
    MovieDetailView --> FavoriteMovieViewModel
    MovieViewModel --> MovieService
    FavoriteMovieViewModel --> FavoriteMovieService
    MovieService --> MovieAPIClient
    MovieAPIClient --> Data
    FavoriteMovieService --> SwiftData
    HomeScreenView --> AppRouter
    FavoriteMoviesScreenView --> AppRouter
    MovieDetailView --> AppRouter
    Environment --> HomeScreenView
    Environment --> FavoriteMoviesScreenView
    Environment --> MovieDetailView
```

### Navigation flow

```mermaid
stateDiagram-v2
    [*] --> Home
    Home --> Favorites : Menu → Favorite Movies
    Home --> MovieDetail : Tap movie
    Favorites --> Home : Back
    Favorites --> MovieDetail : Tap movie
    MovieDetail --> Home : Back
    MovieDetail --> Favorites : Back
```

```mermaid
flowchart LR
    subgraph Routes["AppRoute"]
        R1[.home]
        R2[.favorites]
        R3[.movieDetail(Movie)]
    end

    subgraph Screens["Screens"]
        S1[HomeScreenView]
        S2[FavoriteMoviesScreenView]
        S3[MovieDetailView]
    end

    R1 --> S1
    R2 --> S2
    R3 --> S3

    RootView["RootView\nNavigationStack(path: $router.path)"] --> R1
    RootView --> R2
    RootView --> R3
```

### Data flow

```mermaid
flowchart LR
    subgraph Remote["Remote"]
        TMDB[TMDB API]
    end

    subgraph App["MovieApp"]
        MV[MovieViewModel]
        MS[MovieService]
        MC[MovieAPIClient]
        FVM[FavoriteMovieViewModel]
        FMS[FavoriteMovieService]
        SD[(SwiftData)]
    end

    TMDB <--> MC
    MC <--> MS
    MS <--> MV
    MV --> HomeScreenView[HomeScreenView]
    FVM --> FMS
    FMS <--> SD
    FVM --> HomeScreenView
    FVM --> FavoriteMoviesScreenView
    FVM --> MovieDetailView
```

### Dependency injection (root)

```mermaid
flowchart TB
    App[MovieAppApp]
    App --> URLCache
    App --> ModelContainer[ModelContainer\nSwiftData]
    App --> RootView[RootView]

    RootView --> Router[AppRouter\n@StateObject]
    RootView --> FavVM[FavoriteMovieViewModel\n@StateObject]
    RootView --> MovieService[MovieService\nfrom Environment]

    RootView --> Env[.environment]
    Env --> movieService
    Env --> appRouter
    Env --> favoriteMovieViewModel
    Env --> .modelContainer

    HomeScreenView[HomeScreenView] -.-> movieService
    HomeScreenView -.-> appRouter
    HomeScreenView -.-> favoriteMovieViewModel
    FavoriteMoviesScreenView -.-> appRouter
    FavoriteMoviesScreenView -.-> favoriteMovieViewModel
    MovieDetailView -.-> appRouter
    MovieDetailView -.-> favoriteMovieViewModel
```

### Project structure

```mermaid
flowchart TD
    subgraph MovieApp["MovieApp"]
        App[MovieAppApp.swift]
        Config[AppConfig.swift]
        EnvKeys[EnvironmentKeys.swift]
        subgraph Model["Model"]
            Movie[Movie, MovieResponse]
            FavMovie[FavoriteMovie]
            APIErr[MovieAPIError]
        end
        subgraph Navigation["Navigation"]
            AppRoute[AppRoute]
            AppRouter[AppRouter]
        end
        subgraph Services["Services"]
            MovieService[MovieService]
            MovieAPIClient[MovieAPIClient]
            FavoriteMovieService[FavoriteMovieService]
            Protocols[Protocols]
        end
        subgraph View["View"]
            Screens[Screens]
            SubViews[SubViews]
            Modifiers[Modifiers]
        end
        subgraph ViewModels["ViewModels"]
            MovieVM[MovieViewModel]
            FavoriteVM[FavoriteMovieViewModel]
        end
    end
    subgraph Tests["MovieAppTests"]
        UnitTests[Unit tests]
    end
    subgraph UITests["MovieAppUITests"]
        UI[UI tests]
    end
```

## Setup

To run the app, set your [TMDB](https://www.themoviedb.org/) API key:

- **Xcode:** Edit Scheme → Run → Arguments → Environment Variables → add `TMDB_API_KEY` = your key.
- Or add `TMDB_API_KEY` to the app’s Info.plist (do not commit the key to the repo).

<img src="https://github.com/user-attachments/assets/9dac34c7-dd8b-40cc-bd70-323e9ffd5d26" alt="Home screen" width="400" height="800">

<img src="https://github.com/user-attachments/assets/90fe0996-0cdf-4a23-aa1d-02bdfc464eda" alt="Home screen Search filter" width="400" height="800">

