//
//  ArchiveEntry.swift
//  Capturing the Past
//
//  Created by James Alvarez on 22/06/2022.
//

import SwiftUI

/**
 * ArchiveEntry: Stores the user's selected references alongside a link
 * to the repository and the filenames for the photos taken
 */
struct ArchiveEntry {
    var id: UUID
    var repository: Repository
    var catReference: String
    var item: Int
    var subItem: Int
    var specialCase: String
    var note: String
    var referenceSequence: String
    var photoRefs: [String]
}
