//
//  UIViewController+Ext.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

public extension UIViewController {
    func validateOnPresent(_ controller: UIViewController) -> Bool {
        switch (controller.presentingViewController, presentedViewController) {
        case (.some(let parent), _):
            Logger.shared.warning(object: "\(controller) is being presented by \(parent) already.")
            return false
        case (_, .some(let child)):
            Logger.shared.warning(object: "`\(self)` is presenting another \(child) already.")
            return false
        default:
            return true
        }
    }
}
