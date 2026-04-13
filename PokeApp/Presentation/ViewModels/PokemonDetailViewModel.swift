//
//  PokemonDetailViewModel.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import Foundation
import Combine

final class PokemonDetailViewModel: ObservableObject {

    @Published var pokemon: Pokemon?
    @Published var description: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let repo: PokemonRepository

    init(repo: PokemonRepository) {
        self.repo = repo
    }

    func load(id: Int) {

        let detailPublisher = repo.fetchPokemonDetail(id: id)
        let speciesPublisher = repo.fetchPokemonSpecies(id: id)

        Publishers.CombineLatest(detailPublisher, speciesPublisher)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error:", error)
                }
            } receiveValue: { [weak self] pokemon, description in
                self?.pokemon = pokemon
                self?.description = description
            }
            .store(in: &cancellables)
    }
}
