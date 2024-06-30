////
////  UIWindow+extension.swift
////  CryptoStatistics
////
////  Created by Dmitry Apenko on 27.06.2024.
////
//
//import UIKit
//
//extension UIWindow {
//
//    func switchRootController(
//        to viewController: UIViewController,
//        animated: Bool,
//        duration: TimeInterval = 0.5,
//        options: AnimationOptions = .transitionFlipFromRight,
//        completion: (() -> Void)? = nil
//    ) {
//        guard animated else {
//            rootViewController = viewController
//            return
//        }
//        UIView.transition(
//            with: self,
//            duration: duration,
//            options: options,
//            animations: {
//                let oldState = UIView.areAnimationsEnabled
//                self.rootViewController = viewController
//                UIView.setAnimationsEnabled(oldState)
//            }, completion: { _ in
//                completion?()
//            })
//    }
//}
