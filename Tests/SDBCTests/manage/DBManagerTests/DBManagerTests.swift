//
//  DBManagerTests.swift
//
//
//  Created by Rostyslav Druzhchenko on 18.04.2021.
//

import XCTest

@testable import SDBC

class DBManagerTests: XCTestCase {

    // MARK: - Variables

    var sut: DBManager!
    let root = "/tmp/DBManagerTests_tests"

    // MARK: - Tests routines

    override func setUp() {
        try? FileManager.delete(root)
    }

    // MARK: - Init tests

    func testCreation_Prod() {
        // Given
        DBEnvironmentStore.shared().environment = .prod
        let settings = DBSettings(
            "database.sqlite", root, "test_init.sql", Bundle.module)

        // When
        sut = try! DBManager(settings)

        // Then
        XCTAssertTrue(FileManager.exists("/tmp/DBManagerTests_tests/database.sqlite"))
        XCTAssertTrue(sut.isTableExist("test_table"))
    }

    func testCreation_Unit() {
        // Given
        DBEnvironmentStore.shared().environment = .unitTest
        let settings = DBSettings(
            "database.sqlite", root, "test_init.sql", Bundle.module)

        // When
        sut = try! DBManager(settings)

        // Then
        XCTAssertTrue(FileManager.exists("/tmp/DBManagerTests_tests/database_test.sqlite"))
        XCTAssertTrue(sut.isTableExist("test_table"))
    }

    #if os(iOS)
    func testCreation_Prod_iOS() {
        // Given
        let root = "~/Documents/db".resolve

        DBEnvironmentStore.shared().environment = .prod
        let settings = DBSettings(
            "database.sqlite", root, "test_init.sql", Bundle.module)

        // When
        sut = try! DBManager(settings)

        // Then
        XCTAssertTrue(sut.databasePath.ends("/data/Documents/db/database.sqlite"))
        XCTAssertTrue(FileManager.exists(sut.databasePath))
        XCTAssertTrue(sut.isTableExist("test_table"))
    }
    #endif
}
