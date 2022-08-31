//
//  InfoView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 24/07/2022.
//

import SwiftUI

struct AppInfoView: View {
    @EnvironmentObject var archiveEntriesStore: ArchiveEntriesStore
    var body: some View {
        ScrollView {
            Form {
                Section("Resources") {
                    Text(.init("[Website](https://capturingthepast.benskitchen.com/)"))
                    Text(.init("[Instructions](https://blogs.sussex.ac.uk/capturing-the-past/2021/11/04/hello-world/)"))
                }
                Section("Capture Log") {
                    Text("A log file called CapturingThePast.csv is saved in your device's Documents folder and contains a list of all captures. Delete the log to reset it, or rename it to preserve it and start a fresh one.")
                }
                Section("Latest Captures") {
                    List {
                        ForEach(archiveEntriesStore.archiveEntries.suffix(min(5, archiveEntriesStore.archiveEntries.count)), id: \.id) { archiveEntry in
                            Text(archiveEntry.photoRef).font(.system(size: 12))
                        }
                    }
                }
                Section("Acknowledgements") {
                    Text(.init("Capturing the Past is a [Sussex Humanities Lab](https://www.sussex.ac.uk/research/centres/sussex-humanities-lab/) project funded by the [Arts and Humanities Research Council](https://ahrc.ukri.org/)"))
                }
            }
            .frame(height: UIScreen.main.bounds.height)
            .navigationTitle("Information")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
