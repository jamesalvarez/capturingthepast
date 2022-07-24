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
    @EnvironmentObject var repositoriesStore: RepositoriesStore
    @State private var editedEntry: String? = nil
    @State private var editedData: Repository.Data = .init()
    @State private var isEditing = false
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: () -> Void
    @State var showResetPopup = false
    @State var justDeleted: Repository? = nil
    @State var deletedIndex: Int = 0
    @State var showDeleteToast = false

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
            if let entryIndex = repositoriesStore.repositories.firstIndex(where: { entry in
                entry.id == editedEntry
            }) {
                repositoriesStore.repositories[entryIndex].update(from: editedData)
            }
        } else {
            // new
            let newEntry = Repository(fromData: editedData)
            repositoriesStore.repositories.append(newEntry)
        }
    }

    func resetRepositoriesList(_ listName: String) {
        repositoriesStore.repositories = Repository.loadBundledRepositoryList(name: listName)
    }

    func deleteRepository(repository: Repository) {
        justDeleted = repository
        if let entryIndex = repositoriesStore.repositories.firstIndex(where: { entry in
            entry.id == repository.id
        }) {
            repositoriesStore.repositories.remove(at: entryIndex)
            deletedIndex = entryIndex
            showDeleteToast = true
        }
    }

    func undoDelete() {
        if let repository = justDeleted {
            repositoriesStore.repositories.insert(repository, at: deletedIndex)
        }
    }

    var body: some View {
        List {
            Text("A list of your repositories.  Tap to edit the name or code. To add a new one tap the plus icon.")
            ForEach($repositoriesStore.repositories, id: \.id) { $repository in
                Button(action: {
                    editedEntry = repository.id
                    editedData = repository.data
                    isEditing = true
                }) {
                    RepositoryRowView(repository: repository, deleteAction: deleteRepository)
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
                Button(action: { resetRepositoriesList("DefaultRepositories") }) {
                    Text("Reset to Default List")
                }
                .foregroundColor(.red)
                Button(action: { resetRepositoriesList("ShortRepositories") }) {
                    Text("Reset to Short List")
                }
                .foregroundColor(.red)
                Button(action: { resetRepositoriesList("AlternativeRepositories") }) {
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
        .popup(isPresented: $showDeleteToast, type: .floater(), position: .bottom, animation: .spring(), autohideIn: 4) {
            HStack(spacing: 8) {
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)

                Text("Repository deleted")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                Button(action: undoDelete, label: {Text("Undo")})
            }
            .padding(16)
            .background(Color(hex: "b37407").cornerRadius(12))
            .padding(.horizontal, 16)
        }
    }
}

