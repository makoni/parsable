//
//  Parseable.swift
//  haterlive
//
//  Created by Sergey Armodin on 23.09.2019.
//  Copyright © 2019 Sergei Armodin. All rights reserved.
//

import Foundation


/// Protocol for types that available for JSON Parse/Encode
public protocol Parseable {
	
	// MARK: - Assissiated type for codable type
	associatedtype ParseableType: Codable
	
	/// Decode from data
	///
	/// - Parameter data: data
	/// - Returns: Parsed object/scruct of assosiated type
	static func decodeFromData(data: Data) -> ParseableType?
	
	/// Encode self to string
	///
	/// - Returns: Data
	static func encode(fromEncodable encodable: ParseableType) -> Data?
}


// MARK: - Default protocol implementation
extension Parseable {
	
	/// Debug log function with printing filename, method and line number
	///
	/// - Parameters:
	///   - messages: arguments
	///   - fullPath: filepath
	///   - line: line number
	///   - functionName: function/method name
	private static func DLog(_ messages: Any..., fullPath: String = #file, line: Int = #line, functionName: String = #function) {
		#if DEBUG
		let file = URL(fileURLWithPath: fullPath)
		for message in messages {
			let string = "\(file.pathComponents.last!):\(line) -> \(functionName): \(message)"
			print(string)
		}
		#endif
	}

	
	/// Decode JSON to Parsable model
	/// - Parameter data: JSON data
	public static func decodeFromData(data: Data) -> ParseableType? {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .secondsSince1970
		
		var decodedData: ParseableType?
		
		do {
			decodedData = try decoder.decode(ParseableType.self, from: data)
		} catch (let error) {
			Self.DLog(error.localizedDescription)
			return nil
		}
		
		return decodedData
	}
	
	/// Encode Parsable model to Data
	/// - Parameter encodable: model
	public static func encode(fromEncodable encodable: ParseableType) -> Data? {
		let encoder = JSONEncoder()
		var encodedData: Data
		do {
			encodedData = try encoder.encode(encodable)
		} catch (let error) {
			Self.DLog(error.localizedDescription)
			return nil
		}
		
		return encodedData
	}
}
