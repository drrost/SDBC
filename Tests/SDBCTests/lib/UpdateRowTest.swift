//
//  UpdateRowTest.swift
//
//
//  Created by Rostyslav Druzhchenko on 21.02.2021.
//

import XCTest

@testable import SDBC

class UpdateRowTest: XCTestCase {

    // MARK: - Variables

    var dbManager: DBManager!
    var connection: Connection!

    let root = "/tmp/UpdateRowTest_tests"

    // MARK: - Tests routines

    override func setUp() {
        DBEnvironmentStore.shared().environment = .unitTest
        let settings = DBSettings(
            "update_row.sqlite", root, "init.sql", Bundle.module)
        dbManager = try! DBManager(settings)
        connection = try! dbManager.connect()
    }

    override func tearDown() {
        try! dbManager.drop()
    }

    // MARK: - Init tests

    func testCreation() {
        // Given
        let sql = "UPDATE user SET first_name = ?, last_name = ?, age = ? WHERE first_name = ?;"

        // When
        do {
            let preparedStatement = try connection.prepareStatement(sql)
            try preparedStatement.setString(1, "bcd")
            try preparedStatement.setString(2, "zyx")
            try preparedStatement.setInt(3, 0)
            try preparedStatement.setString(4, "John")

            _ = try preparedStatement.executeUpdate()

            // TODO: Make executeUpdate return number of changed rows
//            XCTAssertEqual(2, code)
        } catch {
            XCTAssertTrue(false, "code above should not throw: \"\(error.localizedDescription)\"")
        }

        // Then
        let sqlSelect = "SELECT * FROM user;"
        do {
            let statement = try connection.createStatement()
            let rs = try statement.executeQuery(sqlSelect)

            _ = try rs.next()
            XCTAssertEqual("bcd", try rs.getString("first_name"))
            XCTAssertEqual("zyx", try rs.getString("last_name"))
            XCTAssertEqual(0, try rs.getInt("age"))
        } catch {
            XCTAssertTrue(false, "code above should not throw: \"\(error.localizedDescription)\"")
        }
    }
}
