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
	
	/// Decode JSON to Parsable model
	/// - Parameters:
	///   - data: JSON data
	///   - dateDecodingStrategy: date decoding strategy
	static func decodeFromData(data: Data, withDateDecodingStrategy: JSONDecoder.DateDecodingStrategy) -> ParseableType?
	
	/// Encode self to string
	///
	/// - Returns: Data
	static func encode(fromEncodable encodable: ParseableType) -> Data?
	
	static func encode(fromEncodable encodable: ParseableType, withDateEncodingStrategy: JSONEncoder.DateEncodingStrategy) -> Data?
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
		return decodeFromData(data: data, withDateDecodingStrategy: .secondsSince1970)
	}
	
	/// Decode JSON to Parsable model
	/// - Parameters:
	///   - data: JSON data
	///   - dateDecodingStrategy: date decoding strategy
	public static func decodeFromData(data: Data, withDateDecodingStrategy dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) -> ParseableType? {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = dateDecodingStrategy
		
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
		return encode(fromEncodable: encodable, withDateEncodingStrategy: .secondsSince1970)
	}
	
	/// Encode Parsable model to Data
	/// - Parameters:
	///   - encodable: model
	///   - dateEncodingStrategy: date encoding strategy
	public static func encode(fromEncodable encodable: ParseableType, withDateEncodingStrategy dateEncodingStrategy: JSONEncoder.DateEncodingStrategy) -> Data? {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = dateEncodingStrategy
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
