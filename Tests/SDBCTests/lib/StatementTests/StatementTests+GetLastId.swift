//
//  StatementTests+GetLastId.swift
//  
//
//  Created by Rostyslav Druzhchenko on 03.05.2021.
//

import XCTest

@testable import SDBC

import ExtensionsFoundation

class StatementTests_GetLastId: XCTestCase {

    // MARK: - Variables

    var dbManager: DBManager!

    // MARK: - Tests routines

    override func setUp() {
        deleteDirectories()
        let path = "/tmp/user_db/user.sqlite"
        let dbSettings = DBSettings(path, "init.sql", Bundle.module)
        dbManager = try! DBManager(dbSettings)
    }

    override func tearDown() {
        deleteDirectories()
    }

    // MARK: - Init tests

    func testCreation() {
        // Given
        let sql = "INSERT INTO user (first_name, last_name, age) VALUES ('Paul', 'Arenye', 44);";
        let connection = try! dbManager.connect()
        let statement = try! connection.createStatement()
        _ = try! statement.executeUpdate(sql)

        // When
        let lastId = try! statement.getLastId()

        // Then
        XCTAssertEqual(8, lastId)
    }

}

fileprivate extension StatementTests_GetLastId {

    func deleteDirectories() {
        let directoriesToDelete = [
            "/tmp/user_db/"
        ]
        try! deleteDirs(directoriesToDelete)
    }
}
