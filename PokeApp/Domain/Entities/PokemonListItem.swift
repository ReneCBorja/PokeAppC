//
//  PokemonListItem.swift
//  PokeApp
//
//  Created by WRene B. on 12/4/26.
//

import Foundation

struct PokemonListItem: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let imageURL: URL?
    let types: [PokemonType]
    let stats: [PokemonStat]
    let height: Int
    let weight: Int
    let baseExperience: Int?
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    nonisolated static func == (lhs: PokemonListItem, rhs: PokemonListItem) -> Bool {
        lhs.id == rhs.id
    }
}
