# ``Parsable``

A lightweight protocol that adds convenient JSON encoding and decoding helpers to `Codable` models.

## Overview

Adopt ``Parseable`` on any `Codable` type to get:

- Throwing decode helpers such as ``Parseable/decode(from:)``
- Throwing encode helpers such as ``Parseable/encoded()``
- Overloads that accept a date strategy
- Overloads that accept a fully configured `JSONDecoder` or `JSONEncoder`
- Compatibility helpers that return `nil` on failure

Conformance is intentionally lightweight:

```swift
import Foundation
import Parsable

struct APIError: Codable {
    let error: String
    let code: Int
    let date: Date
}

extension APIError: Parseable {}
```

## Installation

Add `Parsable` to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/makoni/parsable.git", from: "1.0.0"),
]
```

## Decode and encode with the primary API

The primary API is throwing, which keeps the original `JSONDecoder` / `JSONEncoder` error available to your code:

```swift
let jsonData = Data(#"{"error":"Not Found","code":404,"date":1713171900}"#.utf8)

let decodedError = try APIError.decode(from: jsonData)
let encodedError = try decodedError.encoded()
```

If your API uses milliseconds for dates, use the date-strategy overloads:

```swift
let decodedError = try APIError.decode(
    from: jsonData,
    dateDecodingStrategy: .millisecondsSince1970
)

let encodedError = try decodedError.encoded(
    dateEncodingStrategy: .millisecondsSince1970
)
```

## Use a configured decoder or encoder

When you need `keyDecodingStrategy`, `keyEncodingStrategy`, or any other custom `JSONDecoder` / `JSONEncoder` setting, pass the configured object directly:

```swift
struct APIResponse: Codable {
    let errorMessage: String
    let statusCode: Int
}

extension APIResponse: Parseable {}

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let responseData = Data(#"{"error_message":"Not Found","status_code":404}"#.utf8)
let response = try APIResponse.decode(from: responseData, using: decoder)

let encoder = JSONEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase

let encodedResponse = try response.encoded(using: encoder)
```

## Compatibility helpers

The original nil-returning helpers remain available for convenience and compatibility:

```swift
let decodedError = APIError.decodeFromData(data: jsonData)
let encodedError = APIError.encode(
    fromEncodable: APIError(error: "Not Found", code: 404, date: .now)
)
```

These helpers return `nil` on failure and emit a debug log in debug builds. Prefer the throwing APIs for new code when you want access to the underlying error.

## Migration notes

If you were using an older version of the library:

- Replace `extension Model: Parseable { typealias ParseableType = Self }` with `extension Model: Parseable {}`
- Prefer ``Parseable/decode(from:)`` over ``Parseable/decodeFromData(data:withDateDecodingStrategy:)``
- Prefer ``Parseable/encoded()`` over ``Parseable/encode(fromEncodable:withDateEncodingStrategy:)``
- Use the `using:` overloads when you already have a configured decoder or encoder

## Topics

- ``Parseable``
- ``Parseable/decode(from:)``
- ``Parseable/decode(from:dateDecodingStrategy:)``
- ``Parseable/decode(from:using:)``
- ``Parseable/encoded()``
- ``Parseable/encoded(dateEncodingStrategy:)``
- ``Parseable/encoded(using:)``
- ``Parseable/decodeFromData(data:withDateDecodingStrategy:)``
- ``Parseable/encode(fromEncodable:withDateEncodingStrategy:)``
