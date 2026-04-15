//
//  SampleErrorModel.swift
//  
//
//  Created by Sergey Armodin on 23/09/2019.
//

import Foundation
import Parsable

struct SampleErrorModel: Codable, Parseable {
	var error: String?
	var code: Int?
	var date: Date?
}

struct SnakeCaseModel: Codable, Parseable {
	var errorMessage: String
	var statusCode: Int
}
