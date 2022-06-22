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
struct Repository {
    var id: UUID
    var name: String
    var code: String
}

/**
 * A static array of the initial set up for repositories, users can reset to this state
 */
extension Repository {

    static let initialRepositories: [Repository] =
    [
        Repository(id:UUID(), name: "Repository 1", code: "repo1"),
        Repository(id:UUID(), name: "Repository 2", code: "repo2")
    ]
}
