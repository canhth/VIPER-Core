//
//  BaseViewController.swift
//  Messenger
//
//  Created by Canh Tran Wizeline on 9/18/19.
//

import UIKit

open class BaseViewController: UIViewController {

    // MARK: - Public Properties

    /// Apply to status bar, affect immediately when change value
    var hideStatusBar: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    // MARK: - Life Cycle

    public init() {
        super.init(nibName: nil, bundle: nil)
        Logger.shared.verbose(tag: .lifeCycle, object: self)
    }

    deinit {
        Logger.shared.verbose(tag: .lifeCycle, object: self)
        hideProgressHUD()
    }
    
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection." )
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("This view is not compatible to load from a nib/storyboard")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    open override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
