//
//  DBManager_AllTables_Tests.swift
//
//
//  Created by Rostyslav Druzhchenko on 11.05.2021.
//

import XCTest

@testable import SDBC

import RDTest

class DBManager_AllTables_Tests: CleanableTestCase {

    // MARK: - Variables

    var sut: DBManager!
    let root = "/tmp/DBManagerTests_tests"

    override var directoriesToDelete: [String] {[
         "/tmp/db_test_abcd/",
    ]}

    // MARK: - Init tests

    func testAllTables() {

        // Given
        DBEnvironmentStore.shared().environment = .prod
        let path = "/tmp/db_test_abcd/bookdb.sqlite"
        XCTAssertFalse(FileManager.exists(path))
        let settings = DBSettings(
            path, "init_several_tables.sql", Bundle.module)
        sut = try! DBManager(settings)

        // When
        let allTables = try! sut.allTables()

        // Then
        XCTAssertEqual(3, allTables.count)

        let tableBook = allTables[0]
        XCTAssertEqual(4, tableBook.columns.count)
        XCTAssertEqual("book", tableBook.name)
        XCTAssertEqual("book_id", tableBook.columns[0].name)
        XCTAssertEqual(.integer, tableBook.columns[0].type)
        XCTAssertEqual("name", tableBook.columns[1].name)
        XCTAssertEqual(.text, tableBook.columns[1].type)
        XCTAssertEqual("cover", tableBook.columns[2].name)
        XCTAssertEqual(.blob, tableBook.columns[2].type)
        XCTAssertEqual("created_at", tableBook.columns[3].name)
        XCTAssertEqual(.real, tableBook.columns[3].type)
    }
}
