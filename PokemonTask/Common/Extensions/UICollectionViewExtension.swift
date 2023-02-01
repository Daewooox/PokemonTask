//
//  UITableViewExtension.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import Foundation
import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(class identifier: T.Type) {
        let identifierString = String(describing: identifier)
        register(T.self, forCellWithReuseIdentifier: identifierString)
    }

    func dequeue<T: UICollectionViewCell>(reusable identifier: T.Type, for indexPath: IndexPath) -> T {
        let identifierString = String(describing: identifier)
        return dequeueReusableCell(withReuseIdentifier: identifierString, for: indexPath) as! T
    }
}
