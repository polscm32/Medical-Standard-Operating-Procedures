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
    var viewModel: SOPViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var selection: SOPDTO?
    @State private var sopCount: Int = 0
    
    var body: some View {
        NavigationSplitView {
            FavoritesListView(viewModel: viewModel, selection: $selection, sopCount: $sopCount)
                .scrollContentBackground(.hidden)
                .background(colorScheme == .dark ? Color.clear : Color.white)
                .navigationTitle("Favorite SOPs")
                .navigationBarTitleDisplayMode(.large)
        } detail: {
            if let selection = selection {
                SOPDetailView(viewModel: viewModel, sop: selection)
            }
        }
    }
}
