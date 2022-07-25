//
//  InfoPopup.swift
//  Capturing the Past
//
//  Created by James Alvarez on 23/07/2022.
//

import Foundation

import SwiftUI

struct InfoPopup: View {
    @Binding var popupContent: InfoPopupContent
    @Binding var showingInfoPopup: Bool

    var header: String
    var text: String

    enum InfoPopupContent : Equatable {
        case RepositorySelector, CatalogueReference, ItemLevel, SubItemLevel, SpecialCases, Note, Ref, RepositoryName, ArchonCode
    }

    init(popupContent: Binding<InfoPopupContent>, showingInfoPopup: Binding<Bool>) {
        self._popupContent = popupContent
        self._showingInfoPopup = showingInfoPopup

        switch popupContent.wrappedValue {
        case .RepositorySelector:
            header = "Repository Selector"
            text = "The repository selector sets the first segment of the catalogue reference. Normally this is a country code followed an Archon code. \n\nThe numbering scheme is used in The National Archive\'s Discovery Catalogue. The segment is inserted in the file name to associate the image with the source institution. \n\nAdd custom Archon Codes to identify other sources."
        case .CatalogueReference:
            header = "Catalogue Reference"
            text = "Enter the catalogue number to associate photos with a specific document in a catalogue.\n\nWhen working with sequences such as entire collections it may be convenient to use the optional controls below to increment the final levels of the catalogue reference. E.g. books or letters. Non sequential entry of reference numbers may be easier using a single text field.\n\nThe character limit for filenames is accumulated across all input fields though is not restricted as you may have a valid reason for creating filenames that do not work in common file systems. Instead a warning message is shown when 128 characters is exceeded, this would be a really long file name. Actual limits vary for according to file system, but 255 characters is likely to work."
        case .ItemLevel:
            header = "Item Level"
            text = "Optional - The incrementing and decrementing buttons are intended to help with sequential capture tasks such as working through a series or collection. The input is restricted to numeric values"
        case .SubItemLevel:
            header = "Sub Item Level"
            text = "Optional - The sub item is intended to  be used to associate photos with specific parts of an item. E.g. The individual pages of books or letters. \n\n\n\nFile names include a time stamp to enable unlimited numbers of photos for any reference number. \n\nThe sub item level is often used by projects to provide an additional level of catalogue description beyond the institutions catalogue numbering."
        case .SpecialCases:
            header = "Special Cases"
            text = "Optional - this control is intended to be reserved for special cases such as detached or torn document parts. The control adds a distinguishable identifier to the end of the reference using a combination of letters and numbers."
        case .Note:
            header = "Note"
            text = "Optional note field: Notes are stored with the reference in the log file."
        case .Ref:
            header = "Ref"
            text = "This is the final full reference that will appear the log file."
        case .RepositoryName:
            header = "Repository Name"
            text = "The human readable name for the repository e.g. London Metropolitan Archives."
        case .ArchonCode:
            header = "Archon Code"
            text = "See [TNA's](https://discovery.nationalarchives.gov.uk/browse/a/A) reference for Archon codes. We suggest short non-numeric codes (10 characters or less) to identify other respositories.\n\nNew repositories are added to the top of the list and become the default selection."
        }

    }

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
