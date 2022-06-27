//
//  ViewModel.swift
//  Capturing the Past
//
//  Created by James Alvarez on 27/06/2022.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
    
    func showPhotoPicker() {
        if source == .camera {
            if !Picker.checkPermissions() {
                print("There is no camera on this device")
                return
            }
        }
        showPicker = true
    }
}
