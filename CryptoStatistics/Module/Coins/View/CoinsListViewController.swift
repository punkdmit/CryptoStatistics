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

// MARK: - Screen States
enum CurrentState {
    case loading
    case loaded
    case updated
    case failed
}

// MARK: - Request Reasons
enum RequestReason {
    case firstLoad
    case update
}

// MARK: - CoinsListViewController
final class CoinsListViewController: UIViewController {

    // MARK: Constants

    private enum Constants {
        static let rightBarButtonText = "Logout"
        static let leftBarButtonText = "Sort"
        static let alertControllerTitle = "Sort by"
        static let sortByReducingTitle = "Reducing price changes"
        static let sortByIncreasingTitle = "Increasing price changes"
        static let cancelAction = "Отмена"
    }

    // MARK: Internal properties

    weak var delegate: CoinsListViewControllerDelegate?
    var currentState: CurrentState?

    // MARK: Private properties

    private let coinsListViewModel: CoinsListViewModel?
    private let refreshControl = UIRefreshControl()
    private let alertController = UIAlertController(
        title: Constants.alertControllerTitle,
        message: nil,
        preferredStyle: .actionSheet
    )

    //MARK: UI Elements

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = Assets.Colors.grayLight
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = Assets.Colors.dark
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CoinTableViewCell.self,
            forCellReuseIdentifier: CoinTableViewCell.identifier
        )
        return tableView
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        coinsListViewModel?.fetchCoins(.firstLoad)
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

// MARK: - TableViewDelegate
extension CoinsListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsListViewModel?.convertedCoinsArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.identifier, for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        if let coin = coinsListViewModel?.convertedCoinsArray[indexPath.row] {
            cell.configure(with: coin)
        }
        return cell
    }

    ///чтобы при загрузке не было разделителей и пустых ячеек
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if coinsListViewModel?.convertedCoinsArray[indexPath.row] != nil {
            tableView.separatorStyle = .singleLine
            return UITableView.automaticDimension
        } else {
            tableView.separatorStyle = .none
            return 0
        }
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

    func sortButtonTapped() {
        self.present(alertController, animated: true)
    }

    func refreshControlPulled() {
        coinsListViewModel?.fetchCoins(.update)
    }
}

// MARK: - Private methods
private extension CoinsListViewController {

    func setupUI() {
        configureLayout()
        addRightBarButtonItem()
        addLeftBarButtonItem()
        setupAlertController()
    }

    func configureLayout() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func setupViewModel() {
        coinsListViewModel?.didUpdateCoinsList = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        coinsListViewModel?.switchViewState = { [weak self] state in
            guard let self = self else { return }
            currentState = state
            switch currentState {
            case .loading:
                activityIndicator.startAnimating()
            case .loaded:
                activityIndicator.stopAnimating()
                setupRefreshControl()
            case .updated:
                refreshControl.endRefreshing()
            case .failed:
                break
            case .none:
                break
            }
        }
    }

    func addRightBarButtonItem() {
        let logoutButton = UIBarButtonItem(
            title: Constants.rightBarButtonText,
            style: .done,
            target: self,
            action: #selector(logoutButtonTapped)
        )
        navigationItem.rightBarButtonItem = logoutButton
    }

    func addLeftBarButtonItem() {
        let sortButton = UIBarButtonItem(
            title: Constants.leftBarButtonText,
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        navigationItem.leftBarButtonItem = sortButton
    }

    func setupAlertController() {
        ///убывание
        let sortByReducingAction = UIAlertAction(
            title: Constants.sortByReducingTitle,
            style: .default
        ) { _ in
            self.coinsListViewModel?.sortCoins(by: .reduce)
        }
        ///возрастание
        let sortByIncreasingAction = UIAlertAction(
            title: Constants.sortByIncreasingTitle,
            style: .default
        ) { _ in
            self.coinsListViewModel?.sortCoins(by: .increasing)
        }
        let cancelAction = UIAlertAction(
            title: Constants.cancelAction,
            style: .cancel
        )
        cancelAction.setValue(Assets.Colors.red, forKey: "titleTextColor")
        alertController.addAction(sortByReducingAction)
        alertController.addAction(sortByIncreasingAction)
        alertController.addAction(cancelAction)
    }

    func setupRefreshControl() {
        refreshControl.tintColor = Assets.Colors.grayLight
        refreshControl.addTarget(
            self,
            action: #selector(refreshControlPulled),
            for: .valueChanged
        )
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
}
