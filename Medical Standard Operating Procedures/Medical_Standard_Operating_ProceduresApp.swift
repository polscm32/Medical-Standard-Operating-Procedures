//
//  Medical_SOPsApp.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 04.12.24.
//

/*
Abstract:
Main App Struct with injecting of the actor to the views.
*/


import SwiftUI
import SwiftData

@main
struct Medical_SOPsApp: App {
    private let storage: DataHandler
    private let modelContainer: ModelContainer
    private let viewModel: SOPViewModel

    init() {
        do {
            // Initialize the schema and model configuration
            let schema = Schema([SOP.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            // Create the model container and related components
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.storage = DataHandler(modelContainer: modelContainer)
            self.viewModel = SOPViewModel(modelContainer: modelContainer, storage: storage)
        } catch {
            fatalError("\(DebuggingIdentifiers.failed) Failed to initialize Model Container: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            TabBar(viewModel: viewModel)
        }
    }
}
