//
//  PokemonListResponse.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import Foundation

struct PokemonListResponse: Decodable {
    let results: [PokemonDTO]
}

struct PokemonDTO: Decodable {
    let name: String
    let url: String
}
