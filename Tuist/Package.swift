// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
@preconcurrency import struct ProjectDescription.PackageSettings
    import struct ProjectDescription.ConfigurationName

    let packageSettings = PackageSettings(
        productTypes: [
            "Kingfisher": .framework,
            "SnapKit": .framework,
        ],
        baseSettings: .settings(
            base: [
                "ENABLE_BITCODE": "NO",
                "DEAD_CODE_STRIPPING": "YES",
                "LLVM_LTO": "YES",
                "SWIFT_OPTIMIZATION_LEVEL": "-Osize",
                "STRIP_INSTALLED_PRODUCT": "YES",
                "STRIP_STYLE": "non-global"
            ],
            configurations: [
                .debug(name: .init(stringLiteral: "Debug"), settings: [:]),
                .debug(name: .init(stringLiteral: "Stage"), settings: [:]),
                .release(name: .init(stringLiteral: "Release"), settings: [:])
            ]
        )
    )
#endif

/*
 참고: https://docs.tuist.dev/en/guides/develop/projects/dependencies
 */
//@MainActor
let package = Package(
    name: "SearchAndSave",
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", exact: "8.3.2"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.7.1"),
    ]
)
