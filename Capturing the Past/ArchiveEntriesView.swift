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


    var body: some View {
        List {
            Text("Records")
            ForEach($archiveEntries, id: \.id) { $archiveEntry in
                ArchiveEntryRowView(archiveEntry: archiveEntry)
            }
        }
        .background(BackgroundImage())
        .navigationTitle("Records")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ArchiveEntriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArchiveEntriesView(archiveEntries: .constant(ArchiveEntry.sampleEntries), repositories: .constant(Repository.initialRepositories))
        }
    }
}
