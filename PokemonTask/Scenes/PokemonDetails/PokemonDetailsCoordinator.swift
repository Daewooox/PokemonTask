//
//  PokemonDetailsCoordinator.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import Foundation
import UIKit

final class PokemonDetailsCoordinator: NSObject, CoordinatorType {

    private let navigationController: UINavigationController?
    private let pokemon: PokemonModel

    var rootViewController: UIViewController?
    var coordinators: [CoordinatorType] = []

    init(navigationController: UINavigationController?,
         pokemon: PokemonModel) {
        self.navigationController = navigationController
        self.pokemon = pokemon
    }

    func start() {
        let viewModel = PokemonDetailsViewModel(pokemon: pokemon)
        let viewController = PokemonDetailsViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        rootViewController = viewController
    }
}
