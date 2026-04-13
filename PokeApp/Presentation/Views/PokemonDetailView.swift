//
//  PokemonDetailView.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import SwiftUI

struct PokemonDetailView: View {

    let id: Int
    @StateObject var vm: PokemonDetailViewModel

    init(id: Int, repo: PokemonRepository) {
        self.id = id
        _vm = StateObject(wrappedValue: PokemonDetailViewModel(repo: repo))
    }

    var body: some View {

        ScrollView {
            VStack(spacing: 20) {

                if let pokemon = vm.pokemon {
                    ZStack(alignment: .bottom) {

                        //  BACKGROUND (mitad inferior)
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(PokemonTypeColor.color(pokemon.types.first?.name ?? "normal"))
                            .frame(height: 180)

                        //  IMAGEN
                        AsyncImage(url: pokemon.imageURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 250, height: 250)
                           .offset(y: -30)
                           .padding(.bottom, 20)
                        
                        HStack {
                            ForEach(pokemon.types, id: \.slot) { type in
                                HStack(spacing: 6) {
                                    
                                    Image(systemName: PokemonTypeColor.icon(for: type.name))
                                    
                                    Text(type.name.uppercased())
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .foregroundColor(PokemonTypeColor.color(type.name))
                                .background(
                                    PokemonTypeColor.color(type.name).mix(with: .white, by: 0.80)

                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(PokemonTypeColor.color(type.name), lineWidth: 1)
                                )
                                .cornerRadius(20)
                              //  .shadow(color: .black.opacity(1), radius: 3, x: 0, y: 1)
                            }
                        }.padding(.vertical)
                    }
                    .frame(height: 150)
                    .padding(.bottom, 30)

                    HeightWeightView(height: pokemon.height, weight: pokemon.weight)
                        .padding()

                    Text(vm.description)
                        .font(.subheadline)
                        .foregroundColor(.customGray3)
                        .padding()
                    
                    StatsSectionView(stats: pokemon.stats)

                } else {
                    ProgressView()
                }
            }
            .padding(.top, 20)

            .padding()
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 20)
        }
      //  .safeAreaPadding(.top, 20)
        .navigationBarBackButtonHidden(true)
        .background(Color.customLightGray)
        .onAppear {
            vm.load(id: id)
        }
    }
}

// MARK: - Height & Weight Card

struct HeightWeightView: View {

    let height: Int
    let weight: Int

    var body: some View {
        HStack(spacing: 0) {
            // PESO
            HStack(spacing: 12) {
                Image("pesoIcon")
            

                VStack(alignment: .leading, spacing: 2) {
                    Text(String(format: "%.1f kg", Double(weight) / 10))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.customBlueDark)
                    Text("Peso")
                        .font(.caption)
                        .foregroundColor(.customBlueDark)
                }
            }
            .frame(maxWidth: .infinity)
            

            // SEPARADOR
            Rectangle()
                .fill(Color.customBlueDark)
                .frame(width: 1, height: 50)

            // ALTURA
            HStack(spacing: 12) {
                Image("rulerIcon")

                VStack(alignment: .leading, spacing: 2) {
                    Text(String(format: "%.1f m", Double(height) / 10))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.customBlueDark)

                    Text("Altura")
                        .font(.caption)
                        .foregroundColor(.customBlueDark)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(16)
    }
}

// MARK: - Stats Section

struct StatsSectionView: View {

    let stats: [PokemonStat]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Estadisticas")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.semibold)
                .foregroundColor(.customBlueDark)
            
            ForEach(stats, id: \.name) { stat in
                StatRowView(stat: stat)
            }
        }
        .padding()
    }
}

// MARK: - Stat Row

struct StatRowView: View {

    let stat: PokemonStat

    private let maxStat: Double = 255

    var body: some View {
        HStack(spacing: 10) {

            Text(stat.name.statDisplayName)
                .font(.caption)
                .foregroundColor(.customGray4)
                .frame(width: 110, alignment: .leading)

            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(statColor(for: stat.baseStat))
                        .opacity(0.2)
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 3)
                        .fill(statColor(for: stat.baseStat))
                        .frame(width: geo.size.width * min(Double(stat.baseStat) / maxStat, 1.0), height: 6)
                }
            }
            .frame(height: 6)
            
            
            Text("\(stat.baseStat)")
                .font(.caption)
                .fontWeight(.medium)
                .frame(width: 28, alignment: .trailing)
                .foregroundColor(.customBlack)
        }
    }

    private func statColor(for value: Int) -> Color {
        switch value {
        case 0..<50:   return .red
        case 50..<80:  return .orange
        case 80..<100: return .yellow
        default:       return .green
        }
    }
}

// MARK: - String Extension

extension String {
    var statDisplayName: String {
        switch self {
        case "hp":              return "HP"
        case "attack":          return "Attack"
        case "defense":         return "Defense"
        case "special-attack":  return "Sp. Attack"
        case "special-defense": return "Sp. Defense"
        case "speed":           return "Speed"
        default:                return self.capitalized
        }
    }
}
