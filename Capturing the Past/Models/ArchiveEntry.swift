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
struct ArchiveEntry: Identifiable, Codable {
    let id: UUID
    var repositoryID: String
    var catReference: String = ""
    var item: Int = 0
    var subItem: Int = 0
    var specialCase: String = ""
    var note: String = ""
    var photoRefs: [String] = []
    var referenceSequence: String {
        get {
            return "\(repositoryID)_\(catReference)_\(item)_\(subItem)_\(specialCase)"
        }
    }
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
                         photoRefs: []),
            ArchiveEntry(id: UUID(),
                         repositoryID: Repository.initialRepositories[0].id,
                         catReference: "pye345/54/6",
                         item: 1,
                         subItem: 3,
                         specialCase: "",
                         note: "Something else",
                         photoRefs: [])
        ]
}

/**
  * Data type to contain editable properties of ArchiveEntry, to process edits and updates
 */
extension ArchiveEntry {
    struct Data {
        var repositoryID: String = ""
        var catReference: String = ""
        var item: Int = 0
        var subItem: Int = 0
        var specialCase: String = ""
        var note: String = ""
        var photos: [Photo] = []

        var referenceSequence: String {
            get {
                return "\(catReference)_\(item)_\(subItem)_\(specialCase)"
            }
        }
    }

    var data: Data {
        let photos = photoRefs.map { Photo(id: $0) }

        return Data(repositoryID: repositoryID, catReference: catReference, item: item, subItem: subItem, specialCase: specialCase, note: note, photos: photos)
    }

    mutating func update(from data: Data) {
        repositoryID = data.repositoryID
        catReference = data.catReference
        item = data.item
        subItem = data.subItem
        specialCase = data.specialCase
        note = data.note
        photoRefs = data.photos.map { $0.id }
    }

    init(fromData data: ArchiveEntry.Data) {
        id = UUID()
        repositoryID = data.repositoryID
        catReference = data.catReference
        item = data.item
        subItem = data.subItem
        specialCase = data.specialCase
        note = data.note
        photoRefs = data.photos.map { $0.id }
    }
}
