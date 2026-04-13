//
//  PokemonRepositoryImpl.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import Foundation
import Combine

final class PokemonRepositoryImpl: PokemonRepository {

    private let baseURL = "https://pokeapi.co/api/v2"

    // MARK: - PAGINATED FETCH
    func fetchPokemonPage(limit: Int, offset: Int) -> AnyPublisher<[PokemonListItem], Error> {

        let url = URL(string: "\(baseURL)/pokemon?limit=\(limit)&offset=\(offset)")!

        return APIClient.shared.request(url)
            .flatMap { (response: PokemonListResponse) -> AnyPublisher<[PokemonListItem], Error> in

                let publishers = response.results.enumerated().map { index, _ -> AnyPublisher<PokemonListItem, Error> in

                    let id = offset + index + 1
                    let detailURL = URL(string: "\(self.baseURL)/pokemon/\(id)")!

                    let detailPublisher: AnyPublisher<PokemonDetailDTO, Error> = APIClient.shared.request(detailURL)

                    return detailPublisher
                        .tryMap { dto -> PokemonListItem in
                            PokemonListItem(
                                id: dto.id,
                                               name: dto.name,
                                               imageURL: URL(string: dto.sprites.other.home.front_default ?? ""),
                                               types: dto.types.map { PokemonType(slot: $0.slot, name: $0.type.name) },
                                               stats: dto.stats.map { PokemonStat(name: $0.stat.name, baseStat: $0.base_stat, effort: $0.effort) },
                                               height: dto.height,
                                               weight: dto.weight,
                                               baseExperience: dto.base_experience
                            )
                        }
                        .eraseToAnyPublisher()
                }

                return Publishers.MergeMany(publishers)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    // MARK: - DETAIL (NO CHANGE)
    func fetchPokemonDetail(id: Int) -> AnyPublisher<Pokemon, Error> {

            let url = URL(string: "\(baseURL)/pokemon/\(id)")!

            let publisher: AnyPublisher<PokemonDetailDTO, Error> = APIClient.shared.request(url)

            return publisher
                .tryMap { dto -> Pokemon in
                    Pokemon(
                        id: dto.id,
                        name: dto.name,
                        imageURL: URL(string: dto.sprites.other.home.front_default ?? ""),
                        types: dto.types.map { PokemonType(slot: $0.slot, name: $0.type.name) },
                        stats: dto.stats.map { PokemonStat(name: $0.stat.name, baseStat: $0.base_stat, effort: $0.effort) },
                        height: dto.height,
                        weight: dto.weight,
                        baseExperience: dto.base_experience
                    )
                }
                .eraseToAnyPublisher()
        }
    
    func fetchPokemonSpecies(id: Int) -> AnyPublisher<String, Error> {

        let url = URL(string: "\(baseURL)/pokemon-species/\(id)")!

        let publisher: AnyPublisher<PokemonSpecies, Error> = APIClient.shared.request(url)

        return publisher
            .map { species in
                species.flavor_text_entries.first(where: {
                    $0.language.name == "es"
                   // && $0.version.name == "red"
                })?
                .flavor_text
                .replacingOccurrences(of: "\n", with: " ")
                //.replacingOccurrences(of: "\f", with: " ")
                ?? "Sin descripción"
            }
            .eraseToAnyPublisher()
    }
}
