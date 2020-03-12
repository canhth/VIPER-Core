// 
//  ListUsersViewController.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 3/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class ListUsersViewController: BaseViewController {
    // MARK: - Public Properties

    var presenter: ListUsersPresenterInterface!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
    }

    // MARK: - Setup

    private func setupView() {
    }
}

// MARK: - ListUsersViewInterface

extension ListUsersViewController: ListUsersViewInterface {
}