# Parsable

Syntax sugar that makes JSON decoding more elegant.

[![Swift 5](https://img.shields.io/badge/swift-5.5-orange.svg?style=flat)](http://swift.org) [![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/) ![Build and test](https://github.com/makoni/parsable/workflows/Build%20and%20test/badge.svg?branch=master)


## Installation

### Swift Package Manager

Add to the `dependencies` value of your `Package.swift`.

#### Swift 5

```swift
dependencies: [
	.package(url: "https://github.com/makoni/parsable.git", from: "1.0.0"),
]
```

## Usage


Example struct should conform to Codable and Parseable protocols:

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
```

Encode model -> JSON:

```swift
let sampleModel = SampleErrorModel(error: "error message text", code: 404)
let jsonData = SampleErrorModel.encode(fromEncodable: sampleModel)
// or
let jsonData = SampleErrorModel.encode(fromEncodable: error, withDateEncodingStrategy: .millisecondsSince1970)
```

Decode JSON -> model:

```swift
let decodedModel = SampleErrorModel.decodeFromData(data: jsonData)
// or
let decodedModel = SampleErrorModel.decodeFromData(data: jsonData, withDateDecodingStrategy: .millisecondsSince1970)
```
