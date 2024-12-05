//
//  SOPDetailView.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 04.12.24.
//

/*
Abstract:
A view that displays the details of a selected SOP, and allows editing it.
When changes are made and confirmed, it refetches the updated SOP.
*/

import SwiftUI
import SwiftData

struct SOPDetailView: View {
    let storage: DataHandler
    @State var sop: SOPStruct
    @State private var showUpdateSheet: Bool = false
    @State private var hasUpdated: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(sop.title)
                    .font(.title)
                    .bold()
                if sop.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.title)
                        .foregroundStyle(.yellow)
                }
            }
            .padding()
            
            Text(sop.details)
                .font(.body)
                .foregroundStyle(.secondary)
                .padding()
            
            if let screenshot = sop.screenshot, let img = UIImage(data: screenshot) {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: UIScreen.main.bounds.width - 10, maxHeight: UIScreen.main.bounds.height * 0.75)
                    .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showUpdateSheet = true
                } label: {
                    Text("Edit SOP")
                }
            }
        }
           .sheet(isPresented: $showUpdateSheet, content: {
               NavigationStack {
                   UpdateSOPView(
                       storage: storage,
                       sop: $sop
                   )
                       .navigationTitle("Edit SOP")
                       .navigationBarTitleDisplayMode(.inline)
                       .toolbar {
                           ToolbarItem(placement: .cancellationAction) {
                               Button("Cancel") {
                                   showUpdateSheet = false
                               }
                           }
                       }
               }
           })
        .navigationTitle("SOP Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
