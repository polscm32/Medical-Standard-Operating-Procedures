//
//  SOPViewModel.swift
//  Medical Standard Operating Procedures
//
//  Created by Marvin Polscheit on 06.12.24.
//

import Foundation
import SwiftData

@Observable
final class SOPViewModel: Sendable {
    let modelContainer: ModelContainer
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    func fetchSOPs(with descriptor: FetchDescriptor<SOP>) async throws -> [SOPDTO]{
        let actor = DataHandler(modelContainer: modelContainer)
        let result = try await actor.fetchSOPs(with: descriptor)
        return result
    }
}
