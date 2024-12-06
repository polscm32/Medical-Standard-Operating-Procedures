//
//  SOPList.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 04.12.24.
//

/*
Abstract:
A list view that displays SOPs, allows deletion, and refreshes based on search text and subject changes.
Uses a @Binding array of SOPDTO to reflect changes upstream.
 */

import Foundation
import SwiftUI

struct SOPListView: View {
    var viewModel: SOPViewModel
    @Binding var sops: [SOPDTO]
    @Binding var selection: SOPDTO?
    @Binding var sopCount: Int
    @Binding var searchText: String
    @Binding var subject: String
    @Binding var shouldUpdate: Bool
    
    var body: some View {
        VStack {
            List(selection: $selection) {
                ForEach(sops) { sop in
                    SOPListItem(sop: sop)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteSOP([sops.firstIndex(of: sop)!])
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onDelete(perform: deleteSOP)
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
            .task {
                await fetchSOPs()
            }
            .onChange(of: searchText) {
                Task {
                    await fetchSOPs()
                }
            }
            .onChange(of: subject) {
                Task {
                    await fetchSOPs()
                }
            }
        }
    }
}

extension SOPListView {
    // Fetch SOPs based on current searchText and subject
    private func fetchSOPs() async {
        do {
            let predicate = #Predicate<SOP> { sop in
                if searchText.isEmpty {
                    return sop.subjectRawValue == subject || subject == "All"
                } else {
                    return (sop.title.contains(searchText) || sop.details.contains(searchText)) &&
                           (sop.subjectRawValue == subject || subject == "All")
                }
            }
            
            let fetchedSOPs = try await viewModel.fetchSOPs(with: predicate)
            
            await MainActor.run {
                sops = fetchedSOPs
                sopCount = sops.count
            }
        } catch {
            debugPrint("\(DebuggingIdentifiers.failed) Failed to fetch SOPs: \(error)")
        }
    }
    
    // Delete SOPs
    private func deleteSOP(_ offsets: IndexSet) {
        Task {
            for index in offsets {
                let sop = sops[index]
                
                // Unselect the item before deleting
                if sop.id == selection?.id {
                    await MainActor.run {
                        selection = nil
                    }
                }
                
                // Delete the item from storage using the viewModel
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
                sopCount = sops.count
            }
        }
    }
}
