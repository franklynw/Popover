//
//  PopoverNotificationContent.swift
//  
//
//  Created by Franklyn Weber on 20/02/2021.
//

import SwiftUI


public enum PopoverNotificationContent {
    case small(title: String, message: String? = nil, duration: Duration = .timed(3), backgroundColor: BackgroundColor? = nil)
    case standard(title: String, message: String? = nil, duration: Duration = .timed(3), backgroundColor: BackgroundColor? = nil)
    case attributed(title: NSAttributedString, message: NSAttributedString? = nil, duration: Duration = .timed(3), backgroundColor: BackgroundColor? = nil)
    
    public enum Duration {
        case timed(TimeInterval)
        case dismissOnTouch
        
        var time: TimeInterval? {
            switch self {
            case .timed(let time): return time
            case .dismissOnTouch: return nil
            }
        }
    }
    
    public enum BackgroundColor {
        case flat(UIColor)
        case gradient(UIColor)
    }
    
    var title: String {
        switch self {
        case .small(let title, _, _, _), .standard(let title, _, _, _):
            return title
        case .attributed(let title, _, _, _):
            return title.string
        }
    }
    
    var attributedTitle: NSAttributedString? {
        switch self {
        case .small, .standard:
            return nil
        case .attributed(let title, _, _, _):
            return title
        }
    }
    
    var message: String? {
        switch self {
        case .small(_, let message, _, _), .standard(_, let message, _, _):
            return message
        case .attributed(_, let message, _, _):
            return message?.string
        }
    }
    
    var attributedMessage: NSAttributedString? {
        switch self {
        case .small, .standard:
            return nil
        case .attributed(_, let message, _, _):
            return message
        }
    }
    
    var duration: Duration {
        switch self {
        case .small(_, _, let duration, _), .standard(_, _, let duration, _), .attributed(_, _, let duration, _):
            return duration
        }
    }
    
    var backgroundColor: BackgroundColor? {
        switch self {
        case .small(_, _, _, let color), .standard(_, _, _, let color), .attributed(_, _, _, let color):
            return color
        }
    }
    
    var titleFont: UIFont? {
        switch self {
        case .small: return .preferredFont(style: .subheadline)
        case .standard: return .preferredFont(style: .headline)
        case .attributed: return nil
        }
    }
    
    var messageFont: UIFont? {
        switch self {
        case .small: return .preferredFont(style: .caption1)
        case .standard: return .preferredFont(style: .subheadline)
        case .attributed: return nil
        }
    }
}
