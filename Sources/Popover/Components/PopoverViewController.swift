//
//  PopoverViewController.swift
//  
//
//  Created by Franklyn Weber on 20/02/2021.
//

import SwiftUI


class PopoverViewController<Content: View, EnvironmentObject: ObservableObject>: UIViewController, UIPopoverPresentationControllerDelegate {
    
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

    func present(with parent: Popover<Content, EnvironmentObject>, completion: @escaping () -> ()) {
        
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
            if let environmentObject = parent.environmentObject {
                viewController = UIHostingController(rootView: content().environmentObject(environmentObject))
            } else {
                viewController = UIHostingController(rootView: content())
            }
        }
        
        viewController.modalPresentationStyle = .popover
        viewController.overrideUserInterfaceStyle = parent.userInterfaceStyle
        
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
            
            completion()
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
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }
}


class PopoverSheetViewController<Content: View, T: Identifiable, EnvironmentObject: ObservableObject>: UIViewController, UIPopoverPresentationControllerDelegate {
    
    private let id: String
    private let style: PopoverStyle<Content>
    private var activeSheet: Binding<T?>

    
    init(for id: String, activeSheet: Binding<T?>, style: PopoverStyle<Content>) {
        
        self.id = id
        self.activeSheet = activeSheet
        self.style = style
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func present(with parent: PopoverSheet<Content, T, EnvironmentObject>, completion: @escaping () -> ()) {
        
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
            if let environmentObject = parent.environmentObject {
                viewController = UIHostingController(rootView: content().environmentObject(environmentObject))
            } else {
                viewController = UIHostingController(rootView: content())
            }
        }
        
        viewController.modalPresentationStyle = .popover
        viewController.overrideUserInterfaceStyle = parent.userInterfaceStyle
        
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
                    ActiveSheetPresenter.dismiss(for: self.id, activeSheet: self.activeSheet)
                }
            }
            
            completion()
        }
    }
    
    func dismiss() {
        ActiveSheetPresenter.dismiss(for: id, activeSheet: activeSheet)
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        ActiveSheetPresenter.dismiss(for: id, activeSheet: activeSheet)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }
}
