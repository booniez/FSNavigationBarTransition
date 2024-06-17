//
//  UIViewController+Extension.swift
//  NavigationBarTransition
//
//  Created by yuanl on 2024/6/6.
//

import Foundation

extension UIViewController {
    
    func navigationBar() -> UINavigationBar? {
        return (self as? UINavigationController)?.navigationBar ?? self.navigationController?.navigationBar
    }
    
    func hasCustomNavigationBarStyle() -> Bool {
        // 实现细节
        return self is NavigationBarConfigureStyle
    }
    
    public func refreshNavigationBarStyle() {
        // 实现细节
        assert(self.hasCustomNavigationBarStyle(), "Object does not conform to NavigationBarConfigureStyle")
        
        guard let navigationBar = self.navigationBar() else { return }
        if navigationBar.topItem == self.navigationItem {
            if let owner = self as? NavigationBarConfigureStyle {
                if let self = self as? NavigationBarConfigureStyle {
                    let configuration = BarConfiguration(barConfigurationOwner: self)
                    navigationBar.apply(barConfiguration: configuration)
                }
            }
        }
    }
    
    func fakeBarFrame(for navigationBar: UINavigationBar) -> CGRect {
        // 实现细节
        guard let backgroundView = navigationBar.backgroundView else { return CGRect.null }
        var frame = self.view.convert(backgroundView.frame, from: backgroundView.superview)
        frame.origin.x = self.view.bounds.origin.x
        return frame
    }
}
