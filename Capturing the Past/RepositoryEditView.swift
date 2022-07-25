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
    @State var popupContent: InfoPopup.InfoPopupContent = .RepositorySelector

    var body: some View {
        VStack {
            Text("Edit the repository's name and code")
            Form {
                VStack {
                    LabelledTextView(title: "Repository Name", text: $data.name, infoClickAction: {
                        popupContent = .RepositoryName
                        showingInfoPopup = true
                    })

                    Spacer()
                    // TODO: Check that id is not the same as any others
                    LabelledTextView(title: "Archon code", text: $data.archon, infoClickAction: {
                        popupContent = .ArchonCode
                        showingInfoPopup = true
                    })
                }
            }
        }
        .background(BackgroundImage())
        .popup(isPresented: $showingInfoPopup, type: .default, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
            InfoPopup(popupContent: $popupContent, showingInfoPopup: $showingInfoPopup)
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
