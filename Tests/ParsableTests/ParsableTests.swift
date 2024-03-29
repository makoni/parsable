import XCTest
@testable import Parsable


final class ParsableTests: XCTestCase {
    func testDecode_validJSON() {
		let jsonString = "{\"error\":\"error message text\",\"code\":200,\"date\":1575981667984}"
		let expectedMessageValue = "error message text"
		let expectedCode = 200
		
		let data = jsonString.data(using: .utf8)
		let decodedData = SampleErrorModel.decodeFromData(data: data!, withDateDecodingStrategy: .millisecondsSince1970)
		
		XCTAssertNotNil(decodedData, "error should not be nil")
		XCTAssertEqual(decodedData?.error, expectedMessageValue, "message should be equal to expected")
		XCTAssertNotNil(decodedData?.code)
		XCTAssertEqual(decodedData?.code, expectedCode, "code should be equal to expected")
		
		XCTAssertEqual(decodedData?.date?.timeIntervalSince1970, 1575981667984 / 1000, "code should be equal to expected")
	}

	func testDecode_invalidJSON() {
		let errorData = "\"message\":\"error message text\"}"
		let decodedData = SampleErrorModel.decodeFromData(data: errorData.data(using: .utf8)!)
		
		XCTAssertNil(decodedData)
	}
	
	func testEncode() {
		let expectedDate = Date(timeIntervalSince1970: TimeInterval(1575981667.984))
		let exmectedMessage = "error message text"
		
		let error = SampleErrorModel(
			error: exmectedMessage,
			code: 404,
			date: expectedDate
		)
		let encodedData = SampleErrorModel.encode(fromEncodable: error, withDateEncodingStrategy: .millisecondsSince1970)
		
		XCTAssertNotNil(encodedData, "data should not be nil")
		
		let decodedModel = SampleErrorModel.decodeFromData(data: encodedData!, withDateDecodingStrategy: .millisecondsSince1970)
		
		
		XCTAssertEqual(decodedModel!.date, expectedDate, "Dates should be equal")
		XCTAssertEqual(decodedModel!.error, exmectedMessage, "Messages should be equal")
		XCTAssertEqual(decodedModel!.code, 404, "Codes should be equal")
	}
}
