//
//  File.swift
//  
//
//  Created by Franklyn on 09/09/2022.
//

import SwiftUI


final class KeyboardResponder: ObservableObject {
    
    enum KeyboardState {
        case hidden
        case shown(CGRect)
    }
    
    static let shared = KeyboardResponder()
    
    @Published var keyboardState = KeyboardState.hidden
    
    let objectWillChange = ObjectWillChangePublisher()

    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyBoardWillShow(notification: Notification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            withAnimation {
                keyboardState = .shown(keyboardRect)
                objectWillChange.send()
            }
        }
    }

    @objc
    private func keyBoardWillHide(notification: Notification) {
        withAnimation {
            keyboardState = .hidden
            objectWillChange.send()
        }
    }
}
