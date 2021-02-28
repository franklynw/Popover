//
//  File.swift
//  
//
//  Created by Franklyn Weber on 20/02/2021.
//

import SwiftUI


public enum PopoverStyle<Content: View> {
    case system(content: () -> Content)
    case tiny(content: () -> Content)
    case small(content: () -> Content)
    case medium(content: () -> Content)
    case large(content: () -> Content)
    case notification(content: PopoverNotificationContent)
    case customSize(size: CGSize, content: () -> Content)
    case customProportion(proportion: CGSize, content: () -> Content)
    
    public static func notification(_ content: PopoverNotificationContent) -> PopoverStyle<AnyView> {
        return .notification(content: content)
    }
    public static func customSize<T>(_ size: CGSize, content: @escaping () -> T) -> PopoverStyle<T> {
        return PopoverStyle<T>.customSize(size: size, content: content)
    }
    public static func customProportion<T>(_ proportion: CGSize, content: @escaping () -> T) -> PopoverStyle<T> {
        return PopoverStyle<T>.customProportion(proportion: proportion, content: content)
    }
    
    
    var size: CGSize? {
        
        let screenSize = UIScreen.main.bounds.size
        let width = screenSize.width
        let height = screenSize.height
        
        switch self {
        case .system:
            return nil
        case .tiny:
            return CGSize(width: width * 0.4, height: height * 0.2)
        case .small:
            return CGSize(width: width * 0.5, height: height * 0.3)
        case .medium:
            return CGSize(width: width * 0.6, height: height * 0.5)
        case .large:
            return CGSize(width: width * 0.8, height: height * 0.7)
        case .notification(let content):
            
            let popupHeight = NotificationViewController.height(for: content, inContainerWidth: width * 0.8)
            return CGSize(width: width * 0.8, height: popupHeight)
            
        case .customSize(let size, _):
            return CGSize(width: size.width, height: size.height)
        case .customProportion(let proportion, _):
            return CGSize(width: width * proportion.width, height: height * proportion.height)
        }
    }
    
    var offset: CGPoint {
        
        let screenSize = UIScreen.main.bounds.size
        let width = screenSize.width
        let height = screenSize.height
        
        switch self {
        case .system, .tiny, .small, .medium, .large:
            return CGPoint(x: width / 2, y: height * 0.45)
        case .notification:
            return CGPoint(x: width / 2, y: height * 0.1)
        case .customSize(let size, _):
            return CGPoint(x: width / 2, y: (height - size.height) * 0.45)
        case .customProportion(let proportion, _):
            return CGPoint(x: width / 2, y: (height - height * proportion.height) * 0.45)
        }
    }
    
    var content: (() -> Content)? {
        switch self {
        case .system(let content), .tiny(let content), .small(let content), .medium(let content), .large(let content), .customSize(_, let content), .customProportion(_, let content):
            return content
        case .notification:
            return nil
        }
    }
}
