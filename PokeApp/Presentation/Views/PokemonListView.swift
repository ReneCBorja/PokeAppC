//
//  PokemonListView.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import SwiftUI

struct PokemonListView: View {

    @StateObject var vm: PokemonListViewModel

    var body: some View {
        NavigationView {

            VStack {

                TextField("Search by name or ID", text: $vm.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                List(vm.filtered) { pokemon in

                    NavigationLink(
                        destination: PokemonDetailView(
                            id: pokemon.id,
                            repo: PokemonRepositoryImpl()
                        )
                    ) {
                        HStack {
                            AsyncImage(url: pokemon.imageURL)
                                .frame(width: 50, height: 50)

                            Text(pokemon.name)
                        }
                    }
                }
            }
            .navigationTitle("Pokédex")
        }
    }
}
