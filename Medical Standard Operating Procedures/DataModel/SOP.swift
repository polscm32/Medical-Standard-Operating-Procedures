//
//  SOP.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 04.12.24.
//

/*
Abstract:
The model class of Standard operating procedures (SOPs).
*/

import Foundation
import SwiftData

@Model
final class SOP {
    #Index<SOP>([\.id, \.title, \.details, \.keywords])
    #Unique<SOP>([\.id, \.title]) // Unique constraints
    
    @Attribute(.preserveValueOnDeletion) // Capture unique columns to use persistent history tracking
    var id: UUID
    
    @Attribute(.preserveValueOnDeletion)
    var title: String
    
    var details: String
    var keywords: [String]
    var isFavorite: Bool = false
    
    var subjectRawValue: String
    
    var subject: Subject {
           get {
               Subject(rawValue: subjectRawValue) ?? .all
           }
           set {
               subjectRawValue = newValue.rawValue
           }
       }
    
    @Attribute(.externalStorage)
    var screenshot: Data?
    
    init(id: UUID, title: String, details: String, keywords: [String], isFavorite: Bool, subject: Subject, screenshot: Data? = nil) {
            self.id = id
            self.title = title
            self.details = details
            self.keywords = keywords
            self.isFavorite = isFavorite
            self.subjectRawValue = subject.rawValue
            self.screenshot = screenshot
        }
}

enum Subject: String, CaseIterable, Codable {
    case neurology = "Neurology"
    case cardiology = "Cardiology"
    case gastroenterology = "Gastroenterology"
    case oncology = "Oncology"
    case all = "All"
}

extension Subject {
    var symbolName: String {
        switch self {
        case .neurology:
            return "brain.head.profile"
        case .cardiology:
            return "heart.fill"
        case .gastroenterology:
            return "fork.knife"
        case .oncology:
            return "cross.vial"
        case .all:
            return "globe"
        }
    }
}

extension Subject {
    var abbreviation: String {
        switch self {
        case .neurology:
            return "Neuro"
        case .cardiology:
            return "Cardio"
        case .gastroenterology:
            return "Gastro"
        case .oncology:
            return "Onco"
        case .all:
            return "All"
        }
    }
}
