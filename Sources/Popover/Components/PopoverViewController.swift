//
//  PopoverViewController.swift
//  
//
//  Created by Franklyn Weber on 20/02/2021.
//

import SwiftUI
import Combine


class PopoverViewController<Content: View, EnvironmentObject: ObservableObject>: UIViewController {
    
    private let id: String
    private let style: PopoverStyle<Content>
    
    private var keyboardObserverCancellable: AnyCancellable!
    private var heightConstraint: NSLayoutConstraint?
    private var centerYConstraint: NSLayoutConstraint?
    
    var dismissed: (() -> ())?

    
    init(for id: String, style: PopoverStyle<Content>) {
        
        self.id = id
        self.style = style
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit PopoverViewController")
    }
    
    func present(with parent: Popover<Content, EnvironmentObject>) {
        
        guard let content = style.content else {
            return
        }
        
        let presentingView = UIView()
        
        presentingView.translatesAutoresizingMaskIntoConstraints = false
        presentingView.layer.cornerRadius = 10
        presentingView.layer.masksToBounds = true
        
        view.addSubview(presentingView)
        
        heightConstraint = presentingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: style.size.height)
        heightConstraint?.isActive = true
        centerYConstraint = presentingView.centerYAnchor.anchorWithOffset(to: view.centerYAnchor).constraint(equalTo: view.heightAnchor, multiplier: style.yOffset)
        centerYConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            presentingView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: style.size.width),
            presentingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let contentViewController: UIViewController
        if let environmentObject = parent.environmentObject {
            contentViewController = UIHostingController(rootView: content().environmentObject(environmentObject))
        } else {
            contentViewController = UIHostingController(rootView: content())
        }
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.layer.cornerRadius = 10
        contentViewController.view.layer.masksToBounds = true
        
        presentingView.addSubview(contentViewController.view)
        
        NSLayoutConstraint.activate([
            presentingView.leadingAnchor.constraint(equalTo: contentViewController.view.leadingAnchor),
            presentingView.trailingAnchor.constraint(equalTo: contentViewController.view.trailingAnchor),
            presentingView.topAnchor.constraint(equalTo: contentViewController.view.topAnchor),
            presentingView.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor)
        ])
        
        let interceptGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(intercept))
        presentingView.addGestureRecognizer(interceptGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        keyboardObserverCancellable = KeyboardResponder.shared.$keyboardState
            .sink { [weak self] keyboardState in
                
                guard let self = self else {
                    return
                }
                
                switch keyboardState {
                case .hidden:
                    self.heightConstraint?.constant = 0
                    self.centerYConstraint?.constant = 0
                case .shown(let keyboardRect):
                    
                    let frameHeight = self.view.frame.height
                    let height = frameHeight * self.style.size.height
                    let yOffset = frameHeight * self.style.yOffset
                    let top = (frameHeight - height) / 2 - yOffset
                    let bottom = top + height
                    let keyboardHeight = keyboardRect.height
                    let adjustment = frameHeight - keyboardHeight - bottom
                    let landscapeAdjustment = frameHeight < self.view.frame.width ? top * 0.6 : 0
                    
                    if adjustment < 0 {
                        self.heightConstraint?.constant = adjustment + landscapeAdjustment
                        self.centerYConstraint?.constant = -adjustment / 2 + landscapeAdjustment
                    }
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
    }
    
    func dismiss() {
        Presenter.dismiss(for: id, dismissed: dismissed)
    }
    
    @objc
    private func backgroundTapped() {
        dismiss()
    }
    
    @objc
    private func intercept() {
        // nothing
    }
}


class PopoverSheetViewController<Content: View, T: Identifiable, EnvironmentObject: ObservableObject>: UIViewController, UIPopoverPresentationControllerDelegate {
    
    private let id: String
    private let style: PopoverStyle<Content>
    private var activeSheet: Binding<T?>
    
    private var keyboardObserverCancellable: AnyCancellable!
    private var heightConstraint: NSLayoutConstraint?
    private var centerYConstraint: NSLayoutConstraint?
    
    var dismissed: (() -> ())?

    
    init(for id: String, activeSheet: Binding<T?>, style: PopoverStyle<Content>) {
        
        self.id = id
        self.activeSheet = activeSheet
        self.style = style
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit PopoverSheetViewController")
    }

    func present(with parent: PopoverSheet<Content, T, EnvironmentObject>) {
        
        guard let content = style.content else {
            return
        }
        
        let presentingView = UIView()
        
        presentingView.translatesAutoresizingMaskIntoConstraints = false
        presentingView.layer.cornerRadius = 10
        presentingView.layer.masksToBounds = true
        
        view.addSubview(presentingView)
        
        heightConstraint = presentingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: style.size.height)
        heightConstraint?.isActive = true
        centerYConstraint = presentingView.centerYAnchor.anchorWithOffset(to: view.centerYAnchor).constraint(equalTo: view.heightAnchor, multiplier: style.yOffset)
        centerYConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            presentingView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: style.size.width),
            presentingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let contentViewController: UIViewController
        if let environmentObject = parent.environmentObject {
            contentViewController = UIHostingController(rootView: content().environmentObject(environmentObject))
        } else {
            contentViewController = UIHostingController(rootView: content())
        }
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.layer.cornerRadius = 10
        contentViewController.view.layer.masksToBounds = true
        
        presentingView.addSubview(contentViewController.view)
        
        NSLayoutConstraint.activate([
            presentingView.leadingAnchor.constraint(equalTo: contentViewController.view.leadingAnchor),
            presentingView.trailingAnchor.constraint(equalTo: contentViewController.view.trailingAnchor),
            presentingView.topAnchor.constraint(equalTo: contentViewController.view.topAnchor),
            presentingView.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor)
        ])
        
        let interceptGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(intercept))
        presentingView.addGestureRecognizer(interceptGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        keyboardObserverCancellable = KeyboardResponder.shared.$keyboardState
            .sink { [weak self] keyboardState in
                
                guard let self = self else {
                    return
                }
                
                switch keyboardState {
                case .hidden:
                    self.heightConstraint?.constant = 0
                    self.centerYConstraint?.constant = 0
                case .shown(let keyboardRect):
                    
                    let frameHeight = self.view.frame.height
                    let height = frameHeight * self.style.size.height
                    let yOffset = frameHeight * self.style.yOffset
                    let top = (frameHeight - height) / 2 - yOffset
                    let bottom = top + height
                    let keyboardHeight = keyboardRect.height
                    let adjustment = frameHeight - keyboardHeight - bottom
                    let landscapeAdjustment = frameHeight < self.view.frame.width ? top * 0.6 : 0
                    
                    if adjustment < 0 {
                        self.heightConstraint?.constant = adjustment + landscapeAdjustment
                        self.centerYConstraint?.constant = -adjustment / 2 + landscapeAdjustment
                    }
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
    }
    
    func dismiss() {
        ActiveSheetPresenter.dismiss(for: id, activeSheet: activeSheet, dismissed: dismissed)
    }
    
    @objc
    private func backgroundTapped() {
        dismiss()
    }
    
    @objc
    private func intercept() {
        // nothing
    }
}
