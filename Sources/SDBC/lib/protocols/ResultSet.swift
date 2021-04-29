//
//  ResultSet.swift
//  A part of git@github.com:drrost/SDBC.git project
//
//  Created by Rostyslav Druzhchenko on 15.02.2021.
//

import Foundation

public protocol ResultSet {

    var columns: [String] { get set }
    var row: Int { get set }

    func next() throws -> Bool
    func getInt(_ columnLabel: String) throws -> Int
    func getUInt64(_ columnLabel: String) throws -> UInt64
    func getDouble(_ columnLabel: String) throws -> Double
    func getString(_ columnLabel: String) throws -> String
    func getBool(_ columnLabel: String) throws -> Bool
}
