import ProjectDescription

private struct APP {
    static let appSettings = Settings.settings(
        base: [
            "ENABLE_BITCODE": "NO",
            "DEVELOPMENT_TEAM": "CLA95FJCV2",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "SWIFT_VERSION": "5.0",
            "ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS": "YES",
            "INTENTS_CODEGEN_LANGUAGE": "Swift",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS":  "NO",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOL_FRAMEWORKS": "",
            "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "NO",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "GCC_GENERATE_DEBUGGING_SYMBOLS": "YES",
            "ENABLE_DEBUG_DYLIB": "NO",
        ],
        configurations: [
            .debug(name: ConfigurationName(stringLiteral: APP.Configurations.debug.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.AppBundleId.debug.rawValue),
                "CODE_SIGN_ENTITLEMENTS": "Targets/App/Supporting Files/AppDebug.entitlements",
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG DEV_BUILD",
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon_debug",
            ]),
            .debug(name: ConfigurationName(stringLiteral: APP.Configurations.stage.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.AppBundleId.stage.rawValue),
                "CODE_SIGN_ENTITLEMENTS": "Targets/App/Supporting Files/AppStage.entitlements",
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG STAGE_BUILD",
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon_stage",
            ]),
            .release(name: ConfigurationName(stringLiteral: APP.Configurations.release.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.AppBundleId.release.rawValue),
                "CODE_SIGN_ENTITLEMENTS": "Targets/App/Supporting Files/App.entitlements",
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE_BUILD",
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            ])
        ]
    )
    
    static let backendKitSettings = Settings.settings(
        base: [
            "ENABLE_BITCODE": "NO",
            "DEVELOPMENT_TEAM": "CLA95FJCV2",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "SWIFT_VERSION": "5.0",
            "INTENTS_CODEGEN_LANGUAGE": "Swift",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS":  "NO",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOL_FRAMEWORKS": "",
            "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "NO",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "GCC_GENERATE_DEBUGGING_SYMBOLS": "YES",
            "ENABLE_DEBUG_DYLIB": "NO",
        ],
        configurations: [
            .debug(name: ConfigurationName(stringLiteral: APP.Configurations.debug.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.BackendKitBundleId.debug.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG DEV_BUILD",
            ]),
            .debug(name: ConfigurationName(stringLiteral: APP.Configurations.stage.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.BackendKitBundleId.stage.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG STAGE_BUILD",
            ]),
            .release(name: ConfigurationName(stringLiteral: APP.Configurations.release.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.BackendKitBundleId.release.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE_BUILD",
            ])
        ]
    )
    
    static let domainKitSettings = Settings.settings(
        base: [
            "ENABLE_BITCODE": "NO",
            "DEVELOPMENT_TEAM": "CLA95FJCV2",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "SWIFT_VERSION": "5.0",
            "INTENTS_CODEGEN_LANGUAGE": "Swift",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS":  "NO",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOL_FRAMEWORKS": "",
            "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "NO",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "GCC_GENERATE_DEBUGGING_SYMBOLS": "YES",
            "ENABLE_DEBUG_DYLIB": "NO",
        ],
        configurations: [
            .debug(name: ConfigurationName(stringLiteral: APP.Configurations.debug.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.domainKitBundleId.debug.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG DEV_BUILD",
            ]),
            .debug(name: ConfigurationName(stringLiteral: APP.Configurations.stage.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.domainKitBundleId.stage.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG STAGE_BUILD",
            ]),
            .release(name: ConfigurationName(stringLiteral: APP.Configurations.release.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.domainKitBundleId.release.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE_BUILD",
            ])
        ]
    )
    
    static let environmentKitSettings = Settings.settings(
        base: [
            "ENABLE_BITCODE": "NO",
            "DEVELOPMENT_TEAM": "CLA95FJCV2",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "SWIFT_VERSION": "5.0",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS":  "NO",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOL_FRAMEWORKS": "",
            "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "NO",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "GCC_GENERATE_DEBUGGING_SYMBOLS": "YES",
            "ENABLE_DEBUG_DYLIB": "NO",
        ],
        configurations: [
            .debug(name: ConfigurationName(stringLiteral: APP.Configurations.debug.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.EnvironmentKitBundleId.debug.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG DEV_BUILD",
            ]),
            .debug(name: ConfigurationName(stringLiteral: APP.Configurations.stage.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.EnvironmentKitBundleId.stage.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG STAGE_BUILD",
            ]),
            .release(name: ConfigurationName(stringLiteral: APP.Configurations.release.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.EnvironmentKitBundleId.release.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE_BUILD",
            ])
        ]
    )
    
    static let repositoryKitSettings = Settings.settings(
        base: [
            "ENABLE_BITCODE": "NO",
            "DEVELOPMENT_TEAM": "CLA95FJCV2",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "SWIFT_VERSION": "5.0",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS":  "NO",
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOL_FRAMEWORKS": "",
            "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "NO",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "GCC_GENERATE_DEBUGGING_SYMBOLS": "YES",
            "ENABLE_DEBUG_DYLIB": "NO",
        ],
        configurations: [
            .debug(name: ConfigurationName(stringLiteral: APP.Configurations.debug.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.RepositoryKitBundleId.debug.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG DEV_BUILD",
            ]),
            .debug(name: ConfigurationName(stringLiteral: APP.Configurations.stage.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.RepositoryKitBundleId.stage.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG STAGE_BUILD",
            ]),
            .release(name: ConfigurationName(stringLiteral: APP.Configurations.release.rawValue), settings: [
                "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: APP.RepositoryKitBundleId.release.rawValue),
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE_BUILD",
            ])
        ]
    )
    
    // MARK: - Bundle IDs
    
    enum Configurations: String {
        case debug = "Debug"
        case stage = "Stage"
        case release = "Release"
    }
    
    enum AppBundleId: String {
        case debug = "op1000.SearchAndSave.dev"
        case stage = "op1000.SearchAndSave.stage"
        case release = "op1000.SearchAndSave"
    }
    
    enum BackendKitBundleId: String {
        case debug = "op1000.SearchAndSave.dev.backendKit"
        case stage = "op1000.SearchAndSave.stage.backendKit"
        case release = "op1000.SearchAndSave.backendKit"
    }
    
    enum domainKitBundleId: String {
        case debug = "op1000.SearchAndSave.dev.domainKit"
        case stage = "op1000.SearchAndSave.stage.domainKit"
        case release = "op1000.SearchAndSave.domainKit"
    }
    
    enum EnvironmentKitBundleId: String {
        case debug = "op1000.SearchAndSave.dev.environmentKit"
        case stage = "op1000.SearchAndSave.stage.environmentKit"
        case release = "op1000.SearchAndSave.environmentKit"
    }
    
    enum RepositoryKitBundleId: String {
        case debug = "op1000.SearchAndSave.dev.repositoryKit"
        case stage = "op1000.SearchAndSave.stage.repositoryKit"
        case release = "op1000.SearchAndSave.repositoryKit"
    }
}

