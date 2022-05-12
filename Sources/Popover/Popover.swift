//
//  Popover.swift
//
//  Created by Franklyn Weber on 18/02/2021.
//

import SwiftUI


public struct Popover<Content: View>: View {
    
    @Binding private var isPresented: Bool
    
    internal let id: String
    internal let style: PopoverStyle<Content>
    
    internal var userInterfaceStyle: UIUserInterfaceStyle = .unspecified
    
    
    public init(forId id: String, isPresented: Binding<Bool>, style: PopoverStyle<Content>) {
        self.id = id
        _isPresented = isPresented
        self.style = style
    }
    
    public var body: some View {
        
        DoIf($isPresented) {
            Presenter.present(with: self, isPresented: $isPresented)
        } else: {
            Presenter.dismiss(for: id)
        }
    }
}
