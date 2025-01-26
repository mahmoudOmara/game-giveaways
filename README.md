
# 🎮 Game Giveaway App

GameGiveaways is a SwiftUI-based iOS application that allows users to browse and explore giveaways across various gaming platforms. The app follows a Clean Architecture approach with modular feature-based design, ensuring scalability, and maintainability.
## 📖 Table of Contents
- [📂 Project Structure](#-project-structure)
- [🚀 Features Overview](#-features-overview)
- [🏗️ Architecture Overview](#-architecture-overview)
  - [Domain Layer](#domain-layer)
  - [Data Layer](#data-layer)
  - [Presentation Layer](#presentation-layer)
  - [Coordinators](#coordinators)
- [🛠️ Dependency Management](#-dependency-management)
- [🧩 Features Implementation](#-features-implementation)
  - [🏠 Home Feature](#-home-feature)
  - [📄 Giveaway Details Feature](#-giveaway-details-feature)
  - [🔍 More Feature](#-more-feature)
  - [❤️ Favorites Feature](#-favorites-feature)
- [🎨 UI Components](#-ui-components)
- [🧪 Unit Testing](#-unit-testing)
- [🏗️ Coordinators](#-coordinators)
- [📦 Dependency Injection](#-dependency-injection)
- [🔧 Setup Instructions](#-setup-instructions)
- [🚀 Future Enhancements](#-future-enhancements)
## 📂 Project Structure

The project is structured following Clean Architecture, dividing responsibilities into distinct layers:

```
GameGiveaways/
│-- Shared/
│   ├── Networking/
│   ├── Coordinator/
│   ├── SharedData/
│   │   ├── DataSources/
│   │   ├── Models/
│   │   └── Repositories/
│   ├── SharedDomain/
│   │   ├── Entities/
│   │   ├── Repositories/
│   │   └── UseCases/
│   └── SharedPresentation/
│       ├── Views/
│       └── ViewModels/
│-- Core/
│   └── Utilities/
│-- Features/
│   ├── GiveawayDetails/
│   ├── Home/
│   ├── MorePlatforms/
│   └── SharedHomeMore/
│-- Resources/
```
## 🚀 Features Overview
    1.    Home Screen
        • Displays a list of game giveaways.
        • Filters giveaways by platform.
        • Supports searching giveaways locally.
       • Favorites management.
        • Coordinated navigation to details screen.
    2.    Giveaway Details
        •    Provides detailed information about a selected giveaway.
        •    Displays platform, worth, users count, and giveaway description.
        •    Includes a “Get it” button to open the giveaway in an in-app web view.
       • Favorites management.
        • Coordinated navigation to giveawat web screen.
    3.    More Section
        •    Lists giveaways categorized by platforms.
        •    Features a carousel showcasing epic games giveaways.
       • Favorites management.       
        • Coordinated navigation to details screen.
    4.    Favorites Management
        •    Users can mark/unmark giveaways as favorites across the app.
        •    Persistence of favorites using UserDefaults.
        •    Shared across all features.
## 🏗️ Architecture Overview

The app is designed using MVVM (Model-View-ViewModel) with Coordinators for navigation and Factories for dependency injection.

    1. Domain Layer
        •    Entities: Business models such as GiveawayEntity, PlatformEntity, etc.
        •    Use Cases: Business logic encapsulated in use cases like:
        •    GetAllGiveawaysUseCase
        •    GetGiveawaysByPlatformUseCase
        •    SearchGiveawaysUseCase
        •    AddFavoriteUseCase
        •    IsFavoriteUseCase

    2. Data Layer
        •    Repositories: Handles data operations and bridges between domain and data sources.
        •    Data Sources: Manages API calls or local data retrieval.
        •    Models: Structures matching API responses and local data objects.

    3. Presentation Layer
        •    Views: SwiftUI-based UI components.
        •    ViewModels: Handles state management using @Published properties.
    4. Coordinators: Manages navigation flow across the app.

Example UseCase:
```swift
class GetAllGiveawaysUseCase: GetAllGiveawaysUseCaseProtocol {
    private let repository: GiveawaysRepositoryProtocol

    init(repository: GiveawaysRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[GiveawayEntity], Error> {
        return repository.getAllGiveaways()
    }
}
```

Example repository:
```swift
class GiveawaysRepository: GiveawaysRepositoryProtocol {
    private let dataSource: GiveawaysRemoteDataSourceProtocol
    private var storedGiveaways = [GiveawayModel]()

    func getAllGiveaways() -> AnyPublisher<[GiveawayEntity], Error> {
        dataSource.fetchAllGiveaways()
            .map { $0.map { self.convertToDomain($0) } }
            .eraseToAnyPublisher()
    }
}
```

Example ViewModel:
```swift
class GiveawayDetailsViewModel: ObservableObject {
    @Published var state: ViewModelState<GiveawayDetailEntity> = .idle
    private let getGiveawayDetailsUseCase: GetGiveawayDetailsUseCaseProtocol

    func fetchGiveawayDetails() {
        state = .loading
        getGiveawayDetailsUseCase.execute(giveawayID: giveawayID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error.localizedDescription)
                }
            }, receiveValue: { [weak self] details in
                self?.state = .success(details)
            })
            .store(in: &cancellables)
    }
}
```

Example coordinator:
```swift
class HomeCoordinator: HomeCoordinatorProtocol {
    var navigationController: UINavigationController

    func navigateToDetail(giveawayID: Int) {
        let detailsCoordinator = GiveawayDetailsCoordinator(navigationController: navigationController, giveawayID: giveawayID)
        detailsCoordinator.start()
    }
}
```
## 🛠️ Dependency Management

The project utilizes **Swift Package Manager (SPM)** for dependency management. The following dependencies are integrated:

- **CombineMoya** – Networking with Combine and Moya.
- **SwiftLint** – Code style and formatting.
## 🧩 Features Implementation

### 🏠 Home Feature

#### State Management

The `HomeViewModel` manages state using a shared enum `ViewModelState`, which provides a consistent way to represent loading, success, and failure states:

```swift
enum ViewModelState<T> {
    case idle
    case loading
    case success(T)
    case failure(String)
}
```

The Home feature handles user profile and platform loading, filters giveaways by platform, and manages search queries efficiently.

#### Search Functionality

The search functionality is implemented using Combine to provide a debounced search experience, preventing unnecessary calls and improving performance:

```swift
$searchQuery
    .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
    .removeDuplicates()
    .flatMap { query in
        self.searchGiveawaysUseCase.execute(giveaways: self.notSearchedGiveaways, query: query)
    }
    .receive(on: DispatchQueue.main)
    .sink { [weak self] results in
          self?.state = .success(results)
    }
    .store(in: &cancellables)
```

#### Navigation

Navigation to the giveaway details screen is handled via the `HomeCoordinator`, ensuring that navigation logic is separated from the UI:

```swift
func navigateToDetail(giveaway: GiveawayEntity) {
    coordinator.navigateToDetail(giveawayID: giveaway.id)
}
```

### 📄 Giveaway Details Feature

#### State Management

The `GiveawayDetailsViewModel` follows the same `ViewModelState` approach to provide a reactive UI state:

```swift
@Published var state: ViewModelState<GiveawayDetailEntity> = .idle
```

#### Navigation

Giveaway details feature leverages the `GiveawayDetailsCoordinator` for navigation and presenting the web view when the user taps the "Get It" button:

```swift
func openGiveaway() {
   guard
      case let .success(giveaway) = state,
      let url = giveaway.openGiveawayURL else { return }
   coordinator.navigateToGiveawayWebView(with: url)
}
```

#### WebView Integration

A native `WKWebView` is embedded within SwiftUI using `UIViewRepresentable`:

```swift
struct WebViewContainer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
```

---

### 🔍 More Feature

The More feature showcases multiple giveaways categorized by gaming platforms and highlights giveaways from Epic Games.

#### State Management

The `MoreViewModel` handles state using the shared `ViewModelState` enum:

```swift
@Published var state: ViewModelState<MorePlatformsGiveawaysEntity> = .idle
```

#### Use Cases

Fetching giveaways for  Epic Games platform is done using `GetGiveawaysByPlatformUseCase`:

```swift
let epicGamesPublisher = self.getGiveawaysByPlatformUseCase.execute(platform: featuredPlatform.name)
    .catch { _ in Just([]).setFailureType(to: Error.self) }
```

Fetching giveaways for multiple platforms is done using `GetGiveawaysByPlatformsUseCase`:

```swift
let platformsPublisher = self.getGiveawaysByPlatformsUseCase.execute(platforms: remainingPlatforms.map { $0.name })
    .catch { _ in Just([:]).setFailureType(to: Error.self) }
```

#### Carousel Display

A custom rotating carousel effect is implemented for the featured Epic Games section:

```swift
.carouselCard(giveaway: giveaway, index: index)
    .offset(x: cardOffset(for: index))
    .scaleEffect(getScaleAmount(for: index))
    .rotation3DEffect(
        .degrees(rotationAngleX(for: index)),
        axis: (x: 1.0, y: 0.0, z: 0.0),
        perspective: 0.1
    )
    .rotation3DEffect(
        .degrees(rotationAngleZ(for: index)),
        axis: (x: 0.0, y: 0.0, z: 1.0)
    )
```

### ❤️ Favorites Feature

The Favorites feature allows users to mark giveaways as favorites, which are accessible across the entire app.

#### State Management

Each `GiveawayCardViewModel` contains logic to check and toggle the favorite state:

```swift
@Published var isFavorited: Bool
```

#### Use Cases

Favorite management is implemented through use cases:

```swift
addFavoriteUseCase.execute(giveawayID: giveaway.id)
removeFavoriteUseCase.execute(giveawayID: giveaway.id)
isFavorited = isFavoriteUseCase.execute(giveawayID: giveaway.id)
```

#### Button Action in Giveaway Card

```swift
Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
    .highPriorityGesture(
          TapGesture().onEnded({
             UIImpactFeedbackGenerator(style: .light).impactOccurred()
             viewModel.toggleFavorite()
          })
    )
```
## 🎨 UI Components

This section covers the reusable UI components implemented in the app.

- **StateDrivenView:** Handles loading, empty, success, and failure states for different screens using the shared `ViewModelState` enum.
  ```swift
  struct StateDrivenView<Content: View, DataType>: View {
      let state: ViewModelState<DataType>
      let loadingMessage: String
      let retryAction: (() -> Void)?
      let content: (DataType) -> Content

      var body: some View {
          switch state {
          case .idle, .loading:
              LoadingView(message: loadingMessage)

          case .success(let data):
              content(data)

          case .failure(let error):
              ErrorView(message: error, retryAction: retryAction)
          }
      }
  }
  ```

- **GiveawayCard:** A customizable card view used across the app with different styles and layout options.
  ```swift
  GiveawayCard(
      viewModel: GiveawayCardViewModel(
          giveaway: giveaway,
          addFavoriteUseCase: viewModel.addFavoriteUseCase,
          removeFavoriteUseCase: viewModel.removeFavoriteUseCase,
          isFavoriteUseCase: viewModel.isFavoriteUseCase
      ),
      style: .large,
      favoriteButtonPlacement: .topTrailing,
      showPlatforms: true,
      showDescription: true
  )
  ```

    *Customization Options:
    - `style`: `.large`, `.medium`, `.small`
    - `favoriteButtonPlacement`: `.topTrailing`, `.bottomTrailing`, `.none`
    - `showPlatforms`: Bool
    - `showDescription`: Bool

- **RotatingCarouselView:** Custom 3D rotating carousel for displaying featured giveaways.
  ```swift
  struct RotatingCarouselView: View {
      @ObservedObject private var viewModel: MoreViewModel

      let giveaways: [GiveawayEntity]
      @State private var currentIndex: Int = 0
      @State private var dragOffset: CGFloat = 0
      private let cardWidth: CGFloat = 300
      private let spacing: CGFloat = 40

      var body: some View {
          VStack(spacing: 10) {
              carouselStack
              indexIndicator
          }
  }
  ```

- **WebView:** In-app browser to view giveaways using `WKWebView`.
  ```swift
  struct GiveawayWebView: View {
      let url: URL
      @Environment(\.presentationMode) var presentationMode

      var body: some View {
        NavigationView {
            WebViewContainer(url: url)
                .navigationBarItems(leading: closeButton)
        }
      }
  }

  struct WebViewContainer: UIViewRepresentable {
      let url: URL

      func makeUIView(context: Context) -> WKWebView {
          let webView = WKWebView()
          let request = URLRequest(url: url)
          webView.load(request)
          return webView
      }

      func updateUIView(_ uiView: WKWebView, context: Context) {}
  }
  ```

- **EmptyStateView:** Displays an informative message when there is no data available.
  ```swift
  struct EmptyStateView: View {
      let message: String
      let systemImageName: String
      let actionTitle: String
      var tintColor: Color = .accentColor
      let action: () -> Void

      var body: some View {
          VStack {
              Image(systemName: systemImageName)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 80, height: 80)
                  .foregroundColor(tintColor)
              Text(message)
                  .font(.headline)
                  .foregroundColor(.gray)
                  .multilineTextAlignment(.center)
                  .padding(.horizontal, 30)
              if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(tintColor)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 50)
            }
          }
          .padding()
      }
  }
  ```

- **ErrorView:** Displays an error message with an optional retry action.
  ```swift
  struct ErrorView: View {
      let message: String
      var tintColor: Color = .accentColor
      let retryAction: (() -> Void)?

      var body: some View {
          VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(tintColor)
                .padding(.top, 20)
            
            Text("Oops! Something went wrong")
                .multilineTextAlignment(.center)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text("Retry")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 44)
                        .background(tintColor)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
        }
          .padding()
      }
  }
  ```

- **LoadingView:** Displays a loading spinner with an optional message.
  ```swift
  struct LoadingView: View {
      let message: String
      var tintColor: Color = .accentColor
      var scale: CGFloat = 1.5

      var body: some View {
          VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
                .scaleEffect(scale)
            
            if let message = message {
                Text(message)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
          .padding()
      }
  }
  ```
## 🧪 Unit Testing
The project is 61% covered with unit tests using XCTest and Combine testing techniques to verify functionality.

#### Example Test for Home ViewModel

```swift
func testLoadGiveawaysSuccess() {
    let expectation = XCTestExpectation(description: "Successfully loaded giveaways")
    viewModel.$state
        .dropFirst(2)
        .sink { state in
        if case .success(let giveaways) = state {
                XCTAssertEqual(giveaways.count, 1)
                XCTAssertEqual(giveaways.first?.title, "Test Giveaway")
                expectation.fulfill()
            case .failure, .loading, .idle:
                XCTFail("Expected success state")
            }
    }
    .store(in: &cancellables)
    viewModel.platformFilter = .all
    wait(for: [expectation], timeout: 5.0)
}
```
## 🏗️ Coordinators

All features utilize the coordinator pattern for navigation to separate concerns:

```swift
protocol HomeCoordinatorProtocol {
    var navigationController: UINavigationController { get }
    func start()
    func navigateToDetail(giveawayID: Int)
    func navigateToMorePlatforms()
}

class HomeCoordinator: HomeCoordinatorProtocol {
    func navigateToDetail(giveawayID: Int) {
        let detailsCoordinator = GiveawayDetailsCoordinator(navigationController: navigationController, giveawayID: giveawayID)
        detailsCoordinator.start()
    }
}
```
## 📦 Dependency Injection

Factories are used to create feature-specific views and inject dependencies.

Example factory:
```swift
struct GiveawayDetailsViewFactory {
    static func createGiveawayDetailsView(giveawayID: Int, coordinator: GiveawayDetailsCoordinatorProtocol) -> some View {
        let favoritesLocalDataSource = FavoritesLocalDataSource()

        let giveawaysRepository = SharedFactory.getSharedGiveawaysRepository()
        let favoritesRepository = FavoritesRepository(dataSource: favoritesLocalDataSource)

        let getGiveawayDetailsUseCase = GetGiveawayDetailsUseCase(repository: giveawaysRepository)
        let addFavoriteUseCase = AddFavoriteUseCase(repository: favoritesRepository)
        let removeFavoriteUseCase = RemoveFavoriteUseCase(repository: favoritesRepository)
        let isFavoriteUseCase = IsFavoriteUseCase(repository: favoritesRepository)
        
        let viewModel = GiveawayDetailsViewModel(
            giveawayID: giveawayID,
            getGiveawayDetailsUseCase: getGiveawayDetailsUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase,
            coordinator: coordinator)
        
        let view = GiveawayDetailsView(viewModel: viewModel)
        return view
    }
}

```
## 🔧 Setup Instructions

1. **Clone the repository:**
    ```bash
    git clone https://github.com/mahmoudOmara/game-giveaways.git
    cd game-giveaways
    ```

2. **Open the project in Xcode:**
    ```bash
    open GameGiveaways.xcodeproj
    ```

3. **Install dependencies:**

4. **Build and Run the project:**
   - Select `GameGiveaways` scheme and run the app using `⌘ + R`.
## 🚀 Future Enhancements

- Introduce a **Favorites Screen** to allow users to view and manage their favorite giveaways.
- Enhance the **UI experience** by incorporating smooth animations and transitions.
- Implement **Dark Mode** support to improve accessibility and user experience.
- Optimize the app for **iPad displays**, ensuring a responsive and adaptive layout.
- Integrate **image caching** to reduce network usage and enhance performance.
- Expand **unit test coverage** to ensure robust and reliable code quality.
    
