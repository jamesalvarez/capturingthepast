//
//  LabelledControl.swift
//  Capturing the Past
//
//  Created by James Alvarez on 22/07/2022.
//

import SwiftUI

struct LabelledControl<Content: View>: View {
    let title: String
    let infoClickAction: () -> Void
    var content: () -> Content

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {}) {
                Text(title)
                    .foregroundColor(Color.white)
                    .offset(y: 0)
            }.onTapGesture {
                infoClickAction()
            }
            content()
        }
    }
}
