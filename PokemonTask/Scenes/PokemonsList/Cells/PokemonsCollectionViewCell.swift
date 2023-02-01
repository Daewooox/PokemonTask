//
//  PokemonsCollectionViewCell.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import UIKit

class PokemonsCollectionViewCell: UICollectionViewCell {
    
    private var titleLabel: UILabel!
    private var imageView: UIImageView!
    private let pokemonService = PokemonsService()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0

        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureCell(pokemon: PokemonModel) {
        if let imageUrl = pokemon.imageURL {
            pokemonService.getPokemonImage(baseUrl: imageUrl, completion: { [weak self] result in
                switch result {
                case .success(let image):
                    self?.imageView.image = image
                case .failure:
                    self?.imageView.image = UIImage(systemName: "xmark")
                }
            })
        } else {
            imageView.image = UIImage(systemName: "xmark")
        }
        titleLabel.text = pokemon.name
    }
}
