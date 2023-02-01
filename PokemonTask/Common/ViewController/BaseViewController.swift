//
//  BaseViewController.swift
//  PokemonTask
//
//  Created by Alexander on 1.02.23.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    func startLoading() {
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
    }
}

