//
//  DBManagerPublicTests.swift
//
//
//  Created by Rostyslav Druzhchenko on 18.04.2021.
//

import Foundation
import SDBC

import XCTest

class DBManagerPublicTests: XCTestCase {

    func testDbPathIsPublic() {
        // Given
        let root = "~/Documents/db".resolve
        DBEnvironmentStore.shared().environment = .prod
        let settings = DBSettings(
            "database.sqlite", root, "test_init.sql", Bundle.module)
        let sut = try! DBManager(settings)

        // When
        _ = sut.databasePath

        // Then
    }

}
