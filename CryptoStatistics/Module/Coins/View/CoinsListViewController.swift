//
//  CoinsListViewController.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 27.06.2024.
//

import UIKit

// MARK: - CoinsListViewControllerDelegate
protocol CoinsListViewControllerDelegate: AnyObject {
    func goToAuth()
}

// MARK: - CoinsListViewController
final class CoinsListViewController: UIViewController {

    // MARK: Constants

    private enum Constants {
        static let rightBarButtonText = "Logout"
    }

    // MARK: Internal properties

    weak var delegate: CoinsListViewControllerDelegate?

    // MARK: Private properties

    private let coinsListViewModel: CoinsListViewModel?

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: Initialization

    init(coinsListViewModel: CoinsListViewModel) {
        self.coinsListViewModel = coinsListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - @objc methods
@objc
private extension CoinsListViewController {

    func logoutButtonTapped() {
        delegate?.goToAuth()
    }
}

// MARK: - Private methods
private extension CoinsListViewController {

    func setupUI() {
        view.backgroundColor = .cyan
        addBarButtonItem()
        configureLayout()
    }

    func configureLayout() {

    }

    func addBarButtonItem() {
        let logoutButton = UIBarButtonItem(
            title: Constants.rightBarButtonText,
            style: .done,
            target: self,
            action: #selector(logoutButtonTapped)
        )
        navigationItem.rightBarButtonItem = logoutButton
    }
}
