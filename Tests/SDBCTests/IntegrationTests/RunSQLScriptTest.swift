//
//  RunSQLScriptTest.swift
//
//
//  Created by Rostyslav Druzhchenko on 16.02.2021.
//

import XCTest
import SQLite3

@testable import SDBC

class RunSQLScriptTest: XCTestCase {

    override func setUp() {
        let toDeleteFiles = [
            "/private/tmp/RunSQLScriptTest/tets_big_story.sqlite"
            ]

        for file in toDeleteFiles {
            if FileManager.exists(file) {
                try! FileManager.delete(file)
            }
        }
    }

    // MARK: - Init tests

    func testBigStory() {

        // Given

        let root = "/tmp/RunSQLScriptTest"

        let settings = DBSettings(
            .unitTest, "tets_big_story.sqlite", root, "init.sql", Bundle.module)
        let dbManager = try! DBManager(settings)
        let connection = try! dbManager.connect()

        // Then
        do {
            let sql = "SELECT * FROM user;"
            let statement = try connection.createStatement()
            let rs = try statement.executeQuery(sql)

            var userList = [User]()
            while try rs.next() {
                let user = User()
                user.id = try rs.getInt("id")
                user.firstName = try rs.getString("first_name")
                user.lastName = try rs.getString("last_name")
                user.age = try rs.getInt("age")
                userList.append(user)
            }
            XCTAssertEqual(7, userList.count)
        } catch let error as SQLException {
            print(error.message)
            print(error.detailedMessage)
            XCTAssertTrue(false, "code above should not throw")
        } catch {
            XCTAssertTrue(
                false, "The code should not throw any errors but SQLException")
        }

        try! dbManager.drop()
    }
}
