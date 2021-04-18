//
//  DBInitializerTests+CreateFile.swift
//
//
//  Created by Rostyslav Druzhchenko on 18.04.2021.
//

import XCTest

@testable import SDBC

class DBInitializerTests_CreateFile: DBInitializerTests {

    // MARK: - Create database file tests

    func testCreation_Prod() {
        // Given
        DBEnvironmentStore.shared().environment = .prod
        let settings = DBSettings(
            "database.sqlite", root, "test_init.sql", Bundle.module)
        sut = DBInitializer(settings)

        // When
        try! sut.initDatabase()

        // Then
        XCTAssertTrue(FileManager.exists("/tmp/DBInitializer_tests/database.sqlite"))
    }

    func testCreation_UnitTests() {
        // Given
        DBEnvironmentStore.shared().environment = .unitTest
        let settings = DBSettings(
            "database.sqlite", root, "test_init.sql", Bundle.module)
        sut = DBInitializer(settings)

        // When
        try! sut.initDatabase()

        // Then
        XCTAssertTrue(FileManager.exists("/tmp/DBInitializer_tests/database_test.sqlite"))
    }
}
