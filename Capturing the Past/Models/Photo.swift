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
struct Photo: Identifiable, Codable {
    var id: String
    var image: UIImage {
        do {
            return try FileManager().readImage(with: id)
        } catch {
            return UIImage(systemName: "photo.fill")!
        }
    }
}
