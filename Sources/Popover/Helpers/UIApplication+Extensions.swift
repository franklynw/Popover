//
//  UIApplication+Extensions.swift
//  
//
//  Created by Franklyn Weber on 20/02/2021.
//

import UIKit


extension UIApplication {
    
    static var window: UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
    
    static func endEditing() {
        window?.endEditing(true)
    }
}
