import Foundation
import Testing
@testable import Parsable

@Suite("Parsable")
struct ParsableTests {
	@Test("Decodes valid JSON with a custom date strategy")
	func decodeValidJSON() throws {
		let jsonString = #"{"error":"error message text","code":200,"date":1575981667984}"#
		let expectedMessageValue = "error message text"
		let expectedCode = 200
		
		let decodedData = try #require(
			SampleErrorModel.decodeFromData(
				data: Data(jsonString.utf8),
				withDateDecodingStrategy: .millisecondsSince1970
			)
		)
		
		#expect(decodedData.error == expectedMessageValue)
		#expect(decodedData.code == expectedCode)
		#expect(decodedData.date?.timeIntervalSince1970 == 1_575_981_667.984)
	}

	@Test("Returns nil for malformed JSON")
	func decodeInvalidJSON() {
		let errorData = Data(#""message":"error message text"}"#.utf8)
		let decodedData = SampleErrorModel.decodeFromData(data: errorData)
		
		#expect(decodedData == nil)
	}
	
	@Test("Round-trips encoded data with a custom date strategy")
	func encode() throws {
		let expectedDate = Date(timeIntervalSince1970: 1_575_981_667.984)
		let expectedMessage = "error message text"
		
		let error = SampleErrorModel(
			error: expectedMessage,
			code: 404,
			date: expectedDate
		)
		let encodedData = try #require(
			SampleErrorModel.encode(
				fromEncodable: error,
				withDateEncodingStrategy: .millisecondsSince1970
			)
		)
		let decodedModel = try #require(
			SampleErrorModel.decodeFromData(
				data: encodedData,
				withDateDecodingStrategy: .millisecondsSince1970
			)
		)
		
		#expect(decodedModel.date == expectedDate)
		#expect(decodedModel.error == expectedMessage)
		#expect(decodedModel.code == 404)
	}

	@Test("Uses seconds since 1970 by default when decoding")
	func decodeUsesDefaultDateStrategy() throws {
		let jsonString = #"{"error":"default strategy","date":1575981667.984}"#
		let decodedData = try #require(SampleErrorModel.decodeFromData(data: Data(jsonString.utf8)))
		
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
		let encodedData = try #require(SampleErrorModel.encode(fromEncodable: model))
		let jsonObject = try #require(
			JSONSerialization.jsonObject(with: encodedData) as? [String: Any]
		)

		#expect(jsonObject["error"] as? String == "default strategy")
		#expect(jsonObject["code"] as? Int == 200)
		#expect(jsonObject["date"] as? Double == 1_575_981_667.984)
	}

	@Test("Returns nil when model decoding throws")
	func decodeReturnsNilWhenModelDecodingFails() {
		let decodedData = FailingDecodableModel.decodeFromData(data: Data("{}".utf8))
		
		#expect(decodedData == nil)
	}

	@Test("Returns nil when model encoding throws")
	func encodeReturnsNilWhenModelEncodingFails() {
		let encodedData = FailingEncodableModel.encode(fromEncodable: FailingEncodableModel())
		
		#expect(encodedData == nil)
	}
}

private enum ParseableTestError: Error {
	case expectedFailure
}

private struct FailingDecodableModel: Codable, Parseable {
	typealias ParseableType = Self
	
	init() {}
	
	init(from decoder: Decoder) throws {
		throw ParseableTestError.expectedFailure
	}
}

private struct FailingEncodableModel: Codable, Parseable {
	typealias ParseableType = Self
	
	init() {}
	
	init(from decoder: Decoder) throws {
		self.init()
	}
	
	func encode(to encoder: Encoder) throws {
		throw ParseableTestError.expectedFailure
	}
}
