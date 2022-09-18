//
//  SideMenu.swift
//  Capturing the Past
//
//  Created by James Alvarez on 24/07/2022.
//

import SwiftUI

struct SideMenu: View {
    let onAppear: () -> Void
    var body: some View {
        List {
            NavigationLink(destination: RepositoriesView()) {
                HStack {
                    Image(systemName: "building.columns")
                        .foregroundColor(
                            .orange)
                    Text("Repository Setup")
                        .foregroundColor(
                            .white)
                }
            }
            .onAppear(perform: onAppear)
            .accessibilityLabel("Repository Settings")
            NavigationLink(destination: AppInfoView()) {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(
                            .orange)
                    Text("Info")
                        .foregroundColor(
                            .white)
                }
            }
            .onAppear(perform: onAppear)
            .accessibilityLabel("Information")
            Spacer()
            HStack {
                Image(systemName: "photo")
                    .foregroundColor(
                        .orange)
                Text("Browse photos")
                    .foregroundColor(
                        .white)
            }.onTapGesture {
                guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                      let components = NSURLComponents(url: documentDirectory, resolvingAgainstBaseURL: true) else {
                    return
                }
                components.scheme = "shareddocuments"

                if let sharedDocuments = components.url {
                    UIApplication.shared.open(
                        sharedDocuments,
                        options: [:],
                        completionHandler: nil
                    )
                }
            }
            .accessibilityLabel("Browse Photos")
        }
    }
}
