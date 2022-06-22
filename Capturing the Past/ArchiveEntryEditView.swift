//
//  ContentView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 14/06/2022.
//

import SwiftUI

/**
 * View for viewing and editing an archive entry
 */
struct ArchiveEntryEditView: View {
    @Binding var archiveEntry: ArchiveEntry
    var repositories = ["Repository 1", "Repository 2"]

    var body: some View {
        VStack {
            Form {
                Section {
                    /*
                     Picker(selection: $selectedRepositoryIndex, label: Text("Repository")) {
                         ForEach(0 ..< repositories.count) {
                             Text(self.repositories[$0])
                         }
                     }
                     */

                    TextField("Catalogue reference", text: $archiveEntry.catReference)
                    Stepper(value: $archiveEntry.item, in: 0...999) {
                        Text("Item: \(archiveEntry.item)")
                    }
                    Stepper(value: $archiveEntry.subItem, in: 0...999) {
                        Text("Sub Item: \(archiveEntry.subItem)")
                    }
                    /*
                     Stepper(value: $archiveEntry.specialCase, in: 0...999) {
                        Text("Special Case: \($archiveEntry.specialCase)")
                     }
                     */
                    TextField("Note", text: $archiveEntry.note)
                }
            }
        }
    }
}

struct ArchiveEntryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArchiveEntryEditView(archiveEntry: .constant(ArchiveEntry.sampleEntries[0]))
        }
    }
}
