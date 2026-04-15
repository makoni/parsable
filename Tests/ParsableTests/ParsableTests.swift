import Foundation
import Testing
@testable import Parsable

@Suite("Parsable", .serialized)
struct ParsableTests {
	@Test("Decodes valid JSON with a custom date strategy")
	func decodeWithCustomDateStrategy() throws {
		let jsonString = #"{"error":"error message text","code":200,"date":1575981667984}"#
		let expectedMessageValue = "error message text"
		let expectedCode = 200
		
		let decodedData = try SampleErrorModel.decode(
			from: Data(jsonString.utf8),
			dateDecodingStrategy: .millisecondsSince1970
		)
		
		#expect(decodedData.error == expectedMessageValue)
		#expect(decodedData.code == expectedCode)
		#expect(decodedData.date?.timeIntervalSince1970 == 1_575_981_667.984)
	}

	@Test("Decodes valid JSON with a configured decoder")
	func decodeWithConfiguredDecoder() throws {
		let jsonString = #"{"error_message":"error message text","status_code":200}"#
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let decodedData = try SnakeCaseModel.decode(from: Data(jsonString.utf8), using: decoder)
		
		#expect(decodedData.errorMessage == "error message text")
		#expect(decodedData.statusCode == 200)
	}
	
	@Test("Round-trips encoded data with a custom date strategy")
	func encodeWithCustomDateStrategy() throws {
		let expectedDate = Date(timeIntervalSince1970: 1_575_981_667.984)
		let expectedMessage = "error message text"
		
		let error = SampleErrorModel(
			error: expectedMessage,
			code: 404,
			date: expectedDate
		)
		let encodedData = try error.encoded(
			dateEncodingStrategy: .millisecondsSince1970
		)
		let decodedModel = try SampleErrorModel.decode(
			from: encodedData,
			dateDecodingStrategy: .millisecondsSince1970
		)
		
		#expect(decodedModel.date == expectedDate)
		#expect(decodedModel.error == expectedMessage)
		#expect(decodedModel.code == 404)
	}

	@Test("Encodes valid JSON with a configured encoder")
	func encodeWithConfiguredEncoder() throws {
		let model = SnakeCaseModel(errorMessage: "error message text", statusCode: 404)
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		let encodedData = try model.encoded(using: encoder)
		let jsonObject = try #require(
			JSONSerialization.jsonObject(with: encodedData) as? [String: Any]
		)

