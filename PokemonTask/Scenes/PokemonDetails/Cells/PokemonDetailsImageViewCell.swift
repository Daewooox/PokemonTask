//
//  PokemonDetailsImageViewCell.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import Foundation
import UIKit

final class PokemonDetailsImageViewCell: UITableViewCell {
    private var pokemonImageView: UIImageView!
    private let pokemonService = PokemonsService()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageURL: String?) {
        guard let imageURL = imageURL else {
            pokemonImageView.image = UIImage(systemName: "xmark")
            return
        }
        
        pokemonService.getPokemonImage(baseUrl: imageURL, completion: { [weak self] result in
            switch result {
            case .success(let image):
                self?.pokemonImageView.image = image
            case .failure:
                self?.pokemonImageView.image = UIImage(systemName: "xmark")
            }
        })
    }
    
    private func setup() {
        selectionStyle = .none
        pokemonImageView = UIImageView()
        pokemonImageView.contentMode = .scaleAspectFill
        pokemonImageView.clipsToBounds = true
        contentView.addSubview(pokemonImageView)
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pokemonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

