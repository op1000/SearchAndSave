//
//  FirstAppearModifier.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import SwiftUI

public extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(FirstAppearModifier(perform: action))
    }
}

public struct FirstAppearModifier: ViewModifier {
    @State private var didAppearBefore = false
    private let action: () -> Void

    public init(perform action: @escaping () -> Void) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content.onAppear {
            guard !didAppearBefore else { return }
            didAppearBefore = true
            action()
        }
    }
}
