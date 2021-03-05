// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "{{name}}",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),{{#fluent}}
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-{{fluent.db.url}}-driver.git", from: "{{fluent.db.version}}"),{{/fluent}}{{#leaf}}
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0"),{{/leaf}}{{#mongoDB}}
        .package(url: "https://github.com/mongodb/mongodb-vapor.git", from: "1.0.0"),{{/mongoDB}}
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [{{#fluent}}
                .product(name: "Fluent", package: "fluent"),
                .product(name: "Fluent{{fluent.db.module}}Driver", package: "fluent-{{fluent.db.url}}-driver"),{{/fluent}}{{#leaf}}
                .product(name: "Leaf", package: "leaf"),{{/leaf}}{{#mongoDB}}
                .product(name: "MongoDBVapor", package: "mongodb-vapor"),{{/mongoDB}}
                .product(name: "Vapor", package: "vapor")
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(name: "Run",
            dependencies: [
                .target(name: "App"),{{#mongoDB}}
                .product(name: "MongoDBVapor", package: "mongodb-vapor"),{{/mongoDB}}
            ]
        ),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
