//
//  PokeAppApp.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import SwiftUI
import UIKit

// MAIN IN  SWIFTUI
//@main
//struct PokeAppApp: App {
//    var body: some Scene {
//        let repo = PokemonRepositoryImpl()
//
//        WindowGroup {
//            PokemonListView(vm: PokemonListViewModel(repo: repo))
//        }
//    }
//}

// MAIN IN UIKIT
@main
struct PokeAppApp: App {

    var body: some Scene {

        WindowGroup {

            RootContainer()
        }
    }
}

struct RootContainer: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {

        let repo = PokemonRepositoryImpl()
        let vm = PokemonListViewModel(repo: repo)

        let rootVC = PokemonListViewController(viewModel: vm)

        return UINavigationController(rootViewController: rootVC)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
