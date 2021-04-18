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
    }

    // MARK: - Init tests

    func testCreation_Prod() {
        // Given
        let settings = DBSettings(
            .prod, "database.sqlite", root, "test_init.sql", Bundle.module)

        // When
        sut = try! DBManager(settings)
        // Then
    }
}
