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
    @Binding var data: ArchiveEntry.Data
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

                    TextField("Catalogue reference", text: $data.catReference)
                    Spacer()
                    Stepper(value: $data.item, in: 0...999) {
                        Text("Item: \(data.item)")
                    }
                    Stepper(value: $data.subItem, in: 0...999) {
                        Text("Sub Item: \(data.subItem)")
                    }
                    Spacer()
                    /*
                     Stepper(value: $archiveEntry.specialCase, in: 0...999) {
                        Text("Special Case: \($archiveEntry.specialCase)")
                     }
                     */
                    TextField("Note", text: $data.note)
                }
            }
        }
        
    }
}

struct ArchiveEntryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArchiveEntryEditView(data: .constant(ArchiveEntry.sampleEntries[0].data))
        }
    }
}
