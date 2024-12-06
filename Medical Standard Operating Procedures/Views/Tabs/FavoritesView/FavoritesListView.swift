//
//  Favorites.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 04.12.24.
//

/*
Abstract:
A view that displays the user's favorite SOPs in a list.
Allows deletion and updates the count accordingly.
*/

import Foundation
import SwiftUI

struct FavoritesListView: View {
    var viewModel: SOPViewModel
    var predicate: Predicate<SOP>?
    @State private var sops = [SOPDTO]()
    @Binding var selection: SOPDTO?
    @Binding var sopCount: Int
    
    init(viewModel: SOPViewModel, selection: Binding<SOPDTO?>, sopCount: Binding<Int>) {
        self.viewModel = viewModel
        _selection = selection
        _sopCount = sopCount
        self.predicate = #Predicate<SOP> { sop in
            sop.isFavorite
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(sopCount) SOPs")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
            List(selection: $selection) {
                ForEach(sops) { sop in
                    SOPListItem(sop: sop)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteSOP(at: IndexSet(integer: sops.firstIndex(of: sop)!))
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onDelete(perform: deleteSOP(at:))
            }
        }
        .overlay {
            if sops.isEmpty {
                ContentUnavailableView {
                     Label("No SOPs", systemImage: "flowchart")
                } description: {
                     Text("New SOPs you create will appear here.")
                }
            }
        }
        .navigationTitle("Favorites")
        .onChange(of: sops) {
           sopCount = sops.count
        }
        .onAppear {
           sopCount = sops.count
        }
        .task {
            do {
                // Load SOPs based on predicate
                if let predicate = self.predicate {
                    let fetchedSOPs = try await viewModel.fetchSOPs(with: predicate)
                    
                    await MainActor.run {
                        sops = fetchedSOPs
                    }
                }
            } catch {
                debugPrint("\(DebuggingIdentifiers.failed) Failed to fetch SOPs: \(error)")
            }
        }
    }
}

extension FavoritesListView {
    /// Delete SOPs at given offsets from the favorites list.
    private func deleteSOP(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let sop = sops[index]
                
                // Unselect the item before deleting
                if sop.id == selection?.id {
                    await MainActor.run {
                        selection = nil
                    }
                }
                
                // Delete the item from storage
                do {
                    try await viewModel.deleteSOP(with: sop.id)
                } catch {
                    debugPrint("\(DebuggingIdentifiers.failed) Failed to delete SOP \(sop.id): \(error)")
                }
            }
            
            // Remove items from the list on the MainActor
            await MainActor.run {
                withAnimation {
                    sops.remove(atOffsets: offsets)
                }
            }
        }
    }
}
