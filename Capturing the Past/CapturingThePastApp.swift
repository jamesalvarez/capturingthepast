//
//  Capturing_the_PastApp.swift
//  Capturing the Past
//
//  Created by James Alvarez on 14/06/2022.
//

import SwiftUI

@main
struct CapturingThePastApp: App {
    @StateObject private var store = ArchiveEntriesStore()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ArchiveEntriesView(archiveEntries: $store.archiveEntries)
            }
            .onAppear {
                ArchiveEntriesStore.load { result in

                    switch result {
                    case .failure(let error):

                        fatalError(error.localizedDescription)

                    case .success(let archiveEntries):

                        store.archiveEntries = archiveEntries
                    }
                }
            }
        }
    }
}
