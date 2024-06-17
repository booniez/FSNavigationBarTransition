//
//  UIToolbar+Extension.swift
//  NavigationBarTransition
//
//  Created by yuanl on 2024/6/6.
//

import UIKit

extension UIToolbar {
    
    func apply(configure: BarConfiguration) {
        self.barStyle = configure.barStyle
        
        let transparentImage = UIImage.transparentImage()
        if configure.transparent {
            let appearance = self.standardAppearance.copy()
            appearance.configureWithTransparentBackground()

            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
            self.standardAppearance = appearance
        } else {
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
                appearance.backgroundColor = backgroundColor
            }
            if !configure.shadowImage {
                appearance.shadowImage = nil
                appearance.shadowColor = nil
            }
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
            self.standardAppearance = appearance
        }
        
        let shadowImage = configure.shadowImage ? nil : transparentImage
        self.setShadowImage(shadowImage, forToolbarPosition: .any)
    }
}
