//
//  FileManager+Extension.swift
//  Capturing the Past
//
//  Created by James Alvarez on 27/06/2022.
//

import UIKit

let fileName = ""

extension FileManager {
    static var docDirURL: URL {
        return Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func docExist(named docName: String) -> Bool {
        fileExists(atPath: Self.docDirURL.appendingPathComponent(docName).path)
    }

    func saveImage(_ id: String, image: UIImage) throws {
        if let data = image.jpegData(compressionQuality: 0.6) {
            let imageURL = FileManager.docDirURL.appendingPathComponent("\(id).jpg")
            do {
                try data.write(to: imageURL)
            } catch {
                throw CapturingThePastError.saveImageError
            }
        } else {
            throw CapturingThePastError.saveImageError
        }
    }

    func readImage(with id: String) throws -> UIImage {
        let imageURL = FileManager.docDirURL.appendingPathComponent("\(id).jpg")
        do {
            let imageData = try Data(contentsOf: imageURL)
            if let image = UIImage(data: imageData) {
                return image
            } else {
                throw CapturingThePastError.readImageError
            }
        } catch {
            throw CapturingThePastError.readImageError
        }
    }
}
