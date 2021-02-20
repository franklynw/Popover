//
//  Presenter.swift
//  
//
//  Created by Franklyn Weber on 20/02/2021.
//

import SwiftUI


class Presenter {
    
    private static var window: UIWindow?
    private static var viewController: UIViewController?
    private static var presenting: [String: Binding<Bool>] = [:]
    
    static func present<Content>(for id: String, isPresented: Binding<Bool>, style: PopoverStyle<Content>) {
        
        guard let appWindow = UIApplication.window else {
            return
        }
        guard window == nil else {
            return
        }
        
        UIApplication.endEditing()
        
        presenting[id] = isPresented
        
        let popoverViewController = PopoverViewController(for: id, style: style)
        
        if let windowScene = appWindow.windowScene {
            
            let newWindow = UIWindow(windowScene: windowScene)
            newWindow.rootViewController = popoverViewController
            
            window = newWindow
            window?.alpha = 0
            window?.makeKeyAndVisible()
            
            UIView.animate(withDuration: 0.3) {
                window?.alpha = 1
            }
            
            viewController = popoverViewController
            
            popoverViewController.present()
        }
    }
    
    static func dismiss(for id: String) {
        
        guard window != nil, presenting[id] != nil else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            window?.alpha = 0
            viewController?.view.alpha = 0
        } completion: { _ in
            window = nil
            viewController = nil
            presenting[id]?.wrappedValue = false
            presenting.removeValue(forKey: id)
        }
    }
}
