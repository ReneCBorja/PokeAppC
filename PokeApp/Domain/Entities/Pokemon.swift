//
//  Pokemon.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import Foundation

//struct Pokemon: Identifiable {
//    let id: Int
//    let name: String
//    let imageURL: String
//}


// MARK: - Pokemon

struct Pokemon {
    let id: Int
    let name: String
    let imageURL: URL?
    let types: [PokemonType]
    let stats: [PokemonStat]
    let height: Int
    let weight: Int
    let baseExperience: Int?

    var displayName: String { name.capitalized }
    static let generationIRange = 1...151
}

// MARK: - PokemonType

struct PokemonType: Equatable {
    let slot: Int
    let name: String
}

// MARK: - PokemonStat

struct PokemonStat {
    let name: String
    let baseStat: Int
    let effort: Int
}


// MARK: - AppError

enum AppError: Error, Equatable {
    case networkUnavailable
    case invalidResponse
    case pokemonNotFound
    case unknown(String)

    var localizedDescription: String {
        switch self {
        case .networkUnavailable:  return "No internet connection. Please try again."
        case .invalidResponse:     return "Received an unexpected response from the server."
        case .pokemonNotFound:     return "Pokémon not found. Check the name or ID."
        case .unknown(let msg):    return msg
        }
    }
}


struct PokemonSpecies: Decodable {
    let flavor_text_entries: [FlavorTextEntry]
}

struct FlavorTextEntry: Decodable {
    let flavor_text: String
    let language: Language
    let version: Version
}

struct Language: Decodable {
    let name: String
}

struct Version: Decodable {
    let name: String
}
