//
//  DBManager.swift
//
//
//  Created by Rostyslav Druzhchenko on 16.04.2021.
//

import Foundation

public class DBManager {

    // MARK: - Variables
    
    private let settings: DBSettings
    var databasePath: String!

    // MARK: - Init

    public init(_ settings: DBSettings) throws {
        self.settings = settings
        try initDatabase()
    }

    // MARK: - Public

    public func connect() throws -> Connection {
        if FileManager.exists(databasePath) == false {
            try initDatabase()
        }
        return try DriverManager.getConnection(databasePath)
    }

    public func drop() throws {
        let dirPath = (databasePath as NSString).deletingLastPathComponent
        try FileManager.delete(dirPath)
    }

    public func isTableExist(_ tableName: String) -> Bool {

        let connection = try! DriverManager.getConnection(databasePath)
        let sql = "SELECT COUNT(*) as count FROM sqlite_master WHERE" +
            " type='table' AND name='\(tableName)';"

        let statement = try! connection.createStatement()
        let rs = try! statement.executeQuery(sql)

        var count = -1
        while try! rs.next() {
            count = try! rs.getInt("count")
        }

        return count == 1
    }

    // MARK: - Private

    private func initDatabase() throws {
        let initializer = DBInitializer(settings)
        try initializer.initDatabase()
        databasePath = initializer.databasePath
    }
}
