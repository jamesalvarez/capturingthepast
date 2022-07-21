//
//  RepositoriesView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 13/07/2022.
//

import SwiftUI

/**
 * View displays list of repositories and UI to edit
 */
struct RepositoriesView: View {
    @Binding var repositories: [Repository]
    @State private var editedEntry: String? = nil
    @State private var editedData: Repository.Data = .init()
    @State private var isEditing = false
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void

    func updateFromEditedData() {
        if let editedEntry = editedEntry {
            // Editing something already
            if let entryIndex = repositories.firstIndex(where: { entry in
                entry.id == editedEntry
            }) {
                repositories[entryIndex].update(from: editedData)
            }
        } else {
            // new
            let newEntry = Repository(fromData: editedData)
            repositories.append(newEntry)
        }
    }

    var body: some View {
        List {
            Text("A list of your repositories.  Tap to edit the name or code. To add a new one tap the plus icon.")
            ForEach($repositories, id: \.id) { $repository in
                Button(action: {
                    editedEntry = repository.id
                    editedData = repository.data
                    isEditing = true
                }) {
                    RepositoryRowView(repository: repository)
                }
            }
        }
        .navigationTitle("Repositories")
        .navigationBarTitleDisplayMode(.inline)
        .background(BackgroundImage())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    editedEntry = nil
                    editedData = Repository.Data()
                    isEditing = true
                }) { Image(systemName: "plus") }
                    .accessibilityLabel("New repository")
            }
        }
        .fullScreenCover(isPresented: $isEditing, onDismiss: saveAction) {
            NavigationView {
                RepositoryEditView(data: $editedData)
                    .navigationTitle("Edit Repository")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading: Button("Cancel") {
                        isEditing = false
                        editedEntry = nil
                    }, trailing:
                                            HStack {
                        Button("Done") {
                            isEditing = false
                            updateFromEditedData()
                        }
                    })
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}


struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RepositoriesView(repositories: .constant(Repository.initialRepositories), saveAction: {})
        }
    }
}
