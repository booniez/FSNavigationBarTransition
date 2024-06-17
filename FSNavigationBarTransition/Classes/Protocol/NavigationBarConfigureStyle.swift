//
//  NavigationBarConfigureStyle.swift
//  NavigationBarTransition
//
//  Created by yuanl on 2024/6/6.
//

import Foundation


public protocol NavigationBarConfigureStyle {
    func navigtionBarConfiguration() -> [NavigationBarConfigurations]
    func navigationBarTintColor() -> UIColor?
    
    
    /// identifier 用来比较image的name是否是同，如果不传，会使用image的isEqual来比较
    /// - Parameter identifier: <#identifier description#>
    /// - Returns: <#description#>
    func navigationBackgroundImageWithIdentifier(_ identifier: String?) -> UIImage?
    func navigationBackgroundColor() -> UIColor?
}
