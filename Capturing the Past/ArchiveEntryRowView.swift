//
//  ArchiveEntryRowView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 22/06/2022.
//

import SwiftUI

/**
 * Displays an archive entry in a form suitable for a list
 */
struct ArchiveEntryRowView: View {
    let archiveEntry: ArchiveEntry
    var body: some View {
        VStack(alignment: .leading) {
            Text(archiveEntry.referenceSequence)
                .font(.headline)
        }
    }
}

struct ArchiveEntryRowView_Previews: PreviewProvider {
    static var archiveEntry = ArchiveEntry.sampleEntries[0]
    static var previews: some View {
        ArchiveEntryRowView(archiveEntry: archiveEntry)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
