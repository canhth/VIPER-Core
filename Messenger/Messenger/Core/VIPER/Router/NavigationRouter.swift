//
//  NavigationRouter.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

class NavigationRouter: ViewRouter, NavigationRouterInterface {
    private unowned let rootController: UINavigationController
    private var popCompletions: [UIViewController: () -> Void] = [:]

    init(rootController: UINavigationController) {
        self.rootController = rootController
        super.init(rootController: rootController)
        rootController.delegate = self
    }

    override func toController() -> UINavigationController {
        return rootController
    }

    // MARK: - Push & Pop

    func push(_ view: ViewInterface, animated: Bool, hideBottomBar: Bool?, popCompletion: (() -> Void)?) {
        guard validateOnPush(view.toController()) else { return }

        let newController = view.toController()
        if let hideBottomBar = hideBottomBar {
            newController.hidesBottomBarWhenPushed = hideBottomBar
        }

        rootController.pushViewController(newController, animated: animated)
        popCompletions[newController] = popCompletion
    }

    func popView(animated: Bool) {
        if let controller = rootController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }

    // MARK: - Root Module

    func setRootView(_ view: ViewInterface, animated: Bool, hideNavigationBar: Bool?) {
        guard validateOnPush(view.toController()) else { return }

        let newController = view.toController()
        let oldControllers = rootController.viewControllers

        rootController.setViewControllers([newController], animated: animated)
        if let hideNavigationBar = hideNavigationBar {
            rootController.isNavigationBarHidden = hideNavigationBar
        }

        oldControllers.reversed().forEach({ runCompletion(for: $0) })
    }
}

private extension NavigationRouter {
    func runCompletion(for controller: UIViewController) {
        guard let completion = popCompletions[controller] else { return }
        popCompletions.removeValue(forKey: controller)
        completion()
    }

    func validateOnPush(_ controller: UIViewController) -> Bool {
        switch controller {
        case is UINavigationController:
            Logger.shared.warning(object: "can not push \(controller), which is UINavigationController.")
            return false
        default:
            return true
        }
    }
}

extension NavigationRouter: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard
            let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController)
            else { return }
        runCompletion(for: poppedViewController)
    }
}
