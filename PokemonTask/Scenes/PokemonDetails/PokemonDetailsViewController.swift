//
//  PokemonDetailsViewController.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import Foundation
import UIKit

final class PokemonDetailsViewController: BaseViewController {

    private let tableView = UITableView()
    private let viewModel: PokemonDetailsViewModelType

    private var dataSource: UITableViewDiffableDataSource<PokemonDetailsSection, PokemonDetailsSectionItem>!

    init(viewModel: PokemonDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupUI()
        viewModel.didLoad()
    }
}

private extension PokemonDetailsViewController {

    func setup() {
        dataSource = .init(tableView: tableView, cellProvider: { tableView, _, itemIdentifier in
            switch itemIdentifier {
            case .text(let title, let description):
                let cell = tableView.dequeue(reusable: PokemonDetailsTextViewCell.self)
                cell.configure(with: title, description: description)
                return cell
            case .image(let imageURL):
                let cell = tableView.dequeue(reusable: PokemonDetailsImageViewCell.self)
                cell.configure(with: imageURL)
                return cell
            }
        })
    }

    func setupUI() {
        tableView.delegate = self
        tableView.register(class: PokemonDetailsTextViewCell.self)
        tableView.register(class: PokemonDetailsImageViewCell.self)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension PokemonDetailsViewController: PokemonDetailsViewModelDelegate {
    func updateWithSnapshot(snapshot: PokemonDetailsViewSnapshot) {
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension PokemonDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.snapshot.sectionIdentifiers[indexPath.section]
        let identifier = viewModel.snapshot.itemIdentifiers(inSection: section)[indexPath.row]
        switch identifier {
        case .image:
            return view.frame.width / 2
        case .text:
            return UITableView.automaticDimension
        }
    }
}
