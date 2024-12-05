//
//  AddSOPView.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 04.12.24.
//

/*
Abstract:
A SwiftUI add sheet for adding new SOPs.
*/

import SwiftUI
import SwiftData
import PhotosUI

struct AddSOPView: View {
    let storage: DataHandler
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var keywords: [String] = []
    @State private var screenshot: PhotosPickerItem?
    @State private var screenshotData: Data?
    @State private var isFavorite: Bool = false
    @State private var subject: Subject = .all
    @Binding var sops: [SOPStruct]
    
    var body: some View {
        Form {
            Section {
                TextField("SOP Name", text: $title)
                    .clearable($title)
            } header: {
                Text("SOP Name")
            } footer: {
                if title.isEmpty {
                    Text("Add a title for the new SOP")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            
            Section {
                TextField("Details", text: $details)
                    .clearable($details)
            } header: {
                Text("Details")
            }
            
              Section {
                  Picker("Favorite", selection: $isFavorite) {
                      Text("Yes").tag(true)
                      Text("No").tag(false)
                  }.pickerStyle(.menu)
                  
                  Picker("Subject", selection: $subject) {
                      ForEach(Subject.allCases, id: \.self) { subject in
                          Text(subject.rawValue.capitalized).tag(subject)
                      }
                  }.pickerStyle(.menu)
              } header: {
                  Text("Subject")
              }
            
            Section {
                HStack {
                    PhotosPicker(
                        selection: $screenshot,
                        matching: .images,
                        photoLibrary: .shared()) {
                            if let screenshotData, let uiImage = UIImage(data: screenshotData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else {
                                HStack {
                                    Image(systemName: "photo")
                                        .scaledToFit()
                                    Text("Add image")
                                }
                            }
                        }.overlay(alignment: .topTrailing) {
                            if screenshotData != nil {
                                Button {
                                    screenshot = nil
                                    screenshotData = nil
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .font(.title)
                                        .tint(.red)
                                }

                            }
                        }
                }
            } header: {
                Text("SOP screenshot")
            } footer: {
                if screenshotData == nil {
                    HStack {
                        Image(systemName: "hand.draw.fill").foregroundStyle(.primary)
                        Text("Add a screenshot for the new SOP")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            }
            
        }
        .listRowBackground(Color.clear)
        .navigationTitle("Add SOP")
        .navigationBarTitleDisplayMode(.inline)
       .toolbar {
           ToolbarItem(placement: .cancellationAction) {
               Button("Dismiss") {
                   dismiss()
               }
           }
           ToolbarItem(placement: .primaryAction) {
               Button("Done") {
                   addSOP()
                   dismiss()
               }
               .disabled(title.isEmpty || screenshotData == nil)
           }
       }
       .task(id: screenshot) {
           if let data = try? await screenshot?.loadTransferable(type: Data.self) {
               screenshotData = data
           }
       }
    }
    
    private func addSOP() {
        Task {
            let newSOP = await storage.addSOP(title: title, details: details, keywords: keywords, isFavorite: isFavorite, subject: subject, screenshot: screenshotData)
            await MainActor.run {
                sops.append(newSOP)
           }
        }
   }
}
