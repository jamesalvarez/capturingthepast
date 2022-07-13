//
//  ArchiveEntriesView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 22/06/2022.
//

import SwiftUI

/**
 * View displays list of archive entries, it is the main app view for displaying
 * entries that have been saved
 */
struct ArchiveEntriesView: View {
    @Binding var archiveEntries: [ArchiveEntry]
    @Binding var repositories: [Repository]
    @State private var editedEntry: UUID? = nil
    @State private var editedData: ArchiveEntry.Data = .init()
    @State private var isEditing = false
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void

    func updateFromEditedData() {
        if let editedEntry = editedEntry {
            // Editing something already
            if let entryIndex = archiveEntries.firstIndex(where: { entry in
                entry.id == editedEntry
            }) {
                archiveEntries[entryIndex].update(from: editedData)
            }
        } else {
            // new
            let newEntry = ArchiveEntry(fromData: editedData)
            archiveEntries.append(newEntry)
        }
    }

    var body: some View {
        List {
            ForEach($archiveEntries, id: \.id) { $archiveEntry in
                Button(action: {
                    editedEntry = archiveEntry.id
                    editedData = archiveEntry.data
                    isEditing = true
                }) {
                    ArchiveEntryRowView(archiveEntry: archiveEntry)
                }
            }
        }
        .navigationTitle("Records")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    editedEntry = nil
                    editedData = ArchiveEntry.Data()
                    isEditing = true
                }) { Image(systemName: "plus") }
                    .accessibilityLabel("New archive entry")
            }
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink(destination: RepositoriesView(repositories: $repositories) {

                }) {
                Image(systemName: "building.columns")

                }.accessibilityLabel("Repository Settings")
            }
        }
        .fullScreenCover(isPresented: $isEditing, onDismiss: saveAction) {
            NavigationView {
                ArchiveEntryEditView(data: $editedData)
                    .navigationTitle("Edit Entry")
                    .navigationBarItems(leading: Button("Cancel") {
                        isEditing = false
                        editedEntry = nil
                    }, trailing:
                    HStack {
                        Button("Done") {
                            isEditing = false
                            updateFromEditedData()
                        }
                        Button("Next") {
                            updateFromEditedData()
                            editedEntry = nil
                            editedData = ArchiveEntry.Data()
                        }
                    })
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

/*
 .navigationTitle("Edit Archive Entry")
 .navigationBarItems(leading: Button("Cancel") {

 }, trailing: Button("Save") {
 archiveEntry.update(from: data)
 })
 */

struct ArchiveEntriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArchiveEntriesView(archiveEntries: .constant(ArchiveEntry.sampleEntries), repositories: .constant(Repository.initialRepositories), saveAction: {})
        }
    }
}
