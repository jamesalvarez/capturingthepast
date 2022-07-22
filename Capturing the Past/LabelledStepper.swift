//
//  LabelledStepper.swift
//  Capturing the Past
//
//  Created by James Alvarez on 21/07/2022.
//

import SwiftUI

struct LabelledStepper: View {
    let title: String
    @Binding var value: Int
    let infoClickAction: () -> Void

    var body: some View {
        LabelledControl(title: title, infoClickAction: infoClickAction) {
            Stepper(value: $value, in: 0...999) {
                Text("\(value)")
            }
        }
    }
}

