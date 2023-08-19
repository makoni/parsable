# ``Parsable``

Some syntax sugar for JSON encoding and decoding.

## Overview

**Parsable** is a simple protocol with a default implementation to add some syntax sugar for encoding and decoding JSON data in Swift.

Just add it to your `Package.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/makoni/parsable.git", from: "1.0.0"),
]
```

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
