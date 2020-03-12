//
//  ViewRouter.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

class ViewRouter: NSObject, ViewRouterInterface {

    private unowned let rootController: UIViewController

    init(rootController: UIViewController) {
        self.rootController = rootController
        super.init()
        Logger.shared.verbose(object: "Init viewRowter: \(typeName)")
    }

    deinit {
        Logger.shared.verbose(object: "Deinit viewRowter: \(typeName)")
    }

    func toController() -> UIViewController {
        return rootController
    }
}
