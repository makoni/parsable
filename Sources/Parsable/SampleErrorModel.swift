//
//  SampleErrorModel.swift
//  
//
//  Created by Sergey Armodin on 23/09/2019.
//

import Foundation


// Example struct. Also for unit tests
struct SampleErrorModel: Codable {
	var error: String?
	var code: Int?
}

extension SampleErrorModel: Parseable {
	typealias ParseableType = Self
}