		#expect(jsonObject["error_message"] as? String == "error message text")
		#expect(jsonObject["status_code"] as? Int == 404)
	}

	@Test("Round-trips configured coders with snake case and milliseconds")
	func roundTripsConfiguredCodersWithSnakeCaseAndMilliseconds() throws {
		let jsonString = #"{"created_at":1575981667984,"status_code":202}"#
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .millisecondsSince1970

		let decodedModel = try SnakeCaseDateModel.decode(from: Data(jsonString.utf8), using: decoder)

		#expect(decodedModel.createdAt == Date(timeIntervalSince1970: 1_575_981_667.984))
		#expect(decodedModel.statusCode == 202)

		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		encoder.dateEncodingStrategy = .millisecondsSince1970

		let encodedData = try decodedModel.encoded(using: encoder)
		let jsonObject = try #require(
			JSONSerialization.jsonObject(with: encodedData) as? [String: Any]
		)

		#expect(jsonObject["created_at"] as? Double == 1_575_981_667_984)
		#expect(jsonObject["status_code"] as? Int == 202)
	}

	@Test("Uses seconds since 1970 by default when decoding")
	func decodeUsesDefaultDateStrategy() throws {
		let jsonString = #"{"error":"default strategy","date":1575981667.984}"#
		let decodedData = try SampleErrorModel.decode(from: Data(jsonString.utf8))
		
		#expect(decodedData.error == "default strategy")
		#expect(decodedData.date == Date(timeIntervalSince1970: 1_575_981_667.984))
	}

	@Test("Uses seconds since 1970 by default when encoding")
	func encodeUsesDefaultDateStrategy() throws {
		let model = SampleErrorModel(
			error: "default strategy",
			code: 200,
			date: Date(timeIntervalSince1970: 1_575_981_667.984)
		)
		let encodedData = try model.encoded()
		let jsonObject = try #require(
			JSONSerialization.jsonObject(with: encodedData) as? [String: Any]
		)

		#expect(jsonObject["error"] as? String == "default strategy")
		#expect(jsonObject["code"] as? Int == 200)
		#expect(jsonObject["date"] as? Double == 1_575_981_667.984)
	}

	@Test("Throws when malformed JSON is decoded")
	func decodeThrowsForMalformedJSON() {
		let errorData = Data(#""message":"error message text"}"#.utf8)

		do {
			_ = try SampleErrorModel.decode(from: errorData)
			Issue.record("Expected decode to throw for malformed JSON")
		} catch {
			#expect(error is DecodingError)
		}
	}

	@Test("Throws when model decoding fails")
	func decodeThrowsWhenModelDecodingFails() {
		do {
			_ = try FailingDecodableModel.decode(from: Data("{}".utf8))
			Issue.record("Expected model decoding to throw")
		} catch {
			#expect(error as? ParseableTestError == .expectedFailure)
		}
	}

	@Test("Throws when model encoding fails")
	func encodeThrowsWhenModelEncodingFails() {
		do {
			_ = try FailingEncodableModel().encoded()
			Issue.record("Expected model encoding to throw")
		} catch {
			#expect(error as? ParseableTestError == .expectedFailure)
		}
	}

	@Test("Compatibility decode helper returns nil for malformed JSON")
	@available(*, deprecated)
	func compatibilityDecodeReturnsNilForMalformedJSON() {
		let errorData = Data(#""message":"error message text"}"#.utf8)
		let decodedData = SampleErrorModel.decodeFromData(data: errorData)

		#expect(decodedData == nil)
	}

	@Test("Compatibility decode helper returns nil when model decoding fails")
	@available(*, deprecated)
	func compatibilityDecodeReturnsNilWhenModelDecodingFails() {
		let decodedData = FailingDecodableModel.decodeFromData(data: Data("{}".utf8))
		
		#expect(decodedData == nil)
	}

	@Test("Compatibility encode helper returns nil when model encoding fails")
	@available(*, deprecated)
	func compatibilityEncodeReturnsNilWhenModelEncodingFails() {
		let encodedData = FailingEncodableModel.encode(fromEncodable: FailingEncodableModel())
		
		#expect(encodedData == nil)
	}

	@Test("Compatibility helpers use a custom failure logger")
	@available(*, deprecated)
	func compatibilityHelpersUseCustomFailureLogger() {
		let recorder = FailureRecorder()
		let previousLogger = ParsableConfiguration.failureLogger
		defer {
			ParsableConfiguration.failureLogger = previousLogger
		}

		ParsableConfiguration.failureLogger = { error, context in
			recorder.record(error: error, context: context)
		}

		_ = SampleErrorModel.decodeFromData(data: Data(#""message":"error message text"}"#.utf8))

		#expect(recorder.recordedErrors.count == 1)
		#expect(recorder.recordedErrors.first?.context.file == "Parsable.swift")
		#expect(recorder.recordedErrors.first?.context.functionName == "decodeFromData(data:withDateDecodingStrategy:)")
	}

	@Test("Compatibility helper logging can be disabled")
	@available(*, deprecated)
	func compatibilityHelperLoggingCanBeDisabled() {
		let recorder = FailureRecorder()
		let previousLogger = ParsableConfiguration.failureLogger
		defer {
			ParsableConfiguration.failureLogger = previousLogger
		}

		ParsableConfiguration.failureLogger = { error, context in
			recorder.record(error: error, context: context)
		}
		ParsableConfiguration.disableFailureLogging()

		_ = FailingEncodableModel.encode(fromEncodable: FailingEncodableModel())

		#expect(recorder.recordedErrors.isEmpty)
	}
}

private enum ParseableTestError: Error {
	case expectedFailure
}

private struct FailingDecodableModel: Codable, Parseable {
	init() {}
	
	init(from decoder: Decoder) throws {
		throw ParseableTestError.expectedFailure
	}
}

private struct FailingEncodableModel: Codable, Parseable {
	init() {}
	
	init(from decoder: Decoder) throws {
		self.init()
	}
	
	func encode(to encoder: Encoder) throws {
		throw ParseableTestError.expectedFailure
	}
}

private final class FailureRecorder {
	struct RecordedError {
		let errorDescription: String
		let context: ParsableFailureContext
	}

	private(set) var recordedErrors: [RecordedError] = []

	func record(error: any Error, context: ParsableFailureContext) {
		recordedErrors.append(
			RecordedError(
				errorDescription: error.localizedDescription,
				context: context
			)
		)
	}
}
