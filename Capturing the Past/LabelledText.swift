//
//  LabelledText.swift
//  Capturing the Past
//
//  Created by James Alvarez on 21/07/2022.
//

import SwiftUI

struct LabelledText: View {
    let title: String
    var text: String
    let infoClickAction: () -> Void

    var body: some View {
        LabelledControl(title: title, infoClickAction: infoClickAction) {
            Text(text)
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
}
