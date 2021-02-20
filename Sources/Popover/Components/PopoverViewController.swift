//
//  PopoverViewController.swift
//  
//
//  Created by Franklyn Weber on 20/02/2021.
//

import SwiftUI


class PopoverViewController<Content: View>: UIViewController, UIPopoverPresentationControllerDelegate {
    
    private let id: String
    private let style: PopoverStyle<Content>

    
    init(for id: String, style: PopoverStyle<Content>) {
        
        self.id = id
        self.style = style
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func present() {
        
        var viewController: UIViewController
        
        switch style {
        case .notification(let content):
            let storyboard = UIStoryboard(name: "NotificationViewController", bundle: Bundle.module)
            let notificationViewController = storyboard.instantiateInitialViewController() as! NotificationViewController
            notificationViewController.content = content
            viewController = notificationViewController
        default:
            guard let content = style.content else {
                return
            }
            viewController = UIHostingController(rootView: content())
        }
        
        viewController.modalPresentationStyle = .popover
        
        if let popoverSize = style.size {
            viewController.preferredContentSize = popoverSize
        }
        
        if let popover = viewController.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(origin: style.offset, size: .zero)
            popover.delegate = self
            popover.permittedArrowDirections = []
            popover.backgroundColor = .clear
        }
        
        present(viewController, animated: false) { [weak self] in
            
            guard let self = self else {
                return
            }
            
            if case .notification(let content) = self.style, let time = content.duration.time {
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    Presenter.dismiss(for: self.id)
                }
            }
        }
    }
    
    func dismiss() {
        Presenter.dismiss(for: id)
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        Presenter.dismiss(for: id)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
