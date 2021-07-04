//
//  DBManagerTests.swift
//
//
//  Created by Rostyslav Druzhchenko on 18.04.2021.
//

import XCTest

@testable import SDBC

import RDTest

class DBManagerTests: CleanableTestCase {

    // MARK: - Variables

    var sut: DBManager!
    let root = "/tmp/DBManagerTests_tests"

    override var directoriesToDelete: [String] {[
        "~/Documents/db",
         "/tmp/db_test/",
         "/tmp/db_test_book/",
         "/tmp/DBManagerTests_tests"
    ]}

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

    func testCreationWithPath() {
        // Given
        DBEnvironmentStore.shared().environment = .prod
        let path = "/tmp/db_test/testdb.sqlite"
        XCTAssertFalse(FileManager.exists(path))

        // When
        sut = try! DBManager(path)

        // Then
        XCTAssertTrue(FileManager.exists("/tmp/db_test/testdb.sqlite"))
    }

    func testCreationWithPathAndInitialScript() {
        // Given
        DBEnvironmentStore.shared().environment = .prod
        let path = "/tmp/db_test_book/bookdb.sqlite"
        XCTAssertFalse(FileManager.exists(path))
        let settings = DBSettings(
            path, "init_book.sql", Bundle.module)

        // When
        sut = try! DBManager(settings)

        // Then
        XCTAssertTrue(FileManager.exists("/tmp/db_test_book/bookdb.sqlite"))
        XCTAssertTrue(sut.isTableExist("book"))
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
