//
//  Statement.swift
//  A part of git@github.com:drrost/SDBC.git project
//
//  Created by Rostyslav Druzhchenko on 15.02.2021.
//

import Foundation

public protocol Statement: AnyObject {

    func executeQuery(_ sql: String) throws -> ResultSet
    func executeUpdate(_ sql: String) throws -> Int32
    func close() throws
    func exec(_ sql: String) throws

    func getGeneratedKeys() throws -> ResultSet

    func getResultSet() throws -> ResultSet
    func getNative() -> StatementNative
}
