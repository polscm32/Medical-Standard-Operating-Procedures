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
    @State var sops = [SOPStruct]() // Sendable type
    
    var body: some View {
        TabView {
            SearchView(storage: storage, sops: sops)
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
