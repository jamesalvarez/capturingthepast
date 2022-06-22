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

    var body: some View {
        List {
            ForEach($archiveEntries) { $archiveEntry in
                NavigationLink(destination: ArchiveEntryEditView(archiveEntry: $archiveEntry)) {
                    ArchiveEntryRowView(archiveEntry: archiveEntry)
                }
            }
        }
        .navigationTitle("Archives")
        .toolbar {
            Button(action: {}) {
                Image(systemName: "plus")
            }
        }
    }
}

struct ArchiveEntriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArchiveEntriesView(archiveEntries: .constant(ArchiveEntry.sampleEntries))
        }
    }
}