// MARK: - Project

let project = Project(
    name: "SearchAndSave",
    settings: .settings(
        base: [
            "ENABLE_BITCODE": "NO",
            "DEAD_CODE_STRIPPING": "YES",
            "LLVM_LTO": "YES",
            "SWIFT_OPTIMIZATION_LEVEL": "-Osize",
            "STRIP_INSTALLED_PRODUCT": "YES",
            "STRIP_STYLE": "non-global"
        ],
        configurations: [
            .debug(name: .init(stringLiteral: APP.Configurations.debug.rawValue), settings: [:]),
            .debug(name: .init(stringLiteral: APP.Configurations.stage.rawValue), settings: [:]),
            .release(name: .init(stringLiteral: APP.Configurations.release.rawValue), settings: [:])
        ]
    ),
    targets: [
        
        // MARK: - Main App
        
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
            infoPlist: .file(path: "Targets/App/Supporting Files/Info.plist"),
            sources: [
                "Targets/App/Sources/**",
            ],
            resources: [
                "Targets/App/Resources/**",
            ],
            scripts: [
                .pre(
                    path: "Targets/Scripts/swiftlint-check.sh",
                    name: "SwiftLint Script",
                    basedOnDependencyAnalysis: false
                )
            ],
            dependencies: [
                // framework
                .target(name: "BackendKit"),
                .target(name: "domainKit"),
                .target(name: "EnvironmentKit"),
                .target(name: "RepositoryKit"),
                // spm
                .external(name: "Kingfisher"),
            ],
            settings: APP.appSettings
        ),
        
        // MARK: - framwork

        .target(
            name: "BackendKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
            sources: ["Targets/BackendKit/Sources/**"],
            resources: [
                "Targets/BackendKit/Resources/**",
            ],
            dependencies: [
                // framework
                .target(name: "EnvironmentKit"),
            ],
            settings: APP.backendKitSettings
        ),
        
        .target(
            name: "domainKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
            sources: ["Targets/DomainKit/Sources/**"],
            resources: [
                "Targets/DomainKit/Resources/**",
            ],
            dependencies: [
                // framework
                .target(name: "EnvironmentKit"),
                .target(name: "BackendKit"),
            ],
            settings: APP.domainKitSettings
        ),
        
        .target(
            name: "EnvironmentKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
            sources: ["Targets/EnvironmentKit/Sources/**"],
            resources: [
                "Targets/EnvironmentKit/Resources/**",
            ],
            dependencies: [
            ],
            settings: APP.environmentKitSettings
        ),
        
        .target(
            name: "RepositoryKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
            sources: ["Targets/RepositoryKit/Sources/**"],
            resources: [
                "Targets/RepositoryKit/Resources/**",
            ],
            dependencies: [
                // framework
                .target(name: "EnvironmentKit"),
                .target(name: "domainKit"),
            ],
            settings: APP.repositoryKitSettings
        )
    ],
    schemes: [
        .scheme(
            name: "App-Dev-Archive",
            buildAction: .buildAction(targets: [
                .target("App"),
                // framework
                .target("BackendKit"),
                .target("domainKit"),
                .target("EnvironmentKit"),
                .target("RepositoryKit"),
            ]),
            archiveAction: .archiveAction(configuration: .init(stringLiteral: APP.Configurations.debug.rawValue))
        ),
        .scheme(
            name: "App-Stage-Archive",
            buildAction: .buildAction(targets: [
                .target("App"),
                // framework
                .target("BackendKit"),
                .target("domainKit"),
                .target("EnvironmentKit"),
                .target("RepositoryKit"),
            ]),
            archiveAction: .archiveAction(configuration: .init(stringLiteral: APP.Configurations.stage.rawValue))
        ),
        .scheme(
            name: "App-Release-Run",
            buildAction: .buildAction(targets: [
                .target("App"),
                // framework
                .target("BackendKit"),
                .target("domainKit"),
                .target("EnvironmentKit"),
                .target("RepositoryKit"),
            ]),
            runAction: .runAction(
                configuration: .init(stringLiteral: APP.Configurations.release.rawValue)
            )
        ),
        .scheme(
            name: "App-Stage-Run",
            buildAction: .buildAction(targets: [
                .target("App"),
                // framework
                .target("BackendKit"),
                .target("domainKit"),
                .target("EnvironmentKit"),
                .target("RepositoryKit"),
            ]),
            runAction: .runAction(
                configuration: .init(stringLiteral: APP.Configurations.stage.rawValue)
            )
        ),
    ],
    resourceSynthesizers: [
        .strings(),
        .assets(),
        .fonts(),
        .custom(name: "Lottie", parser: .json, extensions: ["json"]),
    ]
)
