//
//  AppCoordinator.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation
import UIKit

protocol AppCoordinatorType {
    func launch()
}


final class AppCoordinator: AppCoordinatorType {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var coordinators: [CoordinatorType] = []
    
    init(window: UIWindow, navigationController: UINavigationController = .init()) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func launch() {
        window.rootViewController = navigationController
        let coordniator = PokemonsListCoordinator(navigationController: navigationController)
        coordniator.start()
        coordinators.append(coordniator)
        navigationController.pushViewController(coordniator.rootViewController, animated: true)
    }
}
