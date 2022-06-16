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


public struct PopoverSheet<Content: View, T: Identifiable, EnvironmentObject: ObservableObject>: View {
    
    @Binding var activeSheet: T?
    
    internal let id: String
    internal let style: PopoverStyle<Content>
    
    internal var userInterfaceStyle: UIUserInterfaceStyle = .unspecified
    internal var environmentObject: EnvironmentObject?
    
    
    public init(forId id: String, activeSheet: Binding<T?>, style: PopoverStyle<Content>) {
        self.id = id
        _activeSheet = activeSheet
        self.style = style
    }
    
    @ViewBuilder
    public var body: some View {
        
        DoIfLet($activeSheet) {
            ActiveSheetPresenter.present(with: self, activeSheet: $activeSheet)
        } else: {
            ActiveSheetPresenter.dismiss(for: id, activeSheet: $activeSheet)
        }
    }
}
