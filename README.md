# Parsable

`Parsable` is a small Swift library that adds lightweight JSON encoding and decoding helpers to any `Codable` model.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmakoni%2Fparsable%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/makoni/parsable)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmakoni%2Fparsable%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/makoni/parsable)
[![Build and test](https://github.com/makoni/parsable/actions/workflows/main.yml/badge.svg)](https://github.com/makoni/parsable/actions/workflows/main.yml)

## What it does

- Keeps conformance lightweight: `extension Model: Parseable {}`
- Provides primary throwing APIs for decoding and encoding
- Supports configured `JSONDecoder` and `JSONEncoder` instances
- Keeps the original nil-returning helpers for compatibility
- Lets you configure or disable compatibility-helper logging

## Installation

### Swift Package Manager

Add `Parsable` to the `dependencies` section of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/makoni/parsable.git", from: "1.0.0"),
]
```

## Quick start

```swift
import Foundation
import Parsable

struct APIError: Codable {
    let error: String
    let code: Int
    let date: Date
}

extension APIError: Parseable {}

let jsonData = Data("{\"error\":\"Not Found\",\"code\":404,\"date\":1713171900}".utf8)

let decodedError = try APIError.decode(from: jsonData)
let encodedError = try decodedError.encoded()
```

## Primary API

Use the throwing APIs when you want the underlying encoding or decoding error:

```swift
let decodedModel = try APIError.decode(from: jsonData)
let encodedData = try decodedModel.encoded()
```

For Unix timestamps in milliseconds:

```swift
let decodedModel = try APIError.decode(
    from: jsonData,
    dateDecodingStrategy: .millisecondsSince1970
)

let encodedData = try decodedModel.encoded(
    dateEncodingStrategy: .millisecondsSince1970
)
```

## Using a configured decoder or encoder

If you need key strategies or any other `JSONDecoder` / `JSONEncoder` configuration, pass your own instance:

```swift
struct APIResponse: Codable {
    let errorMessage: String
    let statusCode: Int
}

extension APIResponse: Parseable {}

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let responseData = Data("{\"error_message\":\"Not Found\",\"status_code\":404}".utf8)
let response = try APIResponse.decode(from: responseData, using: decoder)

let encoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase

let encodedResponse = try response.encoded(using: encoder)
```

## Compatibility helpers

The original API is still available as deprecated nil-returning convenience methods:

```swift
let decodedModel = APIError.decodeFromData(data: jsonData)
let encodedData = APIError.encode(fromEncodable: APIError(error: "Not Found", code: 404, date: .now))
```

Those helpers return `nil` and forward failures to `ParsableConfiguration.failureLogger` when logging is enabled. Prefer the throwing APIs in new code when you need to inspect errors.

## Compatibility helper logging

Deprecated compatibility helpers log failures through `ParsableConfiguration.failureLogger`, which is enabled by default.

```swift
ParsableConfiguration.failureLogger = { error, context in
    print("Parsable warning: \(context.file):\(context.line) \(error.localizedDescription)")
}

ParsableConfiguration.disableFailureLogging()
ParsableConfiguration.enableDefaultFailureLogging()
```

## Documentation

Hosted documentation: https://spaceinbox.me/docs/parsable/documentation/parsable/

The DocC source lives in `Sources/Parsable/Documentation.docc`.
