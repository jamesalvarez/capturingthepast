//
//  LabelledTextView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 20/07/2022.
//

import SwiftUI

struct LabelledTextView: View {
    var title: String
    @Binding var text: String
    let infoClickAction: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {}) {
            Text(title)
                .foregroundColor(Color(.placeholderText))
                .offset(y: 0)
            }.onTapGesture {
                infoClickAction()
            }
            TextField("Enter \(title)", text: $text)
        }
    }
}
