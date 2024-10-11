//
//  Font.swift
//  Hotel
//
//  Created by Karen Khachatryan on 12.10.24.
//

import UIKit

extension UIFont {
    static func interRegular(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Regular", size: CGFloat(size))
    }
    
    static func interMedium(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Medium", size: CGFloat(size))
    }
    
    static func interItalicLight(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-LightItalic", size: CGFloat(size))
    }
    
    static func seversMedium(size: CFloat) -> UIFont? {
        return UIFont(name: "TT Severs Trial Medium", size: CGFloat(size))
    }
    
    static func seversDemiBold(size: CFloat) -> UIFont? {
        return UIFont(name: "TT Severs Trial DemiBold", size: CGFloat(size))
    }
    
    static func travelsDemiBold(size: CFloat) -> UIFont? {
        return UIFont(name: "TT Travels Next DemiBold", size: CGFloat(size))
    }
    
    static func robotoMedium(size: CFloat) -> UIFont? {
        return UIFont(name: "Roboto-Medium", size: CGFloat(size))
    }
    
}
