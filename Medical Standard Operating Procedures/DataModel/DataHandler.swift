//
//  ModelHandler.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 05.12.24.
//

/*
Abstract:
An actor that provides a SwiftData model container for the whole app.
*/

import Foundation
import SwiftData

@ModelActor
actor DataHandler {
    // MARK: - Method to create a new SOP entry
    func addSOP(title: String, details: String, keywords: [String], isFavorite: Bool, subject: Subject, screenshot: Data?) -> SOPStruct {
        let newSOP = SOP(
            id: UUID(),
            title: title,
            details: details,
            keywords: keywords,
            isFavorite: isFavorite,
            subject: subject,
            screenshot: screenshot
        )
        
        modelContext.insert(newSOP)
       
        do {
            try modelContext.save()
        } catch let error as NSError {
            debugPrint("\(DebuggingIdentifiers.failed) Failure saving SOP: \(error)")
        }
        
        return SOPStruct(
            id: UUID(),
            title: title,
            details: details,
            keywords: keywords,
            isFavorite: isFavorite,
            subject: subject.rawValue,
            screenshot: screenshot
        )
    }
    
    // MARK: - Method to delete existing SOP
    func deleteSOP(withId id: UUID) throws {
           let predicate = #Predicate<SOP> { sop in
               return sop.id == id
           }
           try modelContext.delete(model: SOP.self, where: predicate)
       }
       
    // MARK: - Method to fetch existing SOPs
    func fetchSOPs(with descriptor: FetchDescriptor<SOP>) throws -> [SOPStruct] {
           return try modelContext
               .fetch(descriptor)
               .map {
                   SOPStruct(
                    id: $0.id,
                    title: $0.title,
                    details: $0.details,
                    keywords: $0.keywords,
                    isFavorite: $0.isFavorite,
                    subject: $0.subjectRawValue,
                    screenshot: $0.screenshot
                   )
               }
       }
    
    // MARK: - Method to update an existing SOP
    func updateSOP(withId id: UUID, title: String?, details: String?, keywords: [String]?, isFavorite: Bool?, subject: Subject?, screenshot: Data?) throws {
        let predicate = #Predicate<SOP> { sop in
            sop.id == id
        }
        
        let fetchDescriptor = FetchDescriptor<SOP>(predicate: predicate, sortBy: [SortDescriptor(\SOP.id)])
        let existingSOPs = try modelContext.fetch(fetchDescriptor)
        guard let sopToUpdate = existingSOPs.first else { return }
        
        // Update the fields if new values are provided
        if let title = title {
            sopToUpdate.title = title
        }
        if let details = details {
            sopToUpdate.details = details
        }
        if let keywords = keywords {
            sopToUpdate.keywords = keywords
        }
        if let isFavorite = isFavorite {
            sopToUpdate.isFavorite = isFavorite
        }
        if let subject = subject {
            sopToUpdate.subject = subject
        }
        if let screenshot = screenshot {
            sopToUpdate.screenshot = screenshot
        }
        
        // Save the context
        try modelContext.save()
    }
}
