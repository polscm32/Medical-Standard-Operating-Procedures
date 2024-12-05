//
//  ClearableTextFieldModifier.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 05.12.24.
//

/*
Abstract:
A ViewModifier that adds an X mark to the textfield to delete its content.
*/

import SwiftUI

struct ClearableTextFieldModifier: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        content
            .padding(.trailing, 30) // Add space for the button
            .overlay(
                HStack {
                    Spacer()
                    if !text.isEmpty {
                        Button(action: {
                            text = "" // Clear the text
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
            )
    }
}

// Function for easier usage of ClearableTextFieldModifier in Swift UI views
extension View {
    func clearable(_ text: Binding<String>) -> some View {
        self.modifier(ClearableTextFieldModifier(text: text))
    }
}
