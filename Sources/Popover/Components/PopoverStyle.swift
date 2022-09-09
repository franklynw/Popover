//
//  File.swift
//  
//
//  Created by Franklyn Weber on 20/02/2021.
//

import SwiftUI


public enum PopoverStyle<Content: View> {
    case tiny(content: () -> Content)
    case small(content: () -> Content)
    case medium(content: () -> Content)
    case large(content: () -> Content)
    case extraLarge(content: () -> Content)
    case fullScreen(content: () -> Content)
//    case notification(content: PopoverNotificationContent)
    case custom(size: CGSize, yOffset: CGFloat, content: () -> Content)
    case none
    
//    public static func notification(_ content: PopoverNotificationContent) -> PopoverStyle<AnyView> {
//        return .notification(content: content)
//    }
    public static func custom(_ size: CGSize, yOffset: CGFloat, content: @escaping () -> Content) -> PopoverStyle<Content> {
        return .custom(size: size, yOffset: yOffset, content: content)
    }
    
    
    var size: CGSize {
        
        switch self {
        case .tiny:
            return CGSize(width: 0.4, height: 0.2)
        case .small:
            return CGSize(width: 0.5, height: 0.3)
        case .medium:
            return CGSize(width: 0.6, height: 0.5)
        case .large:
            return CGSize(width: 0.8, height: 0.7)
        case .extraLarge:
            return CGSize(width: 0.9, height: 0.9)
        case .fullScreen:
            return CGSize(width: 1, height: 1)
//        case .notification(let content):
//
//            let popupHeight = NotificationViewController.height(for: content, inContainerWidth: width * 0.8)
//            return CGSize(width: width * 0.8, height: popupHeight)
            
        case .custom(let size, _, _):
            return CGSize(width: size.width, height: size.height)
        case .none:
            return .zero
        }
    }
    
    var yOffset: CGFloat {
        
        switch self {
        case .tiny, .small, .medium:
            return 0.1
        case .large:
            return 0.05
        case .extraLarge, .fullScreen:
            return 0
//        case .notification:
//            return 0.4
        case .custom(_, let yOffset, _):
            return yOffset
        case .none:
            return 0
        }
    }
    
    var content: (() -> Content)? {
        switch self {
        case .tiny(let content), .small(let content), .medium(let content), .large(let content), .extraLarge(let content), .fullScreen(let content), .custom(_, _, let content):
            return content
//        case .notification:
//            return nil
        case .none:
            return nil
        }
    }
}
