# Swift Database Connectivity

The package simplifies working with SQLite DB file for Swift applications. May
be used on any platform that suports Swift - iOS, macOS, Linux.

A new version is under construction. It's a try to implement a part of JDBC
approach. It should at least:

* Allow performing CRUD operations.
* Work with both - Statement and PreparedStatement.

## Dependencies

* SQLite3
* [RDFoundation](https://github.com/drrost/swift-extensions-foundation)
  package.
* [RDError](https://github.com/drrost/swift-error) package.

## How to use

```swift

```

## How to add

### Xcode project

* Add the package to your project. For Xcode project
  select `<porject>` > `<project>` > `Swift Packages` > `+`.

![](docs/xcode.png)

* Then paste `git@github.com:drrost/SDBC.git` to the text field.

### Another package

To the `Package.swift` file of your package add in `dependencies` section:

```swift
dependencies: [
    .package(
        name: "SDBC",
        url: "git@github.com:drrost/SDBC.git",
        from: "1.0.5")
],
```

Then in the same file add to the `targets` section:

```swift
targets: [
    .target(
        name: "YourPackage",
        dependencies: ["SDBC"]),
    .testTarget(
        name: "YourPackageTests",
        dependencies: ["YourPackage"]),
    ]
```

### DBManager

Responsibilities:

* Is able to switch environment - prod and unit test.
* Create 

## License

[MIT](https://choosealicense.com/licenses/mit/)
