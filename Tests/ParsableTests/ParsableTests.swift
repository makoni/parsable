import XCTest
@testable import Parsable


final class ParsableTests: XCTestCase {
    func testDecode_validJSON() {
		let jsonString = "{\"error\":\"error message text\",\"code\":200}"
		let expectedMessageValue = "error message text"
		let expectedCode = 200
		
		let data = jsonString.data(using: .utf8)
		let decodedData = SampleErrorModel.decodeFromData(data: data!)
		
		XCTAssertNotNil(decodedData, "error should not be nil")
		XCTAssertEqual(decodedData?.error, expectedMessageValue, "message should be equal to expected")
		XCTAssertNotNil(decodedData?.code)
		XCTAssertEqual(decodedData?.code, expectedCode, "code should be equal to expected")
	}
	
	func testDecode_invalidJSON() {
		let errorData = "\"message\":\"error message text\"}"
		let decodedData = SampleErrorModel.decodeFromData(data: errorData.data(using: .utf8)!)
		
		XCTAssertNil(decodedData)
	}
	
	func testEncode() {
		let error = SampleErrorModel(error: "error message text", code: 404)
		let expectedJSONString = "{\"error\":\"error message text\",\"code\":404}"
		
		let encodedData = SampleErrorModel.encode(fromEncodable: error)
		let dataString = String(data: encodedData!, encoding: .utf8)
		
		XCTAssertNotNil(encodedData, "data should not be nil")
		XCTAssertEqual(dataString, expectedJSONString, "Error message should be equal")
	}
	
	static var allTests = [
        ("testDecode_validJSON", testDecode_validJSON),
		("testDecode_invalidJSON", testDecode_invalidJSON),
		("testEncode", testEncode),
    ]
}
