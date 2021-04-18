//
//  DBInitializerTests+CreateTable.swift
//
//
//  Created by Rostyslav Druzhchenko on 18.04.2021.
//

import XCTest

@testable import SDBC

class DBInitializerTests_CreateTable: XCTestCase {

    // MARK: - Create table in the database tests

    func testCreationTestTable_Prod() {
        // Given
        let settings = DBSettings(.prod, "database.sqlite", root, initScriptPath)
        sut = DBInitializer(settings)

        // When
        try! sut.initDatabase()

        // Then
    }
}
