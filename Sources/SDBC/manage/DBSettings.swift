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

public class DBEnvironmentStore {

    public var environment: DBEnvironment = .prod

    private static let instance = DBEnvironmentStore()

    public static func shared() -> DBEnvironmentStore {
        instance
    }
}

public class DBSettings {

    let fileName: String
    let rootPath: String
    let initScriptFileName: String?
    let bundle: Bundle
    let initScriptFromResources: Bool

    public init(
        _ fileName: String,
        _ rootPath: String,
        _ initScriptFileName: String? = nil,
        _ bundle: Bundle = Bundle.main,
        _ initScriptFromResources: Bool = true) {

        self.fileName = fileName
        self.rootPath = rootPath
        self.initScriptFileName = initScriptFileName
        self.bundle = bundle
        self.initScriptFromResources = initScriptFromResources
    }

    public init(_ path: String) {
        fileName = path.lastPathComponent
        rootPath = path.deleteLastPathComponent()
        initScriptFileName = nil
        bundle = Bundle.main
        initScriptFromResources = true
    }

    public init(_ path: String, _ initScriptFileName: String, _ bundle: Bundle) {
        fileName = path.lastPathComponent
        rootPath = path.deleteLastPathComponent()
        self.initScriptFileName = initScriptFileName
        self.bundle = bundle
        initScriptFromResources = true
    }
}
