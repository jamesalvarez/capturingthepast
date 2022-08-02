//
//  HorizontalLabelledControl.swift
//  Capturing the Past
//
//  Created by James Alvarez on 02/08/2022.
//

import SwiftUI

struct HorizontalLabelledControl<Content: View>: View {
    let title: String
    let infoClickAction: () -> Void
    var content: () -> Content

    var body: some View {
        HStack() {
            Button(action: {}) {
                Text(title)
                    .foregroundColor(Color.white)
                    .offset(y: 0)
                    .frame(minWidth: 130, alignment: .leading)

            }.onTapGesture {
                infoClickAction()
            }
            content()
        }
    }
}
