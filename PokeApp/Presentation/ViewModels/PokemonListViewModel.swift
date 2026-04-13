//
//  PokemonListViewModel.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import Foundation
import Combine

final class PokemonListViewModel: ObservableObject {

    @Published var pokemons: [PokemonListItem] = []
    @Published var searchText: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let repo: PokemonRepository

    init(repo: PokemonRepository) {
        self.repo = repo
        fetch()
    }

    func fetch() {

        let limit = 151
        let offset = 0

        repo.fetchPokemonPage(limit: limit, offset: offset)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] value in
                    self?.pokemons = value
                }
            )
            .store(in: &cancellables)
    }

    var filtered: [PokemonListItem] {

        guard !searchText.isEmpty else { return pokemons }

        return pokemons.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            String($0.id) == searchText
        }
    }
}
