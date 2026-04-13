//
//  PokemonDetailDTO.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import Foundation

struct PokemonDetailDTO: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let base_experience: Int?
    let sprites: Sprites
    let types: [TypeSlot]
    let stats: [StatSlot]

    struct Sprites: Decodable {
        let other: Other

        struct Other: Decodable {
            let home: Home

            struct Home: Decodable {
                let front_default: String?
            }
        }
    }

    struct TypeSlot: Decodable {
        let slot: Int
        let type: TypeInfo
    }

    struct TypeInfo: Decodable {
        let name: String
    }

    struct StatSlot: Decodable {
        let base_stat: Int
        let effort: Int
        let stat: StatInfo
    }

    struct StatInfo: Decodable {
        let name: String
    }
}
