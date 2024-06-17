//
//  UINavigationBar+Extension.swift
//  NavigationBarTransition
//
//  Created by yuanl on 2024/6/6.
//

import Foundation


import UIKit

// MARK: - Configure Extension for UINavigationBar
extension UINavigationBar {
    private struct AssociatedKeys {
        static var currentBarConfigure = "currentBarConfigure"
    }
    
    var currentBarConfigure: BarConfiguration? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.currentBarConfigure) as? BarConfiguration
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.currentBarConfigure, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func adjust(withBarStyle barStyle: UIBarStyle, tintColor: UIColor) {
        self.barStyle = barStyle
        self.tintColor = tintColor
        let appearance = self.standardAppearance.copy()
        if (barStyle == .black) {
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        } else {
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
    }
    
    var backgroundView: UIView? {
        return self.value(forKey: "_backgroundView") as? UIView
    }
    
    func apply(barConfiguration configure: BarConfiguration) {
        self.adjust(withBarStyle: configure.barStyle, tintColor: configure.tintColor)
        
        let barBackgroundView = self.backgroundView
        let transparentImage = UIImage.transparentImage()
        
        if configure.transparent {
            barBackgroundView?.alpha = 0
            if #available(iOS 13.0, *) {
                let appearance = self.standardAppearance.copy() 
                appearance.configureWithTransparentBackground()
                self.scrollEdgeAppearance = appearance
                self.standardAppearance = appearance
            } else {
                self.isTranslucent = true
                self.setBackgroundImage(transparentImage, for: .default)
            }
        } else {
            barBackgroundView?.alpha = 1
            if #available(iOS 13.0, *) {
                let appearance = self.standardAppearance.copy() 
                if configure.translucent {
                    appearance.configureWithDefaultBackground()
                    let effectStyle = configure.barStyle == .default ? UIBlurEffect.Style.light : UIBlurEffect.Style.dark
                    appearance.backgroundEffect = UIBlurEffect(style: effectStyle)
                } else {
                    appearance.configureWithOpaqueBackground()
                }
                if let backgroundImage = configure.backgroundImage {
                    appearance.backgroundImage = backgroundImage
                } else if let backgroundColor = configure.backgroundColor {
                    appearance.backgroundImage = UIImage.image(withColor: backgroundColor)
                }
                if !configure.shadowImage {
                    appearance.shadowImage = nil
                    appearance.shadowColor = nil
                }
                self.scrollEdgeAppearance = appearance
                self.standardAppearance = appearance
            } else {
                self.isTranslucent = configure.translucent
                var backgroundImage = configure.backgroundImage
                if backgroundImage == nil, let backgroundColor = configure.backgroundColor {
                    backgroundImage = UIImage.image(withColor: backgroundColor)
                }
                self.setBackgroundImage(backgroundImage, for: .default)
            }
        }
        
        self.shadowImage = configure.shadowImage ? nil : transparentImage
        
        self.currentBarConfigure = configure
    }
}
