//
//  SampleErrorModel.swift
//  
//
//  Created by Sergey Armodin on 23/09/2019.
//

import Foundation


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
