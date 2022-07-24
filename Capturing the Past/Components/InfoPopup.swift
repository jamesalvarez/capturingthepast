//
//  InfoPopup.swift
//  Capturing the Past
//
//  Created by James Alvarez on 23/07/2022.
//

import Foundation

import SwiftUI

struct InfoPopup: View {
    @Binding var header: String
    @Binding var text: String
    @Binding var showingInfoPopup: Bool

    var body: some View {
        VStack(spacing: 12) {
            Text(header)
                .font(.system(size: 24))
                .padding(.top, 12)

            Text(.init(text))
                .font(.system(size: 16))
                .opacity(0.6)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 20)
                .minimumScaleFactor(0.01)

            Button("Ok") {
                showingInfoPopup = false
            }
            .buttonStyle(.plain)
            .font(.system(size: 18, weight: .bold))
            .padding(.vertical, 9)
            .padding(.horizontal, 12)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(12)
        }
        .padding(EdgeInsets(top: 37, leading: 24, bottom: 40, trailing: 24))
        .background(Color.black.cornerRadius(20))
        .padding(.horizontal, 40)
    }
}
