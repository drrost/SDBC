//
//  DBManager+AllTables.swift
//
//
//  Created by Rostyslav Druzhchenko on 11.05.2021.
//

import Foundation

public enum ColumnType {
    case integer
    case real
    case text
    case blob
}

public class Column {

    public let name: String
    public let type: ColumnType

    init(_ name: String, _ type: ColumnType) {
        self.name = name
        self.type = type
    }
}

public class Table {

    public let name: String
    public let columns: [Column]

    init(_ name: String, _ columns: [Column]) {
        self.name = name
        self.columns = columns
    }
}

public extension DBManager {

    func allTables() throws -> [Table] {

        let tableNames = try allTableNames()
        let tables = try fetchTables(for: tableNames)

        return tables
    }

    private func allTableNames() throws -> [String] {

        let connection = try connect()
        let sql = "SELECT name FROM sqlite_master WHERE type = \"table\";"
        let statement = try connection.createStatement()
        let rs = try statement.executeQuery(sql)

        let tableNames = try getTableNames(from: rs)
        return tableNames
    }

    private func getTableNames(from rs: ResultSet) throws -> [String] {

        var names = [String]()
        while try rs.next() {
            let name = try rs.getString("name")
            names.append(name)
        }

        return names
    }

    private func fetchTables(for names: [String]) throws -> [Table] {

        var tables = [Table]()

        for name in names {
            let table = try getTable(for: name)
            tables.append(table)
        }

        return tables
    }

    private func getTable(for name: String) throws -> Table {

        let connection = try connect()
        let sql = "PRAGMA table_info(\(name));"
        let statement = try connection.createStatement()
        let rs = try statement.executeQuery(sql)

        let columns = try getColumns(from: rs)
        let table = Table(name, columns)
        return table
    }

    private func getColumns(from rs: ResultSet) throws -> [Column] {

        var columns = [Column]()
        while try rs.next() {

            let name = try rs.getString("name")
            let typeString = try rs.getString("type")
            let type = ColumnType(typeString)

            let column = Column(name, type)
            columns.append(column)
        }

        return columns
    }
}

private extension ColumnType {

    init(_ from: String) {
        switch from.lowercased() {
        case "integer":
            self = .integer
        case "text":
            self = .text
        case "real":
            self = .real
        case "blob":
            self = .blob
        default:
            self = .integer
        }
    }
}
