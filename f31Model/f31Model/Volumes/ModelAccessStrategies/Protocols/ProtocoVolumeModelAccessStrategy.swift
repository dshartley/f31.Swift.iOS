//
//  ProtocolVolumeModelAccessStrategy.swift
//  f31Model
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the Volume model data
public protocol ProtocolVolumeModelAccessStrategy {
	
	// MARK: - Methods

	/// Select items by previousID, authorID and year
	///
	/// - Parameters:
	///	  - id: The id
	///   - authorID: The authorID
	///   - year: The year
	///   - numberofItemsToLoad: The numberofItemsToLoad
	///   - selectItemsAfterPreviousYN: The selectItemsAfterPreviousYN
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func select(byPreviousVolumeID id: Int, authorID: Int, year: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	/// Get the contentData for the volume
	///
	/// - Parameter volumeID: The volumeID
	func getContentData(forVolume volumeID: String, oncomplete completionHandler:@escaping (String?, Error?) -> Void)
	
	/// Add a like
	///
	/// - Parameter id: The id
	func addLike(id: Int)
	
}
