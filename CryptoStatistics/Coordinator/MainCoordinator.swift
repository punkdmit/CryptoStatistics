//
//  MainCoordinator.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 23.06.2024.
//

import UIKit

final class MainCoordinator: Coordinator {

  var childCoordinators: [any Coordinator] = []
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start(in window: UIWindow) {
    let authViewController = AuthViewController()
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    navigationController.pushViewController(authViewController, animated: true)
  }
}
