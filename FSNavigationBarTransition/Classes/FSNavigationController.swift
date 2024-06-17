//
//  NavigationController.swift
//  NavigationBarTransition
//
//  Created by yuanl on 2024/6/7.
//

import UIKit

open class FSNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    var center: NavigationBarTransitionCenter!
    weak var navigationDelegate: UINavigationControllerDelegate?
    var delegateProxy: NavigationControllerDelegateProxy?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // see YPNavigationController+Configure.swift in Example Project
        assert(self is NavigationBarConfigureStyle,
               "you must implement NavigationBarConfigureStyle for NavigationController in subclass or extension")
        
        if let self = self as? NavigationBarConfigureStyle {
            center = NavigationBarTransitionCenter(defaultBarConfiguration: self)
        }
        if delegate == nil {
            delegate = self
        }
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public override var delegate: UINavigationControllerDelegate? {
            get {
                return super.delegate
            }
            set {
                if newValue is FSNavigationController || newValue == nil {
                    navigationDelegate = nil
                    delegateProxy = nil
                    super.delegate = self
                } else {
                    navigationDelegate = newValue
                    delegateProxy = NavigationControllerDelegateProxy(navigationTarget: navigationDelegate, interceptor: self)
                    if let delegateProxy = delegateProxy as? UINavigationControllerDelegate {
                        super.delegate = delegateProxy
                    }
                }
            }
        }
    
    // MARK: - UINavigationControllerDelegate
    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
        center.navigationController(navigationController, willShow: viewController, animated: animated)
    }
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
        center.navigationController(navigationController, didShow: viewController, animated: animated)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === interactivePopGestureRecognizer {
            if let gestureRecognizer = gestureRecognizer as? UIScreenEdgePanGestureRecognizer, center.isTransitionNavigationBar {
                return false
            }
            return viewControllers.count > 1
        }
        
        return true
    }
}
