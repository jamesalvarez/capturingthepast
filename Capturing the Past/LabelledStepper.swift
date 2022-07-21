//
//  LabelledStepper.swift
//  Capturing the Past
//
//  Created by James Alvarez on 21/07/2022.
//

import SwiftUI

struct LabelledStepper: View {
    var title: String
    @Binding var value: Int

    init(_ title: String, value: Binding<Int>) {
        self.title = title
        self._value = value
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color(.placeholderText))
                .offset(y: 0)
            Stepper(value: $value, in: 0...999) {
                Text("\(value)")
            }
        }
    }
}

