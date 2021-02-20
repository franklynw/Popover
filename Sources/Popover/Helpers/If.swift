//
//  If.swift
//
//  Created by Franklyn Weber on 15/01/2021.
//

import SwiftUI


struct If: View {
    
    private let viewProvider: () -> AnyView
    
    init<V: View, O: View>(_ isTrue: Binding<Bool>, @ViewBuilder _ viewProvider: @escaping () -> V, @ViewBuilder else otherViewProvider: @escaping () -> O) {
        self.viewProvider = {
            isTrue.wrappedValue ? AnyView(viewProvider()) : AnyView(otherViewProvider())
        }
    }
    
    var body: some View {
        return viewProvider()
    }
}
