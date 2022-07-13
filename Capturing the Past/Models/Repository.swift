//
//  Repository.swift
//  Capturing the Past
//
//  Created by James Alvarez on 22/06/2022.
//

import Foundation

/**
 * Repository structure - normally this is a country code followed by an Archon code.
 * The numbering scheme is used in the national archive disocovery catelogue.
 *  The ID is used to link to archive entries
 */
struct Repository: Identifiable, Codable {
    var id: String // Archon code
    var name: String
}

/**
 * A static array of the initial set up for repositories, users can reset to this state
 */
extension Repository {
    static let initialRepositories: [Repository] =
        [
            Repository(id: "repo1uk", name: "Repository 1"),
            Repository(id: "repo2uk", name: "Repository 2")
        ]
}

/**
 * Data type to contain editable properties of Repository, to process edits and updates
 */
extension Repository {
    struct Data {
        var id: String = ""
        var name: String = ""    }

    var data: Data {
        return Data(id: id, name: name)
    }

    mutating func update(from data: Data) {
        name = data.name
        id = data.id
    }

    init(fromData data: Repository.Data) {
        id = data.id
        name = data.name
    }

    var nameCodeString: String {
        return "\(name) - \(id)"
    }
}
