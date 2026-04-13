//
//  PokemonDetail.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import Foundation

struct PokemonDetail: Identifiable {
    let id: Int
    let name: String
    let imageURL: String
    let types: [String]
}
