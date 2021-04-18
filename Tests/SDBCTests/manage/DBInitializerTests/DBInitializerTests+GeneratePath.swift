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
        let settings = DBSettings(
            .prod, "database.sqlite", root, "", Bundle.module)
        sut = DBInitializer(settings)

        // When
        let path = sut.generateDbPath()

        // Then
        XCTAssertEqual("/tmp/DBInitializer_tests/database.sqlite", path)
    }

    func testGeneratePathForUnitTests() {
        // Given
        let settings = DBSettings(
            .unitTest, "database.sqlite", root, "", Bundle.module)
        sut = DBInitializer(settings)

        // When
        let path = sut.generateDbPath()

        // Then
        XCTAssertEqual("/tmp/DBInitializer_tests/database_test.sqlite", path)
    }

    func testGeneratePathForUnitTests_OneComponent() {
        // Given
        let settings = DBSettings(
            .unitTest, "database", root, "", Bundle.module)
        sut = DBInitializer(settings)

        // When
        let path = sut.generateDbPath()

        // Then
        XCTAssertEqual("/tmp/DBInitializer_tests/database_test", path)
    }

    func testGeneratePathForUnitTests_ThreeComponents() {
        // Given
        let settings = DBSettings(
            .unitTest, "database.main.sqlite", root, "", Bundle.module)
        sut = DBInitializer(settings)

        // When
        let path = sut.generateDbPath()

        // Then
        XCTAssertEqual("/tmp/DBInitializer_tests/database.main_test.sqlite", path)
    }
}
