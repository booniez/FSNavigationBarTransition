//
//  NavigationBarConfiguration.swift
//  NavigationBarTransition
//
//  Created by yuanl on 2024/6/6.
//

import Foundation

// 使用OptionSet表示位掩码枚举
public struct NavigationBarConfigurations: OptionSet {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    
    public static let show = NavigationBarConfigurations([])
    public static let hidden = NavigationBarConfigurations(rawValue: 1 << 0)
    
    public static let styleLight = NavigationBarConfigurations(rawValue: 0 << 4)
    public static let styleBlack = NavigationBarConfigurations(rawValue: 1 << 4)
    
    public static let backgroundStyleTranslucent = NavigationBarConfigurations(rawValue: 0 << 8)
    public static let backgroundStyleOpaque = NavigationBarConfigurations(rawValue: 1 << 8)
    public static let backgroundStyleTransparent = NavigationBarConfigurations(rawValue: 2 << 8)
    
    public static let backgroundStyleNone = NavigationBarConfigurations(rawValue: 0 << 16)
    public static let backgroundStyleColor = NavigationBarConfigurations(rawValue: 1 << 16)
    public static let backgroundStyleImage = NavigationBarConfigurations(rawValue: 2 << 16)
    
    public static let showShadowImage = NavigationBarConfigurations(rawValue: 1 << 20)
    
    public static let configurationsDefault = NavigationBarConfigurations([])
}

//enum YPNavigationBarConfigurations: Int {
//    case `default` = 0
//    case hidden = 1 << 0
//    case styleBlack = 1 << 1
//    case backgroundStyleTransparent = 1 << 2
//    case showShadowImage = 1 << 3
//    case backgroundStyleOpaque = 1 << 4
//    case backgroundStyleImage = 1 << 5
//    case backgroundStyleColor = 1 << 6
//}
