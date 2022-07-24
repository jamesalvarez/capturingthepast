//
//  RepositoriesStore.swift
//  Capturing the Past
//
//  Created by James Alvarez on 13/07/2022.
//

import Foundation
import SwiftUI

/**
 * Storage of archive entries, saves/loads in JSON and exports in CSV
 */
class RepositoriesStore: ObservableObject {
    @Published var repositories: [Repository] = []

    func save() {
        RepositoriesStore.save(Repositories: self.repositories) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("repositories.data")
    }

    static func load(completion: @escaping (Result<[Repository], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {

                    DispatchQueue.main.async {
                        completion(.success(Repository.initialRepositories)) //TODO: Remove or place in debug only
                    }
                    return
                }

                let Repositories = try JSONDecoder().decode([Repository].self, from: file.availableData)

                DispatchQueue.main.async {
                    completion(.success(Repositories))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    static func save(Repositories: [Repository], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(Repositories)

                let outfile = try fileURL()

                try data.write(to: outfile)

                DispatchQueue.main.async {
                    completion(.success(Repositories.count))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
