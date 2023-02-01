//
//  PokemonsListViewController.swift
//  PokemonTask
//
//  Created by Alexander on 30.01.23.
//

import UIKit

final class PokemonsListViewController: BaseViewController {
    
    private enum Constants {
        static let loadNextPageOffset: Int = 4
        static let collectionLayoutMultiplyer: CGFloat = 0.4
        static let collectionSectionInset: CGFloat = 25.0
        static let collectionSpacing: CGFloat = 10.0
    }
    
    private var collectionView: UICollectionView!
    private let collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.width * Constants.collectionLayoutMultiplyer
        let height = width
        layout.sectionInset = UIEdgeInsets(top: Constants.collectionSectionInset,
                                           left: Constants.collectionSectionInset,
                                           bottom: Constants.collectionSectionInset,
                                           right: Constants.collectionSectionInset)
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = Constants.collectionSpacing
        layout.minimumInteritemSpacing = Constants.collectionSpacing
        return layout
    }()
    private let viewModel: PokemonsListViewModelType
    private var dataSource: UICollectionViewDiffableDataSource<PokemonsListViewSection, PokemonsListViewSectionItem>!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: PokemonsListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        viewModel.didLoad()
    }
}

private extension PokemonsListViewController {
    
    func setupDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .pokemon(let pokemon):
                let cell = collectionView.dequeue(reusable: PokemonsCollectionViewCell.self, for: indexPath)
                cell.configureCell(pokemon: pokemon)
                return cell
            }
        })
    }
    
    func setupUI() {
        title = "Pokemons"
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(class: PokemonsCollectionViewCell.self)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PokemonsListViewController: ListViewModelDelegate {
    func setLoadingState(_ isLoading: Bool) {
        if isLoading {
            view.isUserInteractionEnabled = false
            startLoading()
        } else {
            view.isUserInteractionEnabled = true
            stopLoading()
        }
    }
    
    func updateWithSnapshot(_ snapshot: PokemonsListViewSnapshot) {
        dataSource.apply(snapshot)
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}

extension PokemonsListViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        let itemsCount = dataSource.snapshot().numberOfItems(inSection: section)
        if itemsCount < indexPath.row + Constants.loadNextPageOffset {
            viewModel.loadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath)
    }

}

