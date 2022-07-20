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

    init() {
        // To make Lists transparent to see background image
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ArchiveEntriesView(archiveEntries: $archiveEntriesStore.archiveEntries, repositories: $repositoriesStore.repositories) {
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
            .preferredColorScheme(.dark)
            .onAppear {
                ArchiveEntriesStore.load { result in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                        archiveEntriesStore.archiveEntries = ArchiveEntry.sampleEntries
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
