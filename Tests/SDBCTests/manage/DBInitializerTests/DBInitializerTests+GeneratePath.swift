//
//  DBInitializerTests+GeneratePath.swift
//
//
//  Created by Rostyslav Druzhchenko on 18.04.2021.
//

import XCTest

@testable import SDBC

class DBInitializerTests_GeneratePath: DBInitializerTests {

    // MARK: - Generate path tests

    func testGeneratePathForProd() {
        // Given
        DBEnvironmentStore.shared().environment = .prod
        let settings = DBSettings(
            "database.sqlite", root, "", Bundle.module)
        sut = DBInitializer(settings)

        // When
        let path = sut.generateDbPath()

        // Then
        XCTAssertEqual("/tmp/DBInitializer_tests/database.sqlite", path)
    }

    func testGeneratePathForUnitTests() {
        // Given
        DBEnvironmentStore.shared().environment = .unitTest
        let settings = DBSettings(
            "database.sqlite", root, "", Bundle.module)
        sut = DBInitializer(settings)

        // When
        let path = sut.generateDbPath()

        // Then
        XCTAssertEqual("/tmp/DBInitializer_tests/database_test.sqlite", path)
    }

    func testGeneratePathForUnitTests_OneComponent() {
        // Given
        DBEnvironmentStore.shared().environment = .unitTest
        let settings = DBSettings(
            "database", root, "", Bundle.module)
        sut = DBInitializer(settings)

        // When
        let path = sut.generateDbPath()

        // Then
        XCTAssertEqual("/tmp/DBInitializer_tests/database_test", path)
    }

    func testGeneratePathForUnitTests_ThreeComponents() {
        // Given
        DBEnvironmentStore.shared().environment = .unitTest
        let settings = DBSettings(
            "database.main.sqlite", root, "", Bundle.module)
        sut = DBInitializer(settings)

        // When
        let path = sut.generateDbPath()

        // Then
        XCTAssertEqual("/tmp/DBInitializer_tests/database.main_test.sqlite", path)
    }
}
