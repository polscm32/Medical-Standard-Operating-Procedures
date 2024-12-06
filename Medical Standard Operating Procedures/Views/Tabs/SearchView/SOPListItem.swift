//
//  SOPListItem.swift
//  Medical_SOPs
//
//  Created by Marvin Polscheit on 04.12.24.
//

/*
 Abstract:
 A single list item representing a SOP entry in a list.
 Displays the SOP title, subject, and a favorite indicator if applicable.
 */

import SwiftUI

struct SOPListItem: View {
    var sop: SOPDTO
    
    var body: some View {
        NavigationLink(value: sop) {
            HStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(sop.title)
                        .font(.headline)
                    Text(sop.subject.capitalized)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if sop.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                }
            }
        }
    }
}
