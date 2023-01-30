//
//  PokemonsListCoordinator.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation
import UIKit

final class PokemonsListCoordinator: NSObject, CoordinatorType {
    
    private var navigationController: UINavigationController?
    var rootViewController: UIViewController?
    var coordinators: [CoordinatorType] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }

}
