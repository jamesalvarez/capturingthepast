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
    var id: String {
        get {
            return archon
        }
        set {
            archon = newValue
        }
    }
    var archon: String // Archon code
    var name: String
}

/**
 * A static array of the initial set up for repositories, users can reset to this state
 */
extension Repository {
    static let initialRepositories: [Repository] = loadInitialRepositoryList()
    static let sampleRepositories: [Repository] =
    [
        Repository(archon: "GB0021", name: "Archives and Cornish Studies Service"),
        Repository(archon: "GB0004", name: "Bedfordshire Archives & Record Service")
    ]

    static func loadInitialRepositoryList() -> [Repository] {
        guard let path = Bundle.main.path(forResource: "DefaultRepositories", ofType: "json") else { return [] }

        let url = URL(fileURLWithPath: path)

        do {
            let data = try Foundation.Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([Repository].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
}



/**
 * Data type to contain editable properties of Repository, to process edits and updates
 */
extension Repository {
    struct Data {
        var archon: String = ""
        var name: String = ""    }

    var data: Data {
        return Data(archon: archon, name: name)
    }

    mutating func update(from data: Data) {
        name = data.name
        archon = data.archon
    }

    init(fromData data: Repository.Data) {
        archon = data.archon
        name = data.name
    }

    var nameCodeString: String {
        return "\(archon) - \(name)"
    }
}
