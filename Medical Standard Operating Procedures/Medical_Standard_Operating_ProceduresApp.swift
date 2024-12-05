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
    private let storage: DataHandler = {
        let schema = Schema([SOP.self,
                            ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            return DataHandler(modelContainer: modelContainer)
        } catch {
            fatalError("\(DebuggingIdentifiers.failed) Failed to create Model Container: \(error)")
        }
        
    }()

    var body: some Scene {
        WindowGroup {
            TabBar(storage: storage)
        }
    }
}

