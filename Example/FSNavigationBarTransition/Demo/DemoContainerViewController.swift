//
//  DemoContainerViewController.swift
//  NavigationBarTransition_Example
//
//  Created by yuanl on 2024/6/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import FSNavigationBarTransition

class DemoContainerViewController: UIViewController {
    // MARK: - Properties
    var configurations: [NavigationBarConfigurations]?
    var tintColor: UIColor?
    var backgroundColor: UIColor?
    var backgroundImage: UIImage?
    var backgroundImageName: String?
    var type: String?
    // MARK: - View Model

    // MARK: - State

    // MARK: - Initialization

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(type ?? "") \(self.navigationController?.viewControllers.count ?? 0)"
        extendedLayoutIncludesOpaqueBars = false
        let configViewController = DemoConfigureViewController()
        addChildViewController(configViewController)
        if let configView = configViewController.view {
            configView.frame = view.bounds
            view.addSubview(configView)
        }
        configViewController.didMove(toParentViewController: self)
        let popToRootItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(popToRoot))
        navigationItem.rightBarButtonItem = popToRootItem
        
    }
  
    // MARK: - UI
  
    // MARK: - Factories
  
    // MARK: - Methods
    @objc private func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
  
}

extension DemoContainerViewController: NavigationBarConfigureStyle {
    public func navigtionBarConfiguration() -> [FSNavigationBarTransition.NavigationBarConfigurations] {
        if let configurations = configurations {
            return configurations
        } else {
            fatalError("需要进行配置")
        }
    }
    
    public func navigationBarTintColor() -> UIColor? {
        return tintColor
    }
    
    public func navigationBackgroundImageWithIdentifier(_ identifier: String?) -> UIImage? {
        return backgroundImage
    }
    
    public func navigationBackgroundColor() -> UIColor? {
        return backgroundColor
    }
}
