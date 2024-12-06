//
//  SOPDTO.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 05.12.24.
//

/*
Abstract:
A struct that conforms to Sendable to be able to be passed safely among different threads.
*/

import Foundation

struct SOPDTO: Hashable, Equatable, Sendable, Identifiable {
    var id: UUID
    var title: String
    var details: String
    var keywords: [String]
    var isFavorite: Bool
    var subject: String
    var screenshot: Data?
}
