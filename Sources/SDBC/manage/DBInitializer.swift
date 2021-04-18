//
//  DBInitializer.swift
//
//
//  Created by Rostyslav Druzhchenko on 17.04.2021.
//

import Foundation

public class DBInitializer {

    let settings: DBSettings

    public init(_ settings: DBSettings) {
        self.settings = settings
    }

    // MARK: - Public

    public func initDatabase() throws {
        let path = generateDbPath()
        try createDatabaseFile(path)
        let sql = try readInitScriptContent(settings.initScriptPath)
        try execInitScript(sql)
    }

    // MARK: - Private

    func generateDbPath() -> String {
        if settings.environment == .prod {
            return settings.rootPath.appendingPathComponent(settings.fileName)
        } else {
            var components = settings.fileName.split(".")
            var indexToReplase = 0
            if components.count > 1 {
                indexToReplase = components.count - 2
            }
            components[indexToReplase].append("_test")
            let newName = components.joined(separator: ".")
            return settings.rootPath.appendingPathComponent(newName)
        }
    }

    private func createDatabaseFile(_ path: String) throws {
        try FileManager.createFile(path)
    }

    private func readInitScriptContent(_ path: String) throws -> String {
        try String(contentsOf: path)
    }

    private func execInitScript(_ sql: String) throws {

    }
}
