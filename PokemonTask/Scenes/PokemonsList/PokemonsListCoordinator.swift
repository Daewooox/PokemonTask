//
//  PokemonsListCoordinator.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation
import UIKit

final class PokemonsListCoordinator: NSObject, CoordinatorType, UINavigationControllerDelegate {
    
    private var navigationController: UINavigationController?
    var rootViewController: UIViewController?
    var coordinators: [CoordinatorType] = []
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController?.delegate = self
        
        let viewModel = PokemonsListViewModel(pokemonService: PokemonsService())
        let viewController = PokemonsListViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        viewModel.navigationDelegate = self
        
        rootViewController = viewController
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        coordinators.forEach {
            if $0.rootViewController === fromViewController {
                removeCoordinator($0)
            }
        }
    }
}

extension PokemonsListCoordinator: PokemonsListViewModelNavigationDelegate {
    func showDetails(for movie: PokemonModel) {
        let detailsCoordinator = PokemonDetailsCoordinator(navigationController: navigationController, pokemon: movie)
        detailsCoordinator.start()
        addCoordinator(detailsCoordinator)
        navigationController?.pushViewController(detailsCoordinator.rootViewController!, animated: true)
    }
}
