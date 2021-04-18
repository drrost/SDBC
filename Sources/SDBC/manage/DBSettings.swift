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
    let bundle: Bundle
    let initScriptFromResources: Bool

    public init(
        _ environment: DBEnvironment,
        _ fileName: String,
        _ rootPath: String,
        _ initScriptPath: String,
        _ bundle: Bundle,
        _ initScriptFromResources: Bool = true) {

        self.environment = environment
        self.fileName = fileName
        self.rootPath = rootPath
        self.initScriptPath = initScriptPath
        self.bundle = bundle
        self.initScriptFromResources = initScriptFromResources
    }
}
