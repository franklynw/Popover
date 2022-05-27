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
    
    static func present<Content>(with parent: Popover<Content>, isPresented: Binding<Bool>) {
        
        guard let appWindow = UIApplication.window else {
            return
        }
        
        UIApplication.endEditing()
        
        let id = parent.id
        let style = parent.style
        
        presenting[id] = isPresented
        
        let popoverViewController = PopoverViewController(for: id, style: style)
        
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
    
    static func dismiss(for id: String) {
        
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
            presenting[id]?.wrappedValue = false
            presenting.removeValue(forKey: id)
        }
    }
}
