//
//  ProtocolAwardModelAccessStrategy.swift
//  f31Model
//
//  Created by David on 08/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the Award model data
public protocol ProtocolAwardModelAccessStrategy {
	
	// MARK: - Methods
	
	/// Select items by authorID
	///
	/// - Parameters:
	///   - authorID: The authorID
	///   - year: The year
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func select(byAuthorID authorID: Int, year: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
