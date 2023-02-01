//
//  PokemonsListViewModel.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import Foundation
import UIKit

typealias PokemonsListViewSnapshot = NSDiffableDataSourceSnapshot<PokemonsListViewSection, PokemonsListViewSectionItem>

enum PokemonsListViewSection: String, CaseIterable {
    case list
}

enum PokemonsListViewSectionItem: Hashable {
    case pokemon(pokemon: PokemonModel)
}

protocol PokemonsListViewModelType {
    func didLoad()
    func didSelectCell(at indexPath: IndexPath)
    func loadNextPage()
}

protocol ListViewModelDelegate: AnyObject {
    func setLoadingState(_ isLoading: Bool)
    func updateWithSnapshot(_ snapshot: PokemonsListViewSnapshot)
    func displayError(message: String)
}

protocol PokemonsListViewModelNavigationDelegate: AnyObject {
    func showDetails(for pokemon: PokemonModel)
}

final class PokemonsListViewModel: PokemonsListViewModelType {
    
    private let pokemonService: PokemonsServiceType
    private var snapshot: PokemonsListViewSnapshot!
    private var nextPage: String?
    
    weak var delegate: ListViewModelDelegate?
    weak var navigationDelegate: PokemonsListViewModelNavigationDelegate?
    
    init(pokemonService: PokemonsServiceType) {
        self.pokemonService = pokemonService
    }
    
    func didLoad() {
        delegate?.setLoadingState(true)
        getPokemonsNextPage()
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let items = snapshot.itemIdentifiers(inSection: .list)
        let selectedItem = items[indexPath.row]
        guard case var .pokemon(pokemon) = selectedItem else { return }
        delegate?.setLoadingState(true)
        pokemonService.getPokemonDescription(pokemon: pokemon) { [weak self] result in
            self?.delegate?.setLoadingState(false)
            switch result {
            case .success(let response):
                guard let description = response.flavorEntries.first?.description.replacingOccurrences(of: "\n", with: " ") else { return }
                self?.navigationDelegate?.showDetails(for: PokemonModel(id: pokemon.id, name: pokemon.name,
                                                                        weight: pokemon.weight, height: pokemon.height,
                                                                        imageURL: pokemon.imageURL, speciesURL: pokemon.speciesURL,
                                                                        description: description))
            case .failure(let error):
                self?.delegate?.displayError(message: error.description)
            }
        }
    }
    
    func loadNextPage() {
        getPokemonsNextPage()
    }
    
    private func getPokemonsNextPage() {
        delegate?.setLoadingState(true)
        pokemonService.getPokemonsList(nextPage: nextPage) { [weak self] response in
            switch response {
            case .success(let response):
                self?.makeSnapshotAndApply(pokemons: response.pokemons)
                self?.nextPage = response.nextPage
            case .failure(let error):
                self?.makeSnapshotAndApply(pokemons: [])
                self?.delegate?.displayError(message: error.description)
            }
            self?.delegate?.setLoadingState(false)
        }
    }
    
    private func makeSnapshotAndApply(pokemons: [PokemonModel]) {
        if snapshot == nil {
            var snapshot = PokemonsListViewSnapshot()
            snapshot.appendSections([.list])
            self.snapshot = snapshot
        }
        snapshot.appendItems(pokemons.map { .pokemon(pokemon: $0) }, toSection: .list)
        delegate?.updateWithSnapshot(snapshot)
    }
}

