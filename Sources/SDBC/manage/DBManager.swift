//
//  DBManager.swift
//
//
//  Created by Rostyslav Druzhchenko on 16.04.2021.
//

import Foundation

public class DBManager {

    private let settings: DBSettings
    private let databasePath: String

    public init(_ settings: DBSettings) throws {
        self.settings = settings

        let initializer = DBInitializer(settings)
        try initializer.initDatabase()
        databasePath = initializer.databasePath
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
}
