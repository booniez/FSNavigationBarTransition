//
//  ViewController.swift
//  NavigationBarTransition
//
//  Created by booniez on 06/06/2024.
//  Copyright (c) 2024 booniez. All rights reserved.
//

import UIKit
import FSNavigationBarTransition

class DemoViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Demo"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let configureViewController = DemoConfigureViewController()
        addChildViewController(configureViewController)
        guard let configView = configureViewController.view else { return }
        configView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configView.frame = view.bounds
        view.addSubview(configView)
        configureViewController.didMove(toParentViewController: self)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension FSNavigationController: NavigationBarConfigureStyle {
    public func navigtionBarConfiguration() -> [FSNavigationBarTransition.NavigationBarConfigurations] {
        return [.styleBlack, .backgroundStyleTranslucent, .backgroundStyleNone]
    }
    
    public func navigationBarTintColor() -> UIColor? {
        return nil
    }
    
    public func navigationBackgroundImageWithIdentifier(_ identifier: String?) -> UIImage? {
        return nil
    }
    
    public func navigationBackgroundColor() -> UIColor? {
        return nil
    }
    
    
}

