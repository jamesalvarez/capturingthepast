//
//  RepositoryRowView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 13/07/2022.
//

import SwiftUI

/**
 * Displays an archive entry in a form suitable for a list
 */
struct RepositoryRowView: View {
    let repository: Repository
    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.name)
                .font(.headline)
        }
    }
}

struct RepositoryRowView_Previews: PreviewProvider {
    static var repository = Repository.initialRepositories[0]
    static var previews: some View {
        RepositoryRowView(repository: repository)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
