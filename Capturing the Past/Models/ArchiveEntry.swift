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
    var date: Date
    var repositoryID: String
    var catReference: String = ""
    var item: Int = 0
    var subItem: Int = 0
    var specialCase: String = ""
    var note: String = ""
    var photoRef: String = ""
    var referenceSequence: String {
        return generateReferenceSequence(repositoryID: repositoryID, catReference: catReference, item: item, subItem: subItem, specialCase: specialCase)
    }
}

/**
 * A static array of archive entries to help in previews
 */
extension ArchiveEntry {
    static let sampleEntries: [ArchiveEntry] =
        [
            ArchiveEntry(id: UUID(),
                         date: Date(),
                         repositoryID: Repository.sampleRepositories[0].archon,
                         catReference: "pye345/54/6",
                         item: 1,
                         subItem: 2,
                         specialCase: "",
                         note: "Design of operating table",
                         photoRef: ""),
            ArchiveEntry(id: UUID(),
                         date: Date(),
                         repositoryID: Repository.sampleRepositories[1].archon,
                         catReference: "pye345/54/6",
                         item: 1,
                         subItem: 3,
                         specialCase: "",
                         note: "Something else",
                         photoRef: "")
        ]
}

func generateReferenceSequence(repositoryID: String, catReference: String, item: Int, subItem: Int, specialCase: String) -> String {

        var catRef = "\(repositoryID)_\(catReference)_\(item)_\(subItem)"


        if specialCase.count > 0 {
            catRef += "_" + specialCase
        }

        catRef = catRef.uppercased()

        let bannedChars = CharacterSet(charactersIn: "!@#$%^&*").union(.whitespacesAndNewlines)

        catRef = catRef.components(separatedBy: bannedChars)
            .filter {!$0.isEmpty}
            .joined(separator: "")

        let pathChars = CharacterSet(charactersIn: "\\/_")

        catRef = catRef.components(separatedBy: pathChars)
            .filter {!$0.isEmpty}
            .joined(separator: "_")

        if catRef == "GB0000" {
            catRef = "Ref"
        }

        return catRef
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
        var photo: Photo = .init()
        var date: Date = .init()

        var referenceSequence: String? {
            if repositoryID == "" || catReference == "" {
                return nil
            } else {
                return generateReferenceSequence(repositoryID: repositoryID, catReference: catReference, item: item, subItem: subItem, specialCase: specialCase)
            }
        }

        func generatePhotoFileName() -> String? {
            guard let referenceSequence = referenceSequence else {
                return nil
            }

            let tag = String(referenceSequence.map {
                $0 == "/" ? "_" : ($0 == " " ? "_" : $0)
            })

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYYMMdd_HHmmss"
            let dateString = dateFormatter.string(from: date)
            return "cpast_\(dateString)_\(tag).jpg"
        }
    }

    var data: Data {
        let photo = Photo(fromFilename: photoRef)

        return Data(repositoryID: repositoryID, catReference: catReference, item: item, subItem: subItem, specialCase: specialCase, note: note, photo: photo, date: date)
    }

    mutating func update(from data: Data) {
        repositoryID = data.repositoryID
        catReference = data.catReference
        item = data.item
        subItem = data.subItem
        specialCase = data.specialCase
        note = data.note
        photoRef = data.photo.id
        date = data.date
    }

    init(fromData data: ArchiveEntry.Data) {
        id = UUID()
        repositoryID = data.repositoryID
        catReference = data.catReference
        item = data.item
        subItem = data.subItem
        specialCase = data.specialCase
        note = data.note
        photoRef = data.photo.id
        date = data.date
    }
}
