//
//  DBSettings.swift
//
//
//  Created by Rostyslav Druzhchenko on 17.04.2021.
//

import Foundation

public enum DBEnvironment {
    case prod
    case unitTest
}

public class DBSettings {

    let environment: DBEnvironment
    let fileName: String
    let rootPath: String
    let initScriptPath: String

    public init(
        _ environment: DBEnvironment,
        _ fileName: String,
        _ rootPath: String,
        _ initScriptPath: String) {

        self.environment = environment
        self.fileName = fileName
        self.rootPath = rootPath
        self.initScriptPath = initScriptPath
    }
}
