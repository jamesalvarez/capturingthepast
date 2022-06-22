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
struct ArchiveEntry: Identifiable {
    let id: UUID
    var repositoryID: UUID
    var catReference: String
    var item: Int
    var subItem: Int
    var specialCase: String
    var note: String
    var referenceSequence: String
    var photoRefs: [String]
}

/**
 * A static array of archive entries to help in previews
 */
extension ArchiveEntry {

    static let sampleEntries: [ArchiveEntry] =
    [
        ArchiveEntry(id: UUID(),
                     repositoryID: Repository.initialRepositories[0].id,
                     catReference: "pye345/54/6",
                     item: 1,
                     subItem: 2,
                     specialCase: "",
                     note: "Design of operating table",
                     referenceSequence: "GB0387_PYE345_54_6_1_2",
                     photoRefs: []),
        ArchiveEntry(id: UUID(),
                     repositoryID: Repository.initialRepositories[0].id,
                     catReference: "pye345/54/6",
                     item: 1,
                     subItem: 3,
                     specialCase: "",
                     note: "Something else",
                     referenceSequence: "GB0387_PYE345_54_6_1_3",
                     photoRefs: [])
    ]
}
