//
//  RepositoriesView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 13/07/2022.
//

import PopupView
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
    let saveAction: () -> Void
    @State var showResetPopup = false

    var repositoriesResetButton: some View {
        Button {
            showResetPopup = true
        } label: {
            Image(systemName: "arrow.counterclockwise.circle")
        }
    }

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

    func resetRepositoriesList(_ listName: String) {
        repositories = Repository.loadBundledRepositoryList(name: listName)
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                repositoriesResetButton
            }
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
        .popup(isPresented: $showResetPopup, type: .floater(verticalPadding: 0, useSafeAreaInset: false), position: .bottom, closeOnTapOutside: true, backgroundColor: .black.opacity(0.4)) {
            VStack(spacing: 12) {
                Text("Reset to defaults")
                    .font(.system(size: 24))
                    .padding(.top, 4)
                Text("Note: Selecting a preset will overwrite any respository list customisations")
                Divider()
                Button(action: {resetRepositoriesList("DefaultRepositories")}) {
                    Text("Reset to Default List")
                }
                .foregroundColor(.red)
                Button(action: {resetRepositoriesList("ShortRepositories")}) {
                    Text("Reset to Short List")
                }
                .foregroundColor(.red)
                Button(action: {resetRepositoriesList("AlternativeRepositories")}) {
                    Text("Reset to Alternative List")
                }
                .foregroundColor(.red)
                Button(action: { showResetPopup = false }) {
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
            .padding(EdgeInsets(top: 37, leading: 24, bottom: 40, trailing: 24))
            .background(Color.black.cornerRadius(20))
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
