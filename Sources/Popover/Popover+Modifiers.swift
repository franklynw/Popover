//
//  Popover+Modifiers.swift
//  
//
//  Created by Franklyn Weber on 20/02/2021.
//

import SwiftUI


extension View where Self: Identifiable, ID == String {
    
    /// View extension in the style of .sheet - lacks a couple of customisation options. If more flexibility is required, use Popover(...) directly, and apply the required modifiers
    /// The presenting view must conform to Identifiable to use this modifier - if this is a problem, use Popover(...) directly with a simple String identifier
    /// NB - if this modifier is used, you can't have more than one popover on a view, they must be on views with different IDs
    /// - Parameters:
    ///   - isPresented: binding to a Bool which controls whether or not to show the picker
    ///   - style: the popover's content style
    public func popover<Content: View, EnvironmentObject: ObservableObject>(isPresented: Binding<Bool>, style: PopoverStyle<Content>) -> some View {
        modifier(PopoverPresentationModifier(content: { Popover<Content, EnvironmentObject>(forId: self.id, isPresented: isPresented, style: style)}))
    }
}


struct PopoverPresentationModifier<PopoverContent, EnvironmentObject>: ViewModifier where PopoverContent: View, EnvironmentObject: ObservableObject {
    
    var content: () -> Popover<PopoverContent, EnvironmentObject>
    
    init(@ViewBuilder content: @escaping () -> Popover<PopoverContent, EnvironmentObject>) {
        self.content = content
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            self.content()
        }
    }
}


extension Popover {
    
    public func userInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle) -> Self {
        var copy = self
        copy.userInterfaceStyle = userInterfaceStyle
        return copy
    }
    
    public func environmentObject(_ object: EnvironmentObject) -> Self {
        var copy = self
        copy.environmentObject = object
        return copy
    }
}


extension PopoverSheet {
    
    public func userInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle) -> Self {
        var copy = self
        copy.userInterfaceStyle = userInterfaceStyle
        return copy
    }
    
    public func environmentObject(_ object: EnvironmentObject) -> Self {
        var copy = self
        copy.environmentObject = object
        return copy
    }
}
