// MARK: - Favorite Use Case Stubs

struct FavoriteUseCaseStubs {
    
    // Stub for AddFavoriteUseCaseProtocol
    class AddFavoriteUseCaseStub: AddFavoriteUseCaseProtocol {
        private(set) var addedFavorites = Set<Int>()
        
        func execute(giveawayID: Int) {
            addedFavorites.insert(giveawayID)
        }
    }
    
    // Stub for RemoveFavoriteUseCaseProtocol
    class RemoveFavoriteUseCaseStub: RemoveFavoriteUseCaseProtocol {
        private(set) var removedFavorites = Set<Int>()
        
        func execute(giveawayID: Int) {
            removedFavorites.insert(giveawayID)
        }
    }
    
    // Stub for IsFavoriteUseCaseProtocol
    class IsFavoriteUseCaseStub: IsFavoriteUseCaseProtocol {
        private var favorites = Set<Int>()
        
        init(predefinedFavorites: Set<Int> = []) {
            self.favorites = predefinedFavorites
        }
        
        func execute(giveawayID: Int) -> Bool {
            return favorites.contains(giveawayID)
        }
        
        func addFavorite(_ id: Int) {
            favorites.insert(id)
        }
        
        func removeFavorite(_ id: Int) {
            favorites.remove(id)
        }
    }
}