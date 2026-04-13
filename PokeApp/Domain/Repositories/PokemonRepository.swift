//
//  PokemonRepository.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import Combine

protocol PokemonRepository {

    func fetchPokemonPage(limit: Int, offset: Int) -> AnyPublisher<[PokemonListItem], Error>
    func fetchPokemonDetail(id: Int) -> AnyPublisher<Pokemon, Error>
    func fetchPokemonSpecies(id: Int) -> AnyPublisher<String, Error>

}
