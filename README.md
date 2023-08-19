# Parsable

Syntax sugar that makes JSON decoding more elegant.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmakoni%2Fparsable%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/makoni/parsable) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmakoni%2Fparsable%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/makoni/parsable) [![Build and test](https://github.com/makoni/parsable/actions/workflows/main.yml/badge.svg)](https://github.com/makoni/parsable/actions/workflows/main.yml)


## Installation

### Swift Package Manager

Add to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/makoni/parsable.git", from: "1.0.0"),
]
```

## Usage

An example struct or class should conform to Codable and Parseable protocols:

```swift
#import Parsable

// Example struct that conforms to Codable protocol
struct SampleErrorModel: Codable {
    var error: String?
    var code: Int?
}

// Parseable protocol conformance. That's it.
extension SampleErrorModel: Parseable {
    typealias ParseableType = Self
}

let sampleModel = SampleErrorModel(error: "error message text", code: 404)
```

Struct -> JSON data:

```swift
let jsonData = SampleErrorModel.encode(
    fromEncodable: error, 
    withDateEncodingStrategy: .millisecondsSince1970
)
```

JSON data -> struct:

```swift
let decodedModel = SampleErrorModel.decodeFromData(
    data: jsonData,
    withDateDecodingStrategy: .millisecondsSince1970
)
```

Date decoding strategy is optional. Default value is:
```swift
let jsonData = SampleErrorModel.encode(fromEncodable: sampleModel)
let decodedModel = SampleErrorModel.decodeFromData(data: jsonData)
```

Here's some [documentation](https://spaceinbox.me/docs/parsable/documentation/parsable/).
