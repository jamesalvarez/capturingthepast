//
//  CapturingThePastError.swift
//  Capturing the Past
//
//  Created by James Alvarez on 27/06/2022.
//

import SwiftUI

enum CapturingThePastError: Error, LocalizedError {
    case decodingError
    case encodingError
    case saveImageError
    case readImageError
    case cameraUnavailable
    case cameraRestricted
    case cameraDenied

    var errorDescription: String? {
        switch self {
        case .decodingError:
            return NSLocalizedString("There was a problem loading your list of photos, please create a new image to start over.", comment: "")
        case .encodingError:
            return NSLocalizedString("Could not save your Photo data, please reinstall the app.", comment: "")
        case .saveImageError:
            return NSLocalizedString("Could not save photo.  Please reinstall the app.", comment: "")
        case .readImageError:
            return NSLocalizedString("Could not load photo.  Please reinstall the app.", comment: "")
        case .cameraUnavailable:
            return NSLocalizedString("There is no available camera on this device", comment: "")
        case .cameraRestricted:
            return NSLocalizedString("You are not allowed to access media capture devices.", comment: "")
        case .cameraDenied:
            return NSLocalizedString("You have explicitly denied permission for media capture. Please open permissions/Privacy/Camera and grant access for this application.", comment: "")
        }

    }

    struct ErrorType: Identifiable {
        let id = UUID()
        let error: CapturingThePastError
        var message: String {
            error.localizedDescription
        }
        let button = Button("OK", role: .cancel) {}
    }
}
