//
//  FavoritesView.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 05.12.24.
//

/*
Abstract:
 A view that displays the user's favorite SOPs and navigates to detail views when selected.
*/

import Foundation
import SwiftUI

struct FavoritesView: View {
    let storage: DataHandler
    @Environment(\.colorScheme) var colorScheme
    @State private var selection: SOPStruct?
    @State private var sopCount: Int = 0
    
    var body: some View {
        NavigationSplitView {
            FavoritesListView(storage: storage, selection: $selection, sopCount: $sopCount)
                .scrollContentBackground(.hidden)
                .background(colorScheme == .dark ? Color.clear : Color.white)
                .navigationTitle("Favorite SOPs")
                .navigationBarTitleDisplayMode(.large)
        } detail: {
            if let selection = selection {
                SOPDetailView(storage: storage, sop: selection)
            }
        }
    }
}
