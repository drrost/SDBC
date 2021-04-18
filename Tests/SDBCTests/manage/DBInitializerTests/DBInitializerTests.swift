//
//  DBInitializerTests.swift
//
//
//  Created by Rostyslav Druzhchenko on 18.04.2021.
//

import XCTest

@testable import SDBC

class DBInitializerTests: XCTestCase {

    // MARK: - Variables

    var sut: DBInitializer!

    let root = "/tmp/DBInitializer_tests"

    // MARK: - Tests routines

    override func setUp() {
        try! FileManager.createDirectory(root)
    }

    override func tearDown() {
        try! FileManager.delete(root)
    }
}
