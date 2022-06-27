//
//  ArchiveEntriesStore.swift
//  Capturing the Past
//
//  Created by James Alvarez on 22/06/2022.
//

import Foundation
import SwiftUI

/**
 * Storage of archive entries, saves/loads in JSON and exports in CSV
 */
class ArchiveEntriesStore: ObservableObject {
    @Published var archiveEntries: [ArchiveEntry] = []

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,

                                    in: .userDomainMask,

                                    appropriateFor: nil,

                                    create: false)
            .appendingPathComponent("archive.data")
    }

    static func load(completion: @escaping (Result<[ArchiveEntry], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {

                    DispatchQueue.main.async {
                        completion(.success(ArchiveEntry.sampleEntries)) //TODO: Remove or place in debug only
                    }
                    return
                }

                let archiveEntries = try JSONDecoder().decode([ArchiveEntry].self, from: file.availableData)

                DispatchQueue.main.async {
                    completion(.success(archiveEntries))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    static func save(archiveEntries: [ArchiveEntry], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(archiveEntries)

                let outfile = try fileURL()

                try data.write(to: outfile)

                DispatchQueue.main.async {
                    completion(.success(archiveEntries.count))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
