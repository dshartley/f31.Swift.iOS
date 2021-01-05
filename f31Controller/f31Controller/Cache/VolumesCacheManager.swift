//
//  VolumesCacheManager.swift
//  f31Controller
//
//  Created by David on 09/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import CoreData
import SFController
import f31Core
import f31Model

/// Manages cacheing for Volumes model data
public class VolumesCacheManager: CacheManagerBase {

	// MARK: - Private Static Properties
	
	fileprivate static var singleton:		VolumesCacheManager?
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var year:		Int = 0
	public fileprivate(set) var authorID:	Int = 0
	
	
	// MARK: - Initializers
	
	fileprivate override init() {
		super.init()
		
		self.entityName = "Volumes"
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var shared: VolumesCacheManager {
		get {
			
			if (VolumesCacheManager.singleton == nil) {
				VolumesCacheManager.singleton = VolumesCacheManager()
			}
			
			return VolumesCacheManager.singleton!
		}
	}
	
	
	// MARK: - Public Methods
	
	public func set(year: Int, authorID: Int) {
		
		self.year 		= year
		self.authorID 	= authorID
		
		// Set predicate
		self.predicate = NSPredicate(format: "year == %@ AND authorID == %@", argumentArray: [year, authorID])
		
	}
	
	public func select(byPreviousVolumeID: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool) -> [Any] {
		
		var result: [Any] = [Any]()
		
		guard (self.collection != nil) else { return result }
		
		// Find the item
		var itemFoundIndex: Int		= 0
		var isFoundYN:		Bool	= false
		
		// Check byPreviousVolumeID is specified
		if (byPreviousVolumeID > 0) {
			
			var item:		Volume?	= nil
			
			// Go through each item until isFoundYN
			while (!isFoundYN && itemFoundIndex <= self.collection!.items!.count - 1) {
				
				item = (self.collection!.items![itemFoundIndex] as! Volume)
				
				// Check item id
				if (item!.id == String(byPreviousVolumeID)) {
					
					isFoundYN = true
					
				} else {
					
					itemFoundIndex += 1
				}
			}
			
			// Check isFoundYN
			if (!isFoundYN) { return result }
		}
		
		var itemsToAdd:		Int			= numberofItemsToLoad
		var item:			Volume?	= nil
		var itemData:		Any?		= nil
		
		
		var itemIndex:		Int			= 0
		
		// Check if item found
		if (isFoundYN) {
			
			// Set item index to item before or after the found item
			if (selectItemsAfterPreviousYN) {
				
				itemIndex = itemFoundIndex + 1
				
			} else {
				
				itemIndex = itemFoundIndex - 1
			}
		}
		
		while (itemsToAdd > 0 && itemIndex >= 0 && itemIndex <= self.collection!.items!.count - 1) {
			
			// Get the item
			item		= (self.collection!.items![itemIndex] as! Volume)
			
			// Get itemData
			itemData	= item?.dataNode! as Any
			
			if (selectItemsAfterPreviousYN) {
				
				// Append to data
				result.append(itemData!)
				
				itemIndex += 1
				
			} else {
				
				// Prepend to data
				result.insert(itemData!, at: 0)
				
				itemIndex -= 1
			}
			
			itemsToAdd -= 1
		}
		
		return result
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseCacheData() {
		
		self.collection	= VolumeCollection()
		
	}
	
	public override func setAttributes(cacheData: NSManagedObject) {
		
		// Set year
		cacheData.setValue(self.year, forKeyPath: "year")
		
		// Set authorID
		cacheData.setValue(self.authorID, forKeyPath: "authorID")
		
	}
	
}
