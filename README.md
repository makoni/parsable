# Parsable

This is a Swift library that provides a `Parseable` protocol for simplifying JSON encoding and decoding of your model objects.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmakoni%2Fparsable%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/makoni/parsable) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmakoni%2Fparsable%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/makoni/parsable) [![Build and test](https://github.com/makoni/parsable/actions/workflows/main.yml/badge.svg)](https://github.com/makoni/parsable/actions/workflows/main.yml)


### What is Parseable?

* A protocol that defines a common interface for JSON parsing and encoding.
* Allows your models to be easily converted to and from JSON data.

### Benefits of using Parseable:

* **Cleaner code:** Reduces boilerplate code for JSON parsing and encoding.
* **Consistent API:** Provides a consistent way to work with JSON data across your models.
* **Improved maintainability:** Easier to maintain code as the JSON format evolves.

### How to use Parseable:

1. **Conform your models to the Parseable protocol:**
   * Define an `associatedtype` named `ParseableType` that inherits from `Codable`.
   * Implement the static methods `decodeFromData` and `encode` as required by the protocol.

2. **Use the provided methods for JSON conversion:**
   * Call `decodeFromData(data:withDateDecodingStrategy:)` to parse JSON data into your model object.
   * Call `encode(fromEncodable:withDateDecodingStrategy:)` to convert your model object to JSON data.

**Optional `DLog` function:**

The provided code includes a private static function `DLog` for debug logging. This function is intended to be used for debugging purposes and is only enabled in debug builds. You can customize or remove this function based on your needs.

### Example Usage:

```swift
#import Parsable

// Define a model conforming to Codable
struct SampleErrorModel: Codable {
    var error: String
    var code: Int
}

// Parseable protocol conformance. That's it.
extension SampleErrorModel: Parseable {
    typealias ParseableType = Self
}

let sampleModel = SampleErrorModel(error: "error message text", code: 404)

// Example of decoding JSON data
let jsonData = // Your JSON data here

if let error = SampleErrorModel.decodeFromData(data: jsonData) {
  print("Error code: \(error.code)")
} else {
  print("Error decoding user data")
}

// Example of encoding a model object
if let encodedData = SampleErrorModel.encode(fromEncodable: sampleModel) {
  // Use the encoded data...
} else {
  print("Error encoding user data")
}
```

This is a basic example. You can customize the implementation of `decodeFromData` and `encode` methods in your models to handle specific data structures and logic.

## Installation

### Swift Package Manager

Add to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/makoni/parsable.git", from: "1.0.0"),
]
```

Here's some [documentation](https://spaceinbox.me/docs/parsable/documentation/parsable/).
