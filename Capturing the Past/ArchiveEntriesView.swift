//
//  ArchiveEntriesView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 22/06/2022.
//

import SwiftUI

/**
 * View displays list of archive entries
 */
struct ArchiveEntriesView: View {

    let archiveEntries: [ArchiveEntry]
    
    var body: some View {
        List {
            ForEach(archiveEntries, id: \.id) { archiveEntry in
                ArchiveEntryRowView(archiveEntry: archiveEntry)
            }
        }
    }

}


struct ArchiveEntriesView_Previews: PreviewProvider {

    static var previews: some View {

        ArchiveEntriesView(archiveEntries: ArchiveEntry.sampleEntries)

    }

}
