//
//  StatementSQLite.swift
//  A part of git@github.com:drrost/SDBC.git project
//
//  Created by Rostyslav Druzhchenko on 18.02.2021.
//

import Foundation
import RDError
import SQLite3
import RDFoundation

public typealias StatementNative = OpaquePointer

class StatementSQLite: Statement {

    weak var connection: Connection?
    private var rs: ResultSet!
    var nativeStatement: OpaquePointer!

    // MARK: - Statement

    init(_ connection: Connection) {
        self.connection = connection
        rs = ResultSetSqlite(self)
    }

    func executeQuery(_ sql: String) throws -> ResultSet {
        guard let db = connection?.getDb() else {
            throw SQLException("Can't prepare statement, connection is nil")
        }

        let code = sqlite3_prepare_v2(db, sql, -1, &nativeStatement, nil)
        if code != SQLITE_OK {
            let nativeErrorMessage = String(cString: sqlite3_errmsg(db))
            throw SQLException("Statement creattion failed with code \(code)",
                               detailed: nativeErrorMessage)
        }

        return try getResultSet()
    }

    func executeUpdate(_ sql: String) throws -> Int32 {
        // Avoid SQLITE_MISUSE error
        guard sql.trimN().count > 0 else { return 0 }

        guard let db = connection?.getDb() else {
            throw SQLException("Can't prepare statement, connection is nil")
        }

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            throw SQLException(
                "Can't prepare statment with SQL: \"\(sql)\"",
                detailed: getNativeError(db))
        }

        if sqlite3_step(statement) != SQLITE_DONE {
            throw SQLException("sqlite3_step failed with error: \"\(getNativeError(db))\"")
        }

        sqlite3_finalize(statement)

        return SQLITE_OK
    }

    func exec(_ sql: String) throws {
        guard let db = connection?.getDb() else {
            throw SQLException("Can't prepare statement, connection is nil")
        }
        
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            throw SQLException(
                "Can't execute SQL: \"\(sql)\"", detailed: getNativeError(db))
        }
    }

    func getGeneratedKeys() throws -> ResultSet {
        guard let connection = connection else {
            throw SQLException(
                "Can't obtain generated keys, `connection' is nil")
        }

        let getGeneratedKeys =
            try connection.prepareStatement("SELECT last_insert_rowid();")

        return try getGeneratedKeys.executeQuery();
    }

    func close() throws {
        sqlite3_finalize(nativeStatement)
    }

    func getResultSet() throws -> ResultSet {
        rs.columns = fetchColumnNames(nativeStatement)
        return rs
    }

    func getNative() -> StatementNative {
        nativeStatement
    }

    // MARK: - Public

    func fetchColumnNames(_ statement: StatementNative?) -> [String] {

        // Declare variables
        var columnNames = [String]()
        let count = sqlite3_column_count(statement)

        // Iterate the columns
        for i in 0 ..< count {

            if
                let namePtr = sqlite3_column_name(statement, i),
                let name = NSString(utf8String: namePtr) {

                columnNames.append(name as String)
            } else {
                columnNames.append("\(i)")
            }
        }

        return columnNames
    }

    func getNativeError(_ db: OpaquePointer?) -> String {
        return String(cString: sqlite3_errmsg(db))
    }
}

public extension Statement {

    func getLastId() throws -> Int {
        let rs = try getGeneratedKeys()

        if try rs.next() {
            return try rs.getInt("last_insert_rowid()")
        } else {
            throw SQLException("There is no generated keys")
        }
    }
}
