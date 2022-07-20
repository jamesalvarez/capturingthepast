//
//  ArchiveEntriesStore.swift
//  Capturing the Past
//
//  Created by James Alvarez on 22/06/2022.
//

import Foundation
import SwiftUI
import CSV

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

    private static func backupFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("archive.data.backup")
    }

    private static func csvURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("CapturingThePastLog.csv")
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

                do {
                    let archiveEntries = try JSONDecoder().decode([ArchiveEntry].self, from: file.availableData)

                    DispatchQueue.main.async {
                        completion(.success(archiveEntries))
                    }
                } catch {
                    let backupURL = try backupFileURL()
                    try? FileManager.default.secureCopyItem(at: fileURL, to: backupURL)
                    DispatchQueue.main.async {
                        completion(.success(ArchiveEntry.sampleEntries)) //TODO: Remove or place in debug only
                    }
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

                let csvFile = try csvURL()
                let csvStream = OutputStream(url: csvFile, append: false)
                let csv = try CSVWriter(stream: csvStream!)

                try csv.write(row: ["Date", "Cat Ref", "Filename", "Note"])
                for archiveEntry in archiveEntries {
                    try csv.write(row: ["", archiveEntry.catReference, archiveEntry.photoRef, archiveEntry.note])
                }

                csv.stream.close()


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

extension FileManager {

    open func secureCopyItem(at srcURL: URL, to dstURL: URL) throws {

        if FileManager.default.fileExists(atPath: dstURL.path) {
            try FileManager.default.removeItem(at: dstURL)
        }
        try FileManager.default.copyItem(at: srcURL, to: dstURL)
    }
}
