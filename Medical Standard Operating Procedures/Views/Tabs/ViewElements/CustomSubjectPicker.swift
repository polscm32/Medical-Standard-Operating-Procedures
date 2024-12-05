//
//  CustomPicker.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 05.12.24.
//

/*
Abstract:
A custom picker to choose the subject in the main view.
*/

import SwiftUI


struct CustomSubjectPicker: View {
    @Binding var selection: Subject
    
    var body: some View {
        HStack {
            ForEach(Subject.allCases, id: \.self) { subject in
                VStack {
                    VStack { // fixed container with size to align images and text vertically
                        Image(systemName: subject.symbolName)
                            .font(.title2)
                            .foregroundStyle(selection == subject ? .blue : .secondary)
                    }.frame(height: 30)
                    
                    Text(subject.abbreviation)
                        .font(.caption2)
                        .foregroundStyle(selection == subject ? .primary : .secondary)
                }
                .padding()
                .background(selection == subject ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(10)
                .onTapGesture {
                    selection = subject
                }
            }
        }
    }
}
