//
//  YPNavigationControllerDelegateProxy.swift
//  NavigationBarTransition
//
//  Created by yuanl on 2024/6/7.
//

import UIKit

class NavigationControllerDelegateProxy: NSObject {
    weak var navigationTarget: UINavigationControllerDelegate?
    unowned var interceptor: FSNavigationController

    init(navigationTarget: UINavigationControllerDelegate?, interceptor: FSNavigationController) {
        self.navigationTarget = navigationTarget
        self.interceptor = interceptor
    }

    private func isIntercepted(selector: Selector) -> Bool {
        return selector == #selector(UINavigationControllerDelegate.navigationController(_:willShow:animated:)) ||
               selector == #selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:))
    }

    override func responds(to aSelector: Selector!) -> Bool {
        if isIntercepted(selector: aSelector) {
            return true
        }
        return (navigationTarget?.responds(to: aSelector) ?? false) || super.responds(to: aSelector)
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if isIntercepted(selector: aSelector) {
            return interceptor
        }
        return navigationTarget
    }
}
