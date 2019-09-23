# Parsable

Synax sugar that makes JSON decoding more elegant.

[![Swift 5](https://img.shields.io/badge/swift-5.1-orange.svg?style=flat)](http://swift.org) [![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)


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


Example struct:

```swift
// Example struct. Also for unit tests
struct SampleErrorModel: Codable, Parseable {
	typealias ParseableType = SampleErrorModel
	
	var error: String?
	var code: Int?
	
	enum CodingKeys: String, CodingKey {
		case error
		case code
	}
	
	init(error: String?, code: Int?) {
		self.error = error
		self.code = code
	}
}


extension SampleErrorModel {
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let error = try container.decodeIfPresent(String.self, forKey: .error)
		let code = try container.decodeIfPresent(Int.self, forKey: .code)
		
		self.init(error: error, code: code)
	}
}
```

Decode JSON -> model:

```swift
let jsonString = "{\"error\":\"error message text\",\"code\":200}"
let data = jsonString.data(using: .utf8)
let decodedData = SampleErrorModel.decodeFromData(data: data!)
```

Encode model -> JSON:

```swift
let error = SampleErrorModel(error: "error message text", code: 404)
let encodedData = SampleErrorModel.encode(fromEncodable: error)
```
