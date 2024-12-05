//
//  MainView.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 04.12.24.
//

/*
Abstract:
 A view that provides a searchable list of SOPs, filtering by subject, and allows adding new SOPs.
 It uses a CustomSubjectPicker for subject filtering and SOPListView for displaying the results.
*/

import Foundation
import SwiftUI

struct SearchView: View {
    let storage: DataHandler
    @Environment(\.colorScheme) var colorScheme
    @State var sops: [SOPStruct]
    @State private var searchText = ""
    @State private var selection: SOPStruct?
    @State private var showAddSOP: Bool = false
    @State private var sopCount: Int = 0
    @State private var subject: Subject = .all
    @State private var shouldUpdateList = false
    
    var body: some View {
        NavigationSplitView {
            VStack {
                CustomSubjectPicker(selection: $subject)
                
                HStack {
                    Text("\(sopCount) SOPs")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                }
                .padding(.horizontal,5)
                
                SOPListView(
                    storage: storage,
                    sops: $sops,
                    selection: $selection,
                    sopCount: $sopCount,
                    searchText: $searchText,
                    subject: .constant(subject.rawValue),
                    shouldUpdate: $shouldUpdateList
                )
                .scrollContentBackground(.hidden)
                .background(colorScheme == .dark ? Color.clear : Color.white)
                .navigationTitle("SOPs")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                            .disabled(sopCount == 0)
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            showAddSOP = true
                        } label: {
                            HStack {
                                Text("Add SOP")
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
        } detail: {
            if let selection = selection {
                SOPDetailView(storage: storage, sop: selection)
            }
        }
        .sheet(isPresented: $showAddSOP, onDismiss: {
            showAddSOP = false
        }, content: {
            NavigationStack {
                AddSOPView(storage: storage, sops: $sops)
            }
            .presentationDetents([.large, .large])
        })
        .searchable(text: $searchText)
    }
}
