//
//  UIWindow+extension.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 27.06.2024.
//

import UIKit

extension UINavigationController {

    func switchRootController(
        to viewController: UIViewController,
        animated: Bool,
        duration: TimeInterval = 0.5,
        options: UIView.AnimationOptions = .transitionFlipFromRight,
        completion: (() -> Void)? = nil
    ) {
        guard let top = topViewController, animated else {
            viewControllers = [viewController]
            return
        }
        UIView.transition(
            with: top.view,
            duration: duration,
            options: options,
            animations: { [self] in
                let oldState = UIView.areAnimationsEnabled
                popViewController(animated: true) // popToRootView
                pushViewController(viewController, animated: true)
                UIView.setAnimationsEnabled(oldState)
            }, completion: { _ in
                completion?()
            })
    }
}
