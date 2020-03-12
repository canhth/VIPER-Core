//
//  ViewInterface.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.

import UIKit

public protocol ViewInterface: AnyObject {
    func toController() -> UIViewController
    func showProgressHUD()
    func hideProgressHUD()
}

extension UIViewController: ViewInterface {
    public func toController() -> UIViewController {
        return self
    }
}

public extension ViewInterface {
    func showProgressHUD() {
        Logger.shared.info(object: "Need to show loading HUD here")
    }

    func hideProgressHUD() {
        Logger.shared.info(object: "Need to hide loading HUD here")
    }
}
