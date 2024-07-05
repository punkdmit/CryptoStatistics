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

    // UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = Assets.Colors.dark
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.identifier)
        return tableView
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.reloadData()
//    }

    // MARK: Initialization

    init(coinsListViewModel: CoinsListViewModel) {
        self.coinsListViewModel = coinsListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - TableViewDelegate

extension CoinsListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsListViewModel?.array.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.identifier, for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        if let coin = coinsListViewModel?.array[indexPath.row] { //MARK: добавить конвертацию в локальную модель блоке if
            cell.configure(with: coin)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        addBarButtonItem()
        configureLayout()
    }

    func configureLayout() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
