//
//  Photo.swift
//  Capturing the Past
//
//  Created by James Alvarez on 27/06/2022.
//

import SwiftUI

/**
 * Photo structure to hold and save UIImages in UI and on filesystem
 */
struct Photo {
    var id: String
    var image: UIImage

    init() {
        id = ""
        image = UIImage(systemName: "photo.fill")!
    }

    init(id: String, image: UIImage) {
        self.id = id
        self.image = image
    }

    init(fromFilename fileName : String) {
        self.id = fileName
        do {
            let fileURL = try photoPath(fileName: fileName)
            if let image = UIImage(contentsOfFile: fileURL.path) {
                self.image = image
            } else {
                self.image = UIImage(systemName: "photo.fill")!
            }
        } catch {
            self.image = UIImage(systemName: "photo.fill")!
        }

    }

    func save() throws {
        // get your UIImage jpeg data representation and check if the destination file url already exists
        let fileURL = try photoPath(fileName: id)
        if let data = image.jpegData(compressionQuality:  1),
           !FileManager.default.fileExists(atPath: fileURL.path) {
            // writes the image data to disk
            try data.write(to: fileURL)
        }
    }
}

func photoPath(fileName : String) throws -> URL {
    let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    return documentsDirectory.appendingPathComponent(fileName)
    }
