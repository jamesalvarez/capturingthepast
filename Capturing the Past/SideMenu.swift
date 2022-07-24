//
//  SideMenu.swift
//  Capturing the Past
//
//  Created by James Alvarez on 24/07/2022.
//

import SwiftUI

struct SideMenu: View {
    @Binding var repositories: [Repository]
    let onAppear: () -> Void
    let saveAction: () -> Void
    var body: some View {
        List {
            NavigationLink(destination: RepositoriesView(repositories: $repositories) {
                saveAction() // Triggers root save action when saving repositories
            }) {
                HStack {
                    Image(systemName: "building.columns")
                        .foregroundColor(
                            .orange)
                    Text("Repository Setup")
                        .foregroundColor(
                            .orange)
                }

            }
            .onAppear(perform: onAppear)
            .accessibilityLabel("Repository Settings")
            NavigationLink(destination: RepositoriesView(repositories: $repositories) {
                saveAction() // Triggers root save action when saving repositories
            }) {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(
                            .orange)
                    Text("Info")
                        .foregroundColor(
                            .orange)
                }
            }
            .onAppear(perform: onAppear)
            .accessibilityLabel("Information")
        }
    }
}
