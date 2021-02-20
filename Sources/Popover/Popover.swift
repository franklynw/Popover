//
//  Popover.swift
//
//  Created by Franklyn Weber on 18/02/2021.
//

import SwiftUI


public struct Popover<Content: View>: View {
    
    @Binding private var isPresented: Bool
    
    private let id: String
    private let style: PopoverStyle<Content>
    
    
    public init(forId id: String, isPresented: Binding<Bool>, style: PopoverStyle<Content>) {
        self.id = id
        _isPresented = isPresented
        self.style = style
    }
    
    public var body: some View {
        
        DoIf($isPresented) {
            Presenter.present(for: id, isPresented: $isPresented, style: style)
        } else: {
            Presenter.dismiss(for: id)
        }
    }
}
