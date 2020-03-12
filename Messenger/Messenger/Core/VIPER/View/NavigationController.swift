//
//  NavigationController.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.

import UIKit

// https://stackoverflow.com/questions/34942571

final class NavigationController: UINavigationController {
    // MARK: - Private Properties

    private let proxy = NavigationProxyDelegate()

    // MARK: - Life Cycle

    public init() {
        super.init(nibName: nil, bundle: nil)
        Logger.shared.verbose(tag: .lifeCycle, object: self)
    }

    deinit {
        Logger.shared.verbose(tag: .lifeCycle, object: self)
    }
    
    @available(*, unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable,
    message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("This view is not compatible to load from a nib/storyboard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Activate swipe gesture to get back
        proxy.originalDelegate = interactivePopGestureRecognizer?.delegate
        proxy.navigationController = self
        interactivePopGestureRecognizer?.delegate = proxy
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }
}

private final class NavigationProxyDelegate: NSObject, UIGestureRecognizerDelegate {
    weak var navigationController: UINavigationController?
    weak var originalDelegate: UIGestureRecognizerDelegate?

    override func responds(to aSelector: Selector!) -> Bool {
        if aSelector == #selector(gestureRecognizer(_:shouldReceive:)) {
            return true
        } else if let responds = originalDelegate?.responds(to: aSelector) {
            return responds
        } else {
            return false
        }
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return originalDelegate
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let nav = navigationController, nav.viewControllers.count > 1 {
            return true
        } else if let result = originalDelegate?.gestureRecognizer?(gestureRecognizer, shouldReceive: touch) {
            return result
        } else {
            return false
        }
    }
}
