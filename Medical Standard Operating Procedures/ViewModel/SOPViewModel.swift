//
//  SOPViewModel.swift
//  Medical Standard Operating Procedures
//
//  Created by Marvin Polscheit on 06.12.24.
//

/*
Abstract:
A view model to handle all the CRUD operations on a background thread using the DataHandler actor.
*/

import Foundation
import SwiftData

@Observable
final class SOPViewModel: Sendable {
    let modelContainer: ModelContainer
    let storage: DataHandler
    
    init(modelContainer: ModelContainer, storage: DataHandler) {
        self.modelContainer = modelContainer
        self.storage = storage
    }
    
    func addSOP(title: String, details: String, keywords: [String], isFavorite: Bool, subject: Subject, screenshot: Data?) async -> SOPDTO {
        return await storage.addSOP(title: title, details: details, keywords: keywords, isFavorite: isFavorite, subject: subject, screenshot: screenshot)
    }
    
    func fetchSOPs(with predicate: Predicate<SOP>) async throws -> [SOPDTO]{
        let fetchDescriptor = FetchDescriptor<SOP>(predicate: predicate, sortBy: [SortDescriptor(\SOP.id)])
        return try await storage.fetchSOPs(with: fetchDescriptor)
    }
    
    func deleteSOP(with id: UUID) async throws {
        try await storage.deleteSOP(with: id)
    }
    
    func updateSOP(with id: UUID, title: String, details: String, keywords: [String], isFavorite: Bool, subject: Subject, screenshot: Data?) async throws {
        try await storage.updateSOP(with: id, title: title, details: details, keywords: keywords, isFavorite: isFavorite, subject: subject, screenshot: screenshot)
    }
}
