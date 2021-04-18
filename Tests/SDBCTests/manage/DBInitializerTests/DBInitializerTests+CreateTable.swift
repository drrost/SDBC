//
//  DBInitializerTests+CreateTable.swift
//
//
//  Created by Rostyslav Druzhchenko on 18.04.2021.
//

import XCTest

@testable import SDBC

class DBInitializerTests_CreateTable: DBInitializerTests {

    // MARK: - Create table in the database tests

    func testCreationTestTable_Prod() {
        // Given
        DBEnvironmentStore.shared().environment = .prod
        let settings = DBSettings(
            "database.sqlite", root, "test_init.sql", Bundle.module)
        sut = DBInitializer(settings)

        // When
        try! sut.initDatabase()

        // Then
        let path = sut.generateDbPath()
        XCTAssertTrue(isTableExist(path, "test_table"))
    }

    func testCreationTestTable_Tests() {
        // Given
        DBEnvironmentStore.shared().environment = .unitTest
        let settings = DBSettings(
            "database.sqlite", root, "test_init.sql", Bundle.module)
        sut = DBInitializer(settings)

        // When
        try! sut.initDatabase()

        // Then
        let path = sut.generateDbPath()
        XCTAssertTrue(isTableExist(path, "test_table"))
    }
}

fileprivate extension DBInitializerTests_CreateTable {

    func isTableExist(_ databasePath: String, _ tableName: String) -> Bool {

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
