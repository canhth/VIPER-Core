//
//  RouterInterface.swift
//  Apollo
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

// MARK: - Normal View Router

/// Handle normal UIViewController as root, with present & dismiss
public protocol ViewRouterInterface: ViewInterface {
    /// Determine if router can present a new view
    func canPresentNewView() -> Bool
    func present(_ view: ViewInterface, animated: Bool, completion: (() -> Void)?)
    func dismissView(animated: Bool, completion: (() -> Void)?)

    func showAlert(title: String?, message: String, actions: [UIAlertAction])
}

extension ViewRouterInterface {
    func canPresentNewView() -> Bool {
        return toController().presentedViewController != nil
    }

    func present(_ view: ViewInterface, animated: Bool, completion: (() -> Void)? = nil) {
        guard toController().validateOnPresent(view.toController()) else { return }
        toController().present(view.toController(), animated: animated, completion: completion)
    }

    func dismissView(animated: Bool, completion: (() -> Void)? = nil) {
        toController().dismiss(animated: animated, completion: completion)
    }

    // MARK: - Alert

    func showAlert(title: String? = nil, message: String, actions: [UIAlertAction] = []) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Need at least 1 action to dismiss the alert
        if actions.isEmpty {
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            actions.forEach { alertController.addAction($0) }
        }
        present(alertController, animated: true)
    }
}

// MARK: - Window Router

/// Handle main UIWindow and its root view controller.
public protocol WindowRouterInterface: ViewRouterInterface {
    var window: UIWindow { get }
    var rootView: ViewInterface { get set }
}

// MARK: - Navigation Router

/// Handle UINavigationController as root, with push & pop
public protocol NavigationRouterInterface: ViewRouterInterface {
    func toController() -> UINavigationController

    func push(_ view: ViewInterface, animated: Bool, hideBottomBar: Bool?, popCompletion: (() -> Void)?)
    func popView(animated: Bool)

    func setRootView(_ view: ViewInterface, animated: Bool, hideNavigationBar: Bool?)
}

extension NavigationRouterInterface {
    func push(_ view: ViewInterface, animated: Bool, hideBottomBar: Bool? = nil, popCompletion: (() -> Void)? = nil) {
        push(view, animated: animated, hideBottomBar: hideBottomBar, popCompletion: popCompletion)
    }

    func setRootView(_ view: ViewInterface, animated: Bool, hideNavigationBar: Bool? = nil) {
        setRootView(view, animated: animated, hideNavigationBar: hideNavigationBar)
    }
}
