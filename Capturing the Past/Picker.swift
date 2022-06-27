//
//  Picker.swift
//  Capturing the Past
//
//  Created by James Alvarez on 27/06/2022.
//

import UIKit

enum Picker {
    enum Source: String {
        case library, camera
    }
    
    static func checkPermissions() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            return true
        } else {
            return false
        }
    }
}
