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
    let storage: DataHandler
    @State var sops = [SOPDTO]() // Sendable type
    let modelContainer: ModelContainer
    var viewModel: SOPViewModel
    
    init(storage: DataHandler, modelContainer: ModelContainer, viewModel: SOPViewModel) {
        self.storage = storage
//        self.sops = sops
        self.modelContainer = modelContainer
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView {
            SearchView(storage: storage, modelContainer: modelContainer, viewModel: viewModel, sops: sops)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            FavoritesView(storage: storage)
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}
