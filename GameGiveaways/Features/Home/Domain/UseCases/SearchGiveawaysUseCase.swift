class SearchGiveawaysUseCase: SearchGiveawaysUseCaseProtocol {
    func execute(giveaways: [GiveawayEntity], query: String) -> [GiveawayEntity] {
        guard !query.isEmpty else { return giveaways }
        
        return giveaways.filter { giveaway in
            giveaway.title.lowercased().contains(query.lowercased()) ||
            giveaway.platforms.lowercased().contains(query.lowercased()) ||
            giveaway.description.lowercased().contains(query.lowercased())
        }
    }
}