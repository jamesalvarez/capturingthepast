//
//  RepositoryEditView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 13/07/2022.
//

import PopupView
import SwiftUI
/**
 * View for viewing and editing an archive entry
 */
struct RepositoryEditView: View {
    @Binding var data: Repository.Data
    @State var showingInfoPopup = false
    @State var infoPopupHeader: String = ""
    @State var infoPopupText: String = ""

    var body: some View {
        VStack {
            Text("Edit the repository's name and code")
            Form {
                VStack {
                    LabelledTextView(title: "Repository Name", text: $data.name, infoClickAction: {
                        infoPopupHeader = "Repository Name"
                        infoPopupText = "The human readable name for the repository e.g. London Metropolitan Archives."
                        showingInfoPopup = true
                    })

                    Spacer()
                    // TODO: Check that id is not the same as any others
                    LabelledTextView(title: "Archon code", text: $data.archon, infoClickAction: {
                        infoPopupHeader = "Archon Code"
                        infoPopupText = "See [TNA's](https://discovery.nationalarchives.gov.uk/browse/a/A) reference for Archon codes. We suggest short non-numeric codes (10 characters or less) to identify other respositories.\n\nNew repositories are added to the top of the list and become the default selection."
                        showingInfoPopup = true
                    })
                }
            }
        }
        .background(BackgroundImage())
        .popup(isPresented: $showingInfoPopup, type: .default, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
            InfoPopup(header: infoPopupHeader, text: infoPopupText, showingInfoPopup: $showingInfoPopup)
        }
    }
}

struct RepositoryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RepositoryEditView(data: .constant(Repository.initialRepositories[0].data))
        }
    }
}
