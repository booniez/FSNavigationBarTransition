//
//  BarConfiguration.swift
//  NavigationBarTransition
//
//  Created by yuanl on 2024/6/6.
//

import Foundation

import UIKit

class BarConfiguration: NSObject {

    let hidden: Bool
    let barStyle: UIBarStyle
    let translucent: Bool
    let transparent: Bool
    let shadowImage: Bool
    let tintColor: UIColor
    let backgroundColor: UIColor?
    let backgroundImage: UIImage?
    let backgroundImageIdentifier: String?

    init(configurations: [NavigationBarConfigurations],
         tintColor: UIColor? = nil,
         backgroundColor: UIColor? = nil,
         backgroundImage: UIImage? = nil,
         backgroundImageIdentifier: String? = nil) {

        var tempTintColor = tintColor
        self.hidden = configurations.contains(.hidden)
        self.barStyle = configurations.contains(.styleBlack) ? .black : .default
        if tempTintColor == nil {
            tempTintColor = self.barStyle == .black ? .white : .black
        }
        self.tintColor = tempTintColor!

        var tempTransparent = false
        var tempShadowImage = false
        var tempTranslucent = true

        if !self.hidden {
            tempTransparent = configurations.contains(.backgroundStyleTransparent)

            if !tempTransparent {
                tempShadowImage = configurations.contains(.showShadowImage)
                tempTranslucent = !configurations.contains(.backgroundStyleOpaque)
            }
        }

        self.transparent = tempTransparent
        self.shadowImage = tempShadowImage
        self.translucent = tempTranslucent

        if configurations.contains(.backgroundStyleImage), let img = backgroundImage {
            self.backgroundImage = img
            self.backgroundImageIdentifier = backgroundImageIdentifier
            self.backgroundColor = nil
        } else if configurations.contains(.backgroundStyleColor) {
            self.backgroundColor = backgroundColor
            self.backgroundImage = nil
            self.backgroundImageIdentifier = nil
        } else {
            self.backgroundColor = nil
            self.backgroundImage = nil
            self.backgroundImageIdentifier = nil
        }

        super.init()
    }
}

// MARK: - BarTransition

extension BarConfiguration {
    convenience init(barConfigurationOwner owner: NavigationBarConfigureStyle) {
        let configurations = owner.navigtionBarConfiguration()
        let tintColor = owner.navigationBarTintColor()
        var backgroundColor: UIColor?
        var backgroundImage: UIImage?
        var backgroundImageIdentifier: String?

        if !configurations.contains(.backgroundStyleTransparent) {
            if configurations.contains(.backgroundStyleImage) {
                backgroundImage = owner.navigationBackgroundImageWithIdentifier(backgroundImageIdentifier)
            } else if configurations.contains(.backgroundStyleColor) {
                backgroundColor = owner.navigationBackgroundColor()
            }
        }

        self.init(configurations: configurations,
                  tintColor: tintColor,
                  backgroundColor: backgroundColor,
                  backgroundImage: backgroundImage,
                  backgroundImageIdentifier: backgroundImageIdentifier)
    }

    func isVisible() -> Bool {
        return !self.hidden && !self.transparent
    }

    func useSystemBarBackground() -> Bool {
        return self.backgroundColor == nil && self.backgroundImage == nil
    }
}
