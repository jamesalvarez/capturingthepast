//
//  ConfirmationDialog.swift
//  Capturing the Past
//
//  Created by James Alvarez on 23/07/2022.
//

import SwiftUI

/**
 * The dialog shown after picking a photo to confirm or cancel adding it to the archive
 */
struct ConfirmationDialog: View {
    var image: UIImage
    var imageName: String
    var referenceSequence: String
    let archive: () -> Void
    let cancel: () -> Void
    var body: some View {
        Form {
            VStack {
                Text("Chosen image")
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
                LabelledControl(title: "Filename", infoClickAction: {}) {
                    Text(imageName).lineLimit(nil).minimumScaleFactor(0.01).foregroundColor(Color(.placeholderText))
                }
                LabelledControl(title: "Reference Sequence", infoClickAction: {}) {
                    Text(referenceSequence).lineLimit(nil).minimumScaleFactor(0.01).foregroundColor(Color(.placeholderText))
                }.frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                Text("Do you want to add this to the archive?")
                HStack(spacing: 20) {
                    Button(action: archive) {
                        Text("Archive")
                    }.buttonStyle(.plain)
                        .font(.system(size: 18, weight: .bold))
                        .padding(.vertical, 9)
                        .padding(.horizontal, 12)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .frame(width: 100)
                    Button(action: cancel) {
                        Text("Cancel")
                    }.buttonStyle(.plain)
                        .font(.system(size: 18, weight: .bold))
                        .padding(.vertical, 9)
                        .padding(.horizontal, 12)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(12)
                        .frame(width: 100)
                }
            }
        }
    }
}
