//
//  RepositoryEditView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 13/07/2022.
//

import SwiftUI

/**
 * View for viewing and editing an archive entry
 */
struct RepositoryEditView: View {
    @Binding var data: Repository.Data

    var dataFields: some View {
        VStack {
            TextField("Name", text: $data.name)
            Spacer()
            TextField("Code", text: $data.code)
        }
    }


    var body: some View {
        VStack {
            Text("Edit the repository's name and code")
            Form {
                dataFields
            }
        }
    }
}

struct RepositoryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RepositoryEditView(data: .constant(Repository.initialRepositories[0].data))
        }
    }
}

