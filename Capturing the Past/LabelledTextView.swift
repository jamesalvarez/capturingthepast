//
//  LabelledTextView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 20/07/2022.
//

import SwiftUI

struct LabelledTextView: View {
    let title: String
    @Binding var text: String
    let infoClickAction: () -> Void

    var body: some View {
        LabelledControl(title: title, infoClickAction: infoClickAction) {
            TextField("Enter \(title)", text: $text)
        }
    }
}
