//
//  ProtocolVolumeCommentModelAccessStrategy.swift
//  f31Model
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the VolumeComment model data
public protocol ProtocolVolumeCommentModelAccessStrategy {
	
	// MARK: - Methods

	/// Select items by volumeID
	///
	/// - Parameters:
	///   - volumeID: The volumeID
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func select(byVolumeID volumeID: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
