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

    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color(.placeholderText))
                .offset(y: 0)
            TextField("Enter \(title)", text: $text)
        }
    }
}
