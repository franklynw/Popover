//
//  Presenter.swift
//  
//
//  Created by Franklyn Weber on 20/02/2021.
//

import SwiftUI


class Presenter {
    
    private static var window: UIWindow?
    private static weak var viewController: UIViewController?
    private static var presenting: [String: Binding<Bool>] = [:]
    
    static func present<Content, EnvironmentObject: ObservableObject>(with parent: Popover<Content, EnvironmentObject>, isPresented: Binding<Bool>) {
        
        guard let appWindow = UIApplication.window, Self.presenting[parent.id] == nil else {
            return
        }
        
        UIApplication.endEditing()
        
        let id = parent.id
        let style = parent.style
        
        presenting[id] = isPresented
        
        let popoverViewController = PopoverViewController<Content, EnvironmentObject>(for: id, style: style)
        popoverViewController.dismissed = parent.dismissed
        
        if let windowScene = appWindow.windowScene {
            
            let newWindow = UIWindow(windowScene: windowScene)
            newWindow.rootViewController = popoverViewController
            
            window = newWindow
            window?.alpha = 0
            window?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            window?.makeKeyAndVisible()
            
            viewController = popoverViewController
            
            popoverViewController.present(with: parent) {
                UIView.animate(withDuration: 0.3) {
                    window?.alpha = 1
                }
            }
        }
    }
    
    static func dismiss(for id: String, dismissed: (() -> ())?) {
        
        guard window != nil, presenting[id] != nil else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            window?.alpha = 0
            viewController?.view.alpha = 0
        } completion: { _ in
            viewController?.view.removeFromSuperview()
            window?.isHidden = true
            viewController = nil
            window?.rootViewController = nil
            presenting[id]?.wrappedValue = false
            presenting.removeValue(forKey: id)
            dismissed?()
        }
    }
}


class ActiveSheetPresenter {
    
    private static var window: UIWindow?
    private static weak var viewController: UIViewController?
    private static var presenting: [String: Any] = [:]
    
    static func present<Content, T: Identifiable, EnvironmentObject: ObservableObject>(with parent: PopoverSheet<Content, T, EnvironmentObject>, activeSheet: Binding<T?>) {
        
        guard let appWindow = UIApplication.window, Self.presenting[parent.id] == nil else {
            return
        }
        
        UIApplication.endEditing()
        
        let id = parent.id
        let style = parent.style
        
        presenting[id] = activeSheet
        
        let popoverViewController = PopoverSheetViewController<Content, T, EnvironmentObject>(for: id, activeSheet: activeSheet, style: style)
        popoverViewController.dismissed = parent.dismissed
        
        if let windowScene = appWindow.windowScene {
            
            let newWindow = UIWindow(windowScene: windowScene)
            newWindow.rootViewController = popoverViewController
            
            window = newWindow
            window?.alpha = 0
            window?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            window?.makeKeyAndVisible()
            
            viewController = popoverViewController
            
            popoverViewController.present(with: parent) {
                UIView.animate(withDuration: 0.3) {
                    window?.alpha = 1
                }
            }
        }
    }
    
    static func dismiss<T: Identifiable>(for id: String, activeSheet: Binding<T?>, dismissed: (() -> ())?) {
        
        guard window != nil, presenting[id] != nil else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            window?.alpha = 0
            viewController?.view.alpha = 0
        } completion: { _ in
            viewController?.view.removeFromSuperview()
            window?.isHidden = true
            viewController = nil
            window?.rootViewController = nil
            (presenting[id] as? Binding<T?>)?.wrappedValue = nil
            presenting.removeValue(forKey: id)
            dismissed?()
        }
    }
}
