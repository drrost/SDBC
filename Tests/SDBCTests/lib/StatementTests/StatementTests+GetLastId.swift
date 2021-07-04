//
//  StatementTests+GetLastId.swift
//  
//
//  Created by Rostyslav Druzhchenko on 03.05.2021.
//

import XCTest

@testable import SDBC

import RDTest

class StatementTests_GetLastId: CleanableTestCase {

    // MARK: - Variables

    var dbManager: DBManager!

    override var directoriesToDelete: [String] {
        ["/tmp/user_db/"]
    }

    // MARK: - Tests routines

    override func setUp() {
        super.setUp()
        let path = "/tmp/user_db/user.sqlite"
        let dbSettings = DBSettings(path, "init.sql", Bundle.module)
        dbManager = try! DBManager(dbSettings)
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
