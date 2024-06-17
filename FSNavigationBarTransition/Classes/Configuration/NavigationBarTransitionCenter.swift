//
//  NavigationBarTransitionCenter.swift
//  NavigationBarTransition
//
//  Created by yuanl on 2024/6/6.
//

import UIKit

class NavigationBarTransitionCenter: NSObject, UIToolbarDelegate {
    
    class Context {
        weak var toVC: UIViewController?
    }
    
    static var ctx = Context()
    
    var isTransitionNavigationBar: Bool = false
    
    private var _defaultBarConfigure: BarConfiguration?
    var defaultBarConfigure: BarConfiguration? {
        return _defaultBarConfigure
    }
    
    private var fromViewControllerFakeBar: UIToolbar?
    private var toViewControllerFakeBar: UIToolbar?
    
    init(defaultBarConfiguration: NavigationBarConfigureStyle) {
        super.init()
        _defaultBarConfigure = BarConfiguration(barConfigurationOwner: defaultBarConfiguration)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        guard let currentConfigure = navigationController.navigationBar.currentBarConfigure ?? _defaultBarConfigure else {
            return
        }
        
        var showConfigure = _defaultBarConfigure
        if let owner = viewController as? NavigationBarConfigureStyle {
            showConfigure = BarConfiguration(barConfigurationOwner: owner)
        }
        
        guard let showConfigure = showConfigure else { return }
        
        let navigationBar = navigationController.navigationBar
        let showFakeBar = needShowFakeBar(from: currentConfigure, to: showConfigure)
        
        isTransitionNavigationBar = true
        
        if showConfigure.hidden != navigationController.isNavigationBarHidden {
            navigationController.setNavigationBarHidden(showConfigure.hidden, animated: animated)
        }
        
        var transparentConfigure: BarConfiguration? = nil
        if showFakeBar {
            var transparentConf: [NavigationBarConfigurations] = [NavigationBarConfigurations.configurationsDefault, NavigationBarConfigurations.backgroundStyleTransparent]
            if showConfigure.barStyle == .black {
                transparentConf.append(NavigationBarConfigurations.styleBlack)
            }
            
            transparentConfigure = BarConfiguration.init(configurations: transparentConf,
                                                         tintColor: showConfigure.tintColor,
                                                         backgroundColor: nil,
                                                         backgroundImage: nil,
                                                         backgroundImageIdentifier: nil)
        }
        
        if !showConfigure.hidden {
            navigationBar.apply(barConfiguration: transparentConfigure ?? showConfigure)
        } else {
            navigationBar.adjust(withBarStyle: showConfigure.barStyle, tintColor: currentConfigure.tintColor)
        }
        
        if !animated {
            // If animated if false, navigation controller will call did show immediately
            // So Fake bar is not needed any more
            // just return is ok
            return;
        }
        
        navigationController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (context) in
            guard let self = self else { return }
            
            if showFakeBar {
                fromViewControllerFakeBar = createFakeBar()
                toViewControllerFakeBar = createFakeBar()
                
                UIView.setAnimationsEnabled(false)
                let fromVC = context.viewController(forKey: .from)
                let toVC = context.viewController(forKey: .to)
                
                if let fromVC = fromVC, currentConfigure.isVisible() {
                    let fakeBarFrame = fromVC.fakeBarFrame(for: navigationBar)
                    if !fakeBarFrame.isNull {
                        if let fakeBar = self.fromViewControllerFakeBar {
                            fakeBar.apply(configure: currentConfigure)
                            fakeBar.frame = fakeBarFrame
                            fromVC.view.addSubview(fakeBar)
                        }
                    }
                }
                
                if let toVC = toVC, showConfigure.isVisible() {
                    var fakeBarFrame = toVC.fakeBarFrame(for: navigationBar)
                    if !fakeBarFrame.isNull {
                        if toVC.extendedLayoutIncludesOpaqueBars || showConfigure.translucent {
                            fakeBarFrame.origin.y = toVC.view.bounds.origin.y
                        }
                        
                        if let fakeBar = self.toViewControllerFakeBar {
                            fakeBar.apply(configure: showConfigure)
                            fakeBar.frame = fakeBarFrame
                            toVC.view.addSubview(fakeBar)
                        }
                    }
                }
                
                // 上下文 (ctx) 对象的处理根据你的实际需要可能会有所不同
                

                NavigationBarTransitionCenter.ctx.toVC = toVC
                toVC?.view.addObserver(self, forKeyPath: #keyPath(UIView.bounds), options: [.new, .old], context: &NavigationBarTransitionCenter.ctx)
                toVC?.view.addObserver(self, forKeyPath: #keyPath(UIView.frame), options: [.new, .old], context: &NavigationBarTransitionCenter.ctx)
                
                UIView.setAnimationsEnabled(true)
            }
        }, completion: { [weak self] (context) in
            guard let self = self else { return }
            
            if context.isCancelled {
                self.removeFakeBars()
                navigationBar.apply(barConfiguration: currentConfigure)
                
                if currentConfigure.hidden != navigationController.isNavigationBarHidden {
                    navigationController.setNavigationBarHidden(showConfigure.hidden, animated: animated)
                }
            }
            
            if let toVC = context.viewController(forKey: .to), showFakeBar, NavigationBarTransitionCenter.ctx.toVC == toVC {
                toVC.view.removeObserver(self, forKeyPath: #keyPath(UIView.bounds), context: &NavigationBarTransitionCenter.ctx)
                toVC.view.removeObserver(self, forKeyPath: #keyPath(UIView.frame), context: &NavigationBarTransitionCenter.ctx)
            }
            
            self.isTransitionNavigationBar = false
        })
        
//        if !showFakeBar {
//            navigationBar.apply(barConfiguration: currentConfigure)
//        } else {
//            fromViewControllerFakeBar = createFakeBar()
//            toViewControllerFakeBar = createFakeBar()
//            
//            applyFakeBarConfiguration(to: fromViewControllerFakeBar, with: currentConfigure)
//            applyFakeBarConfiguration(to: toViewControllerFakeBar, with: showConfigure)
//        }
        
        // Adding transition logic and observers as needed
        // This part depends on the implementation details of your transitions and animations
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        removeFakeBars()
        // Apply configurations as needed
        var showConfigure = defaultBarConfigure
        if let owner = viewController as? NavigationBarConfigureStyle {
            showConfigure = BarConfiguration(barConfigurationOwner: owner)
        }
        
        let navigationBar = navigationController.navigationBar
        if let showConfigure = showConfigure {
            navigationBar.apply(barConfiguration: showConfigure)
        }
        
        isTransitionNavigationBar = false
    }
    
    private func createFakeBar() -> UIToolbar {
        let bar = UIToolbar()
        bar.delegate = self
        return bar
    }
    
    private func applyFakeBarConfiguration(to fakeBar: UIToolbar?, with configuration: BarConfiguration) {
        // Your code to apply the configuration to a fake bar
    }
    
    private func removeFakeBars() {
        fromViewControllerFakeBar?.removeFromSuperview()
        toViewControllerFakeBar?.removeFromSuperview()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Your observation logic here
    }
    
    func needShowFakeBar(from: BarConfiguration, to: BarConfiguration) -> Bool {
        var showFakeBar = false
            repeat {
                if from.hidden || to.hidden { break }
                
                if from.transparent != to.transparent ||
                    from.translucent != to.translucent {
                    showFakeBar = true
                    break
                }
                
                if from.useSystemBarBackground() && to.useSystemBarBackground() {
                    showFakeBar = from.barStyle != to.barStyle
                    break
                } else if let fromBackgroundImage = from.backgroundImage, let toBackgroundImage = to.backgroundImage {
                    let fromImageName = from.backgroundImageIdentifier
                    let toImageName = to.backgroundImageIdentifier
                    if let fromImageName = fromImageName, let toImageName = toImageName {
                        showFakeBar = !(fromImageName == toImageName)
                        break
                    }
                    
                    showFakeBar = !(fromBackgroundImage == toBackgroundImage)
                    break
                } else if from.backgroundColor != to.backgroundColor {
                    showFakeBar = true
                    break
                }
            } while false
            
            return showFakeBar
    }

}

extension NavigationBarTransitionCenter: UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }
}

// NOTE: This is a placeholder for a function that determines if a fake bar is needed based on the transition from one configuration to another.
