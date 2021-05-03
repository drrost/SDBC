//
//  DBManagerTests.swift
//
//
//  Created by Rostyslav Druzhchenko on 18.04.2021.
//

import XCTest

@testable import SDBC

import ExtensionsFoundation

class DBManagerTests: XCTestCase {

    // MARK: - Variables

    var sut: DBManager!
    let root = "/tmp/DBManagerTests_tests"

    // MARK: - Tests routines

    override func setUp() {
        deleteDirectories()
    }

    override func tearDown() {
        deleteDirectories()
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

    func testCreationWithRoot() {
        // Given
        DBEnvironmentStore.shared().environment = .prod
        let path = "/tmp/db_test/testdb.sqlite"
        XCTAssertFalse(FileManager.exists(path))

        // When
        sut = try! DBManager(path)

        // Then
        XCTAssertTrue(FileManager.exists("/tmp/db_test/testdb.sqlite"))
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

fileprivate extension DBManagerTests {

    func deleteDirectories() {
        let dirsToDelete = [
            "~/Documents/db",
            "/tmp/db_test/",
            "/tmp/DBManagerTests_tests"
        ]

        try! deleteDirs(dirsToDelete)
    }
}
