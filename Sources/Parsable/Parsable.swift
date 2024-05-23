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

	/// Decode JSON to Parsable model.
	/// - Parameters:
	///   - data: JSON data.
	///   - withDateDecodingStrategy: Date decoding strategy.
	/// - Returns: Parsed object/scruct of assosiated type.
	static func decodeFromData(data: Data, withDateDecodingStrategy: JSONDecoder.DateDecodingStrategy) -> ParseableType?

	/// Encode self to JSON data.
	/// - Parameters:
	///   - encodable: Model type.
	///   - withDateEncodingStrategy: Date encoding strategy.
	/// - Returns: JSON Data.
	static func encode(fromEncodable encodable: ParseableType, withDateEncodingStrategy: JSONEncoder.DateEncodingStrategy) -> Data?
}


// MARK: - Default protocol implementation
extension Parseable {
	
	/// Prints a debug log message to the console, including filename, method name, and line number.
	///
	/// This function is only enabled in debug builds (`#if DEBUG`).
	///
	/// - Parameters:
	///   - messages: The items to be printed. These can be any type that can be converted to a string.
	///   - file: The full path to the source file where the log is being made. Defaults to the current file (`#file`).
	///   - line: The line number in the source file where the log is being made. Defaults to the current line (`#line`).
	///   - functionName: The name of the function or method where the log is being made. Defaults to the current function/method (`#function`).
	private static func DLog(_ messages: Any..., fullPath: String = #file, line: Int = #line, functionName: String = #function) {
		#if DEBUG
		let file = URL(fileURLWithPath: fullPath)
		for message in messages {
			let string = "\(file.pathComponents.last!):\(line) -> \(functionName): \(message)"
			print(string)
		}
		#endif
	}
	
	/// Decodes JSON data into a Swift model object that conforms to the `Parsable` protocol.
	///
	/// This function attempts to decode the provided JSON data into an instance of the `ParseableType`.
	/// If the decoding is successful, the parsed model object is returned. Otherwise, `nil` is returned
	/// and an error message is logged using the `DLog` function (assuming it's defined).
	///
	/// - Parameters:
	///   - data: The JSON data to be decoded.
	///   - dateDecodingStrategy: (Optional) The strategy for decoding dates in the JSON.
	///     Defaults to `.secondsSince1970` (number of seconds since 1970).
	/// - Returns: An instance of the `ParseableType` if the decoding is successful, otherwise `nil`.
	public static func decodeFromData(data: Data, withDateDecodingStrategy dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970) -> ParseableType? {
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

	/// Encodes a Swift model object that conforms to the `Parsable` protocol into JSON data.
	///
	/// This function attempts to encode the provided model object (`encodable`) into JSON data.
	/// If the encoding is successful, the encoded data is returned. Otherwise, `nil` is returned
	/// and an error message is logged using the `DLog` function (assuming it's defined).
	///
	/// - Parameters:
	///   - encodable: The model object to be encoded. It must conform to the `Parseable` protocol.
	///   - dateEncodingStrategy: (Optional) The strategy for encoding dates in the JSON.
	///     Defaults to `.secondsSince1970` (number of seconds since 1970).
	/// - Returns: The encoded JSON data if successful, otherwise `nil`.
	public static func encode(fromEncodable encodable: ParseableType, withDateEncodingStrategy dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .secondsSince1970) -> Data? {
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
