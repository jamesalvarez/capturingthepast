//
//  LabelledText.swift
//  Capturing the Past
//
//  Created by James Alvarez on 21/07/2022.
//

import SwiftUI

struct LabelledText: View {
    var title: String
    var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color(.placeholderText))
                .offset(y: 0)
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
