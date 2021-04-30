//
//  DBInitializer.swift
//
//
//  Created by Rostyslav Druzhchenko on 17.04.2021.
//

import Foundation
import RDError

class DBInitializer {

    let settings: DBSettings

    var databasePath: String!

    public init(_ settings: DBSettings) {
        self.settings = settings
    }

    // MARK: - Public

    func initDatabase() throws {

        databasePath = generateDbPath()

        if FileManager.exists(databasePath) { return }

        try createDatabaseFile(databasePath)
        let scriptPath = try getScriptPath(settings)
        if let scriptPath = scriptPath {
            let sql = try readInitScriptContent(scriptPath)
            try execInitScript(databasePath, sql)
        }
    }

    // MARK: - Private

    func generateDbPath() -> String {
        if DBEnvironmentStore.shared().environment == .prod {
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

    private func execInitScript(_ path: String, _ sql: String) throws {

        let connection = try DriverManager.getConnection(path)
        let statement = try connection.createStatement()
        try statement.exec(sql)
    }

    private func getScriptPath(_ settings: DBSettings) throws -> String? {

        guard let fileName = settings.initScriptFileName else { return nil }

        let bundle = settings.bundle

        if settings.initScriptFromResources {
            if let path = bundle.path(for: fileName) {
                return path
            } else {
                throw RDError("File \(fileName) not found")
            }
        } else {
            return fileName
        }
    }
}
