//
//  UpdateSOPView.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 04.12.24.
//

/*
Abstract:
A struct used in a sheet to update the SOPs.
*/

import SwiftUI
import PhotosUI

struct UpdateSOPView: View {
    let storage: DataHandler
    @Binding var sop: SOPDTO
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var keywords: [String] = []
    @State private var screenshot: PhotosPickerItem?
    @State private var screenshotData: Data?
    @State private var isFavorite: Bool = false
    @State private var subject: Subject = .all
    
    // Track whether any changes were made
    @State private var hasChanges: Bool = false
    
    var body: some View {
        Form {
            Section {
                TextField("SOP Name", text: $title)
                    .clearable($title)
                    .onChange(of: title) { checkForChanges() }
            } header: {
                Text("SOP Name")
            }
            
            Section {
                TextField("Details", text: $details)
                    .clearable($details)
                    .onChange(of: details) { checkForChanges() }
            } header: {
                Text("Details")
            }
            
            Section {
                Picker("Favorite", selection: $isFavorite) {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                }.pickerStyle(.menu)
                .onChange(of: isFavorite) { checkForChanges() }
                
                Picker("Subject", selection: $subject) {
                    ForEach(Subject.allCases, id: \.self) { subject in
                        Text(subject.rawValue.capitalized).tag(subject)
                    }
                }.pickerStyle(.menu)
                .onChange(of: subject) { checkForChanges() }
            } header: {
                Text("Subject")
            }
          
            Section {
                HStack {
                    PhotosPicker(
                        selection: $screenshot,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        if let screenshotData, let uiImage = UIImage(data: screenshotData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            HStack {
                                Image(systemName: "photo")
                                    .scaledToFit()
                                Text("Change image")
                            }
                        }
                    }
                    .onChange(of: screenshot) { checkForChanges() }
                    .overlay(alignment: .topTrailing) {
                        if screenshotData != nil {
                            Button {
                                screenshot = nil
                                screenshotData = nil
                                checkForChanges()
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .font(.title)
                                    .tint(.red)
                            }
                        }
                    }
                }
            } header: {
                Text("Add screenshot")
            }
        }
        .listRowBackground(Color.clear)
        .navigationTitle("Update SOP")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                    Task {
                        await updateSOP()
                        dismiss()
                    }
                }
                .disabled(!hasChanges) // Enable the button only if changes were made
            }
        }
        .onAppear {
            loadInitialValues()
        }
        .task(id: screenshot) {
            if let data = try? await screenshot?.loadTransferable(type: Data.self) {
                screenshotData = data
                checkForChanges()
            }
        }
    }
    
    // Load the initial values from the SOP object into the state variables
    private func loadInitialValues() {
        title = sop.title
        details = sop.details
        keywords = sop.keywords
        isFavorite = sop.isFavorite
        subject = Subject(rawValue: sop.subject) ?? .all // Map String to Subject, fallback to .all
        screenshotData = sop.screenshot
    }
    
    // Check whether the current state differs from the original SOP values
    private func checkForChanges() {
        hasChanges = title != sop.title ||
                     details != sop.details ||
                     keywords != sop.keywords ||
                     isFavorite != sop.isFavorite ||
                    subject.rawValue != sop.subject ||
                     screenshotData != sop.screenshot
    }
    
    // Update the SOP object with the modified values
    private func updateSOP() async {
        do {
            try await storage.updateSOP(withId: sop.id, title: title, details: details, keywords: keywords, isFavorite: isFavorite, subject: subject, screenshot: screenshotData)
            await MainActor.run {
                           sop.title = title
                           sop.details = details
                           sop.keywords = keywords
                           sop.isFavorite = isFavorite
                           sop.subject = subject.rawValue
                           sop.screenshot = screenshotData
                       }
        } catch {
            debugPrint("\(DebuggingIdentifiers.failed) Failed to update SOP: \(error)")
        }
    }
}
