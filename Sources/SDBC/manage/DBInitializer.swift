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

        try createDatabaseFile(databasePath)
        let scriptPath = try getScriptPath(settings)
        let sql = try readInitScriptContent(scriptPath)
        try execInitScript(databasePath, sql)
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

    private func execInitScript(_ path: String, _ sql: String) throws {

        let connection = try DriverManager.getConnection(path)
        let statement = try connection.createStatement()
        try statement.exec(sql)
    }

    private func getScriptPath(_ settings: DBSettings) throws -> String {

        let bundle = settings.bundle
        let path = settings.initScriptPath

        if settings.initScriptFromResources {
            if let path = bundle.path(for: path) {
                return path
            } else {
                throw RDError("File \(path) not found")
            }
        } else {
            return path
        }
    }
}
