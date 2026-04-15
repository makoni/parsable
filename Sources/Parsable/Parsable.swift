import Foundation

/// Additional context about a compatibility-helper failure.
public struct ParsableFailureContext: Sendable {
	/// The source filename where the failure was handled.
	public let file: String

	/// The source line where the failure was handled.
	public let line: Int

	/// The helper function that handled the failure.
	public let functionName: String

	/// Creates a new failure context value.
	///
	/// - Parameters:
	///   - file: The source filename where the failure was handled.
	///   - line: The source line where the failure was handled.
	///   - functionName: The helper function that handled the failure.
	public init(file: String, line: Int, functionName: String) {
		self.file = file
		self.line = line
		self.functionName = functionName
	}
}

/// Global configuration for `Parsable`.
public enum ParsableConfiguration {
	/// A closure that receives failures from deprecated compatibility helpers.
	public typealias FailureLogger = (_ error: any Error, _ context: ParsableFailureContext) -> Void

	private nonisolated(unsafe) static let defaultFailureLogger: FailureLogger = { error, context in
		print("\(context.file):\(context.line) -> \(context.functionName): \(error.localizedDescription)")
	}

	private static let configurationLock = NSLock()
	private nonisolated(unsafe) static var storedFailureLogger: FailureLogger? = defaultFailureLogger

	/// The logger used by deprecated compatibility helpers.
	///
	/// Logging is enabled by default. Set this value to `nil` to disable logging completely,
	/// or replace it with your own closure to redirect failures elsewhere.
	public static var failureLogger: FailureLogger? {
		get {
			configurationLock.withLock {
				storedFailureLogger
			}
		}
		set {
			configurationLock.withLock {
				storedFailureLogger = newValue
			}
		}
	}

	/// Re-enables the built-in failure logger.
	public static func enableDefaultFailureLogging() {
		failureLogger = defaultFailureLogger
	}

	/// Disables failure logging for deprecated compatibility helpers.
	public static func disableFailureLogging() {
		failureLogger = nil
	}
}

/// A marker protocol that adds convenient JSON encoding and decoding helpers to `Codable` models.
///
/// Conforming types only need to adopt `Parseable`; the default implementation provides both
/// primary throwing APIs and compatibility helpers that return `nil` on failure.
public protocol Parseable: Codable {}

// MARK: - Default protocol implementation
extension Parseable {
	private static func logFailure(
		_ error: Error,
		fullPath: String = #file,
		line: Int = #line,
		functionName: String = #function
	) {
		let filename = URL(fileURLWithPath: fullPath).lastPathComponent
		let context = ParsableFailureContext(file: filename, line: line, functionName: functionName)
		ParsableConfiguration.failureLogger?(error, context)
	}

	/// Decodes a model from JSON data using the default `.secondsSince1970` date strategy.
	///
	/// - Parameter data: The JSON data to decode.
	/// - Returns: A decoded instance of `Self`.
	/// - Throws: Any error thrown by `JSONDecoder`.
	public static func decode(from data: Data) throws -> Self {
		try decode(from: data, dateDecodingStrategy: .secondsSince1970)
	}

	/// Decodes a model from JSON data using a specific date decoding strategy.
	///
	/// - Parameters:
	///   - data: The JSON data to decode.
	///   - dateDecodingStrategy: The date decoding strategy to apply to the decoder.
	/// - Returns: A decoded instance of `Self`.
	/// - Throws: Any error thrown by `JSONDecoder`.
	public static func decode(
		from data: Data,
		dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
	) throws -> Self {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = dateDecodingStrategy
		return try decode(from: data, using: decoder)
	}

	/// Decodes a model from JSON data using a fully configured decoder.
	///
	/// - Parameters:
	///   - data: The JSON data to decode.
	///   - decoder: A configured decoder to use as-is.
	/// - Returns: A decoded instance of `Self`.
	/// - Throws: Any error thrown by `JSONDecoder`.
	public static func decode(from data: Data, using decoder: JSONDecoder) throws -> Self {
		try decoder.decode(Self.self, from: data)
	}

	/// Encodes a model using the default `.secondsSince1970` date strategy.
	///
	/// - Returns: The encoded JSON data.
	/// - Throws: Any error thrown by `JSONEncoder`.
	public func encoded() throws -> Data {
		try encoded(dateEncodingStrategy: .secondsSince1970)
	}

	/// Encodes a model using a specific date encoding strategy.
	///
	/// - Parameter dateEncodingStrategy: The date encoding strategy to apply to the encoder.
	/// - Returns: The encoded JSON data.
	/// - Throws: Any error thrown by `JSONEncoder`.
	public func encoded(dateEncodingStrategy: JSONEncoder.DateEncodingStrategy) throws -> Data {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = dateEncodingStrategy
		return try encoded(using: encoder)
	}

	/// Encodes a model using a fully configured encoder.
	///
	/// - Parameter encoder: A configured encoder to use as-is.
	/// - Returns: The encoded JSON data.
	/// - Throws: Any error thrown by `JSONEncoder`.
	public func encoded(using encoder: JSONEncoder) throws -> Data {
		try encoder.encode(self)
	}

	/// Decodes JSON data into a model using a date decoding strategy and returns `nil` on failure.
	///
	/// This compatibility helper preserves the original API shape. Prefer the throwing
	/// ``decode(from:)``, ``decode(from:dateDecodingStrategy:)``, or ``decode(from:using:)``
	/// overloads in new code when you need access to the underlying error. Failures are
	/// forwarded to ``ParsableConfiguration/failureLogger`` when logging is enabled.
	///
	/// - Parameters:
	///   - data: The JSON data to decode.
	///   - dateDecodingStrategy: The date decoding strategy to apply to the decoder.
	/// - Returns: A decoded instance of `Self`, or `nil` when decoding fails.
	@available(
		*,
		deprecated,
		message: "Use decode(from:dateDecodingStrategy:) and handle the thrown error instead."
	)
	public static func decodeFromData(
		data: Data,
		withDateDecodingStrategy dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970
	) -> Self? {
		do {
			return try decode(from: data, dateDecodingStrategy: dateDecodingStrategy)
		} catch {
			logFailure(error)
			return nil
		}
	}

	/// Encodes a model into JSON data using a date encoding strategy and returns `nil` on failure.
	///
	/// This compatibility helper preserves the original API shape. Prefer ``encoded()``,
	/// ``encoded(dateEncodingStrategy:)``, or ``encoded(using:)`` in new code when you need
	/// access to the underlying error. Failures are forwarded to
	/// ``ParsableConfiguration/failureLogger`` when logging is enabled.
	///
	/// - Parameters:
	///   - encodable: The model to encode.
	///   - dateEncodingStrategy: The date encoding strategy to apply to the encoder.
	/// - Returns: Encoded JSON data, or `nil` when encoding fails.
	@available(
		*,
		deprecated,
		message: "Use encoded(dateEncodingStrategy:) on the model instance and handle the thrown error instead."
	)
	public static func encode(
		fromEncodable encodable: Self,
		withDateEncodingStrategy dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .secondsSince1970
	) -> Data? {
		do {
			return try encodable.encoded(dateEncodingStrategy: dateEncodingStrategy)
		} catch {
			logFailure(error)
			return nil
		}
	}
}

private extension NSLock {
	func withLock<T>(_ body: () throws -> T) rethrows -> T {
		lock()
		defer { unlock() }
		return try body()
	}
}
