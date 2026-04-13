//
//  PokemonTypeColor.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import SwiftUI

struct PokemonTypeColor {

    static func color(_ type: String) -> Color {

        switch type.lowercased() {

        case "fire": return .red
            case "water": return .blue
            case "grass": return .green
            case "electric": return .yellow
            case "psychic": return .purple
            case "ice": return .cyan
            case "dragon": return .indigo
            case "dark": return .black
            case "fairy": return .pink
            case "ground": return .brown
            case "rock": return .gray
            case "poison": return .purple
            case "bug": return .green
            case "fighting": return .orange
            case "ghost": return .indigo
            case "normal": return .gray
            case "flying": return .mint
            case "steel": return .gray
            default: return .gray
        }
    }
    
    static  func icon(for type: String) -> String {
        switch type {
        case "fire": return "flame.fill"
           case "water": return "drop.fill"
           case "grass": return "leaf.fill"
           case "electric": return "bolt.fill"
           case "bug": return "ant.fill"
           case "poison": return "bandage.fill"
           case "flying": return "wind"
           case "ground": return "globe"
           case "rock": return "cube.fill"
           case "psychic": return "eye.fill"
           case "ice": return "snowflake"
           case "dragon": return "hare.fill"
           case "dark": return "moon.fill"
           case "steel": return "gear"
           case "fairy": return "sparkles"
           case "fighting": return "figure.boxing"
           case "ghost": return "eye.slash.fill"
           case "normal": return "circle.fill"
           default: return "circle.fill"
        }
    }
    
    static func backgroundColor(for type: String) -> Color {
        color(type).opacity(0.2)
    }
    
}
