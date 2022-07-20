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
    var date: Date = Date()
    var repositoryID: String
    var catReference: String = ""
    var item: Int = 0
    var subItem: Int = 0
    var specialCase: String = ""
    var note: String = ""
    var photoRef: String = ""
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
                         repositoryID: Repository.sampleRepositories[0].archon,
                         catReference: "pye345/54/6",
                         item: 1,
                         subItem: 2,
                         specialCase: "",
                         note: "Design of operating table",
                         photoRef: ""),
            ArchiveEntry(id: UUID(),
                         repositoryID: Repository.sampleRepositories[1].archon,
                         catReference: "pye345/54/6",
                         item: 1,
                         subItem: 3,
                         specialCase: "",
                         note: "Something else",
                         photoRef: "")
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
        var photo: Photo = Photo()

        /*
         private String createCatRef() {
         catRef = strArchon;
         if(strRef.length()>0){
         catRef+=  "/" + strRef;
         }
         if(strItem.length()>0){
         catRef+="/" + strItem;
         }
         if (strSubItem.length()>0){
         catRef+="/" + strSubItem;
         }
         if(strPart.length()>0){
         catRef+= strPart;
         }

         catRef = catRef.replaceAll("\\s+", "").toUpperCase();
         catRef = catRef.replaceAll("//", "/");
         catRef = catRef.replaceAll("/", "_");
         catRef = catRef.replaceAll("[!@#$%^&*]", "_");
         catRef = catRef.replaceAll("\\\\\\\\", "\\\\");
         catRef = catRef.replaceAll("\\\\", "_");

         if (catRef.equals("GB0000")) {
         catRef = "Ref";
         }
         catRef = catRef.replaceAll("_{2,}", "_");
         if (catRef.length() > 128) {
         Toast.makeText(this, "Your catalogue reference is very long and may result in unusable file names.", Toast.LENGTH_SHORT).show();
         }
         return catRef;
         }
         */
        var referenceSequence: String {
            get {
                return "\(repositoryID)_\(catReference)_\(item)_\(subItem)_\(specialCase)"
            }
        }
    }

    var data: Data {
        let photo = Photo(fromFilename: photoRef)

        return Data(repositoryID: repositoryID, catReference: catReference, item: item, subItem: subItem, specialCase: specialCase, note: note, photo: photo)
    }

    mutating func update(from data: Data) {
        repositoryID = data.repositoryID
        catReference = data.catReference
        item = data.item
        subItem = data.subItem
        specialCase = data.specialCase
        note = data.note
        photoRef = data.photo.id
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
    }
}
