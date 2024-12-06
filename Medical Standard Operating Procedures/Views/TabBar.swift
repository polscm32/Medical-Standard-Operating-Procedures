//
//  ContentView.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 04.12.24.
//

/*
Abstract:
A main container view with a TabBar that presents Search and Favorites tabs.
*/


import SwiftUI
import SwiftData

struct TabBar: View {
    var viewModel: SOPViewModel
    @State var sops = [SOPDTO]() // Sendable type
    
    var body: some View {
        TabView {
            SearchView(viewModel: viewModel, sops: sops)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}
