//
//  GradientDemoViewController.swift
//  NavigationBarTransition_Example
//
//  Created by yuanl on 2024/6/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import FSNavigationBarTransition

class GradientDemoViewController: UIViewController {
    // MARK: - Properties
    private var headerView: UIImageView?
    private var configureViewController: DemoConfigureViewController?
    private var currentGradientProgress: CGFloat = 0
    private var progress: CGFloat = 0
    // MARK: - View Model

    // MARK: - State

    // MARK: - Initialization

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dynamic Gradient Bar"
        extendedLayoutIncludesOpaqueBars = true
        
        configureViewController = DemoConfigureViewController()
        guard let configureViewController = configureViewController else { return }
        
        addChildViewController(configureViewController)
        guard let configView = configureViewController.view else { return }
        configView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configView.frame = view.bounds
        view.addSubview(configView)
        configureViewController.didMove(toParentViewController: self)
        
        let tableView = configureViewController.tableView
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never
        headerView = UIImageView(image: UIImage(named: "lakeside_sunset"))
        headerView?.clipsToBounds = true
        headerView?.contentMode = .scaleAspectFill
        if let headerView = headerView, let tableView = tableView {
            view.insertSubview(headerView, aboveSubview: tableView)
        }
                
        let popToRootItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(popToRoot))
        navigationItem.rightBarButtonItem = popToRootItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIXME: 页面加载完成过后，会从导航栏透明状态变成不透明状态，需要修改
        print("GradientDemoViewController 加载完成")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let tableView = configureViewController?.tableView, let headerView = headerView, let headerImage = headerView.image else { return }
        
        let width = self.view.bounds.width
        let imageHeight = headerImage.size.height / (headerImage.size.width) * width
        var headerFrame = headerView.frame
        
        if tableView.contentInset.top == 0 {
            var inset = UIEdgeInsets.zero
            inset.bottom = self.view.safeAreaInsets.bottom
            tableView.scrollIndicatorInsets = inset
            inset.top = imageHeight
            tableView.contentInset = inset
            
            tableView.contentOffset = CGPoint(x: 0, y: -inset.top)
        }
        
        if headerFrame.height != imageHeight {
            headerView.frame = headerImageFrame()
        }
    }
    
  
    // MARK: - UI
  
    // MARK: - Factories
  
    // MARK: - Methods
    @objc private func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func headerImageFrame() -> CGRect {
        guard let tableView = configureViewController?.tableView, let headerView = headerView, let headerImage = headerView.image else { return .zero }
        
        let width = self.view.bounds.width
        guard let headerImage = headerView.image else { return CGRect.zero }
        var imageHeight = headerImage.size.height / headerImage.size.width * width
        
        let contentOffsetY = tableView.contentOffset.y + tableView.contentInset.top
        if contentOffsetY < 0 {
            imageHeight += -contentOffsetY
        }
        
        var headerFrame = self.view.bounds
        if contentOffsetY > 0 {
            headerFrame.origin.y -= contentOffsetY
        }
        headerFrame.size.height = imageHeight
        
        return headerFrame
    }
  
}

extension GradientDemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return configureViewController?.tableView(tableView, heightForRowAt: indexPath) ?? 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        configureViewController?.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = configureViewController?.tableView, let headerView = headerView, let headerImage = headerView.image else { return }
        var headerHeight = headerView.frame.height
        headerHeight -= self.view.safeAreaInsets.top
        
        progress = scrollView.contentOffset.y + scrollView.contentInset.top
        var gradientProgress = min(1, max(0, progress / headerHeight))
        gradientProgress = pow(gradientProgress, 4) // 与 gradientProgress * gradientProgress * gradientProgress * gradientProgress 相同
 
        if gradientProgress != currentGradientProgress {
            currentGradientProgress = gradientProgress
            refreshNavigationBarStyle()
            
            let appearance = self.navigationItem.standardAppearance?.copy()
            if (currentGradientProgress == 1) {
                appearance?.titleTextAttributes = [.foregroundColor: navigationBarTintColor() ?? .clear]
            } else {
                appearance?.titleTextAttributes = [.foregroundColor: UIColor.clear]
            }
            self.navigationItem.standardAppearance = appearance
            self.navigationItem.scrollEdgeAppearance = appearance
        }
        
        headerView.frame = headerImageFrame()
    }
    
    
    
}


extension GradientDemoViewController: NavigationBarConfigureStyle {
    public func navigtionBarConfiguration() -> [FSNavigationBarTransition.NavigationBarConfigurations] {
        var configurations: [NavigationBarConfigurations] = [.show]
        if currentGradientProgress <= 0 {
            configurations.append(.backgroundStyleTransparent)
        } else {
            configurations.append(.backgroundStyleOpaque)
            configurations.append(.backgroundStyleColor)
            //FIXME: 不知道是不是这里的问题，如果添加了 backgroundStyleTransparent ，进入过后，导航拦会透明，但是一直透明，没找到具体的原因
//            configurations.append(.backgroundStyleTransparent)
        }
        return configurations
    }
    
    public func navigationBarTintColor() -> UIColor? {
        return UIColor.init(white: 1 - currentGradientProgress, alpha: 1)
    }
    
    public func navigationBackgroundImageWithIdentifier(_ identifier: String?) -> UIImage? {
        return nil
    }
    
    public func navigationBackgroundColor() -> UIColor? {
        return UIColor.init(white: 1 , alpha: 1 - currentGradientProgress)
    }
}
