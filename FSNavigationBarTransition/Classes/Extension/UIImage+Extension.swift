//
//  UIImage+Extension.swift
//  NavigationBarTransition
//
//  Created by yuanl on 2024/6/6.
//

import Foundation

public extension UIImage {
    static func transparentImage() -> UIImage {
        return UIImage()
    }
    
    static func image(withColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let newSize = CGSize(width: max(0.5, size.width), height: max(0.5, size.height))
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
