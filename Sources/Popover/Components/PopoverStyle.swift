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
    case extraLarge(content: () -> Content)
    case notification(content: PopoverNotificationContent)
    case customSize(size: CGSize, content: () -> Content)
    case customProportion(proportion: CGSize, content: () -> Content)
    case none
    
    public static func notification(_ content: PopoverNotificationContent) -> PopoverStyle<AnyView> {
        return .notification(content: content)
    }
    public static func customSize(_ size: CGSize, content: @escaping () -> Content) -> PopoverStyle<Content> {
        return .customSize(size: size, content: content)
    }
    public static func customProportion(_ proportion: CGSize, content: @escaping () -> Content) -> PopoverStyle<Content> {
        return .customProportion(proportion: proportion, content: content)
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
        case .extraLarge:
            return CGSize(width: width * 0.9, height: height * 0.9)
        case .notification(let content):
            
            let popupHeight = NotificationViewController.height(for: content, inContainerWidth: width * 0.8)
            return CGSize(width: width * 0.8, height: popupHeight)
            
        case .customSize(let size, _):
            return CGSize(width: size.width, height: size.height)
        case .customProportion(let proportion, _):
            return CGSize(width: width * proportion.width, height: height * proportion.height)
        case .none:
            return nil
        }
    }
    
    var offset: CGPoint {
        
        let screenSize = UIScreen.main.bounds.size
        let width = screenSize.width
        let height = screenSize.height
        
        switch self {
        case .none, .system, .tiny, .small, .medium, .large:
            return CGPoint(x: width / 2, y: height * 0.45)
        case .extraLarge:
            return CGPoint(x: width / 2, y: height / 2)
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
        case .system(let content), .tiny(let content), .small(let content), .medium(let content), .large(let content), .extraLarge(let content), .customSize(_, let content), .customProportion(_, let content):
            return content
        case .notification, .none:
            return nil
        }
    }
}
