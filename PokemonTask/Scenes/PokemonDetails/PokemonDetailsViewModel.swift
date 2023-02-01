//
//  PokemonDetailsViewModel.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import Foundation
import UIKit

typealias PokemonDetailsViewSnapshot = NSDiffableDataSourceSnapshot<PokemonDetailsSection, PokemonDetailsSectionItem>

enum PokemonDetailsSection: String, CaseIterable {
    case details
}

enum PokemonDetailsSectionItem: Hashable {
    case image(imageURL: String?)
    case text(title: String, description: String)
}

protocol PokemonDetailsViewModelType {
    var snapshot: PokemonDetailsViewSnapshot! { get }
    func didLoad()
}

protocol PokemonDetailsViewModelDelegate: AnyObject {
    func updateWithSnapshot(snapshot: PokemonDetailsViewSnapshot)
}

final class PokemonDetailsViewModel: PokemonDetailsViewModelType {

    private let pokemon: PokemonModel

    var snapshot: PokemonDetailsViewSnapshot!

    weak var delegate: PokemonDetailsViewModelDelegate?

    init(pokemon: PokemonModel) {
        self.pokemon = pokemon
    }

    func didLoad() {
        var snapshot = PokemonDetailsViewSnapshot()
        snapshot.appendSections([PokemonDetailsSection.details])
        snapshot.appendItems([
            .image(imageURL: pokemon.imageURL),
            .text(title: "Name",
                  description: pokemon.name),
            .text(title: "Weight",
                  description: String(pokemon.weight)),
            .text(title: "Height",
                  description: String(pokemon.height))
        ])
        if let description = pokemon.description {
            snapshot.appendItems([.text(title: "Description", description: description)])
        }
        self.snapshot = snapshot
        delegate?.updateWithSnapshot(snapshot: snapshot)
    }
}

