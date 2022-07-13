//
//  Capturing_the_PastApp.swift
//  Capturing the Past
//
//  Created by James Alvarez on 14/06/2022.
//

import SwiftUI

@main
struct CapturingThePastApp: App {
    @StateObject private var archiveEntriesStore = ArchiveEntriesStore()
    @StateObject private var repositoriesStore = RepositoriesStore()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ArchiveEntriesView(archiveEntries: $archiveEntriesStore.archiveEntries) {
                    ArchiveEntriesStore.save(archiveEntries: archiveEntriesStore.archiveEntries) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                    RepositoriesStore.save(Repositories: repositoriesStore.repositories) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            }
            .onAppear {
                ArchiveEntriesStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let archiveEntries):
                        archiveEntriesStore.archiveEntries = archiveEntries
                    }
                }
                RepositoriesStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let repositories):
                        repositoriesStore.repositories = repositories
                    }
                }
            }
        }
    }
}
