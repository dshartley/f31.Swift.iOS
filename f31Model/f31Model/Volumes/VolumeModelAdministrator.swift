//
//  VolumeModelAdministrator.swift
//  f30Model
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages Volume data
public class VolumeModelAdministrator: ModelAdministratorBase {
	
	// MARK: - Public Stored Properties
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(modelAccessStrategy:			ProtocolModelAccessStrategy,
						 modelAdministratorProvider:	ProtocolModelAdministratorProvider,
						 storageDateFormatter:			DateFormatter) {
		super.init(modelAccessStrategy: modelAccessStrategy,
				   modelAdministratorProvider: modelAdministratorProvider,
				   storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods
		
	public func select(byPreviousVolumeID id: Int, authorID: Int, year: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {

		self.setupCollection()

		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in

			if (error != nil) {
				
				self.doAfterLoad()
				
			}
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}

		// Load the data
		(self.modelAccessStrategy as! ProtocolVolumeModelAccessStrategy).select(byPreviousVolumeID: id, authorID: authorID, year: year, numberofItemsToLoad: numberofItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, collection: self.collection!, oncomplete: selectCompletionHandler)
		
	}
	
	public func getContentData(forVolume volumeID: String, oncomplete completionHandler:@escaping (String?, Error?) -> Void) {
		
		(self.modelAccessStrategy as! ProtocolVolumeModelAccessStrategy).getContentData(forVolume: volumeID, oncomplete: completionHandler)
		
	}
	
	public func addLike(id: Int) {
		
		(self.modelAccessStrategy as! ProtocolVolumeModelAccessStrategy).addLike(id: id)
		
	}
	
	public func toWrappers() -> [VolumeWrapper] {
		
		var result:             [VolumeWrapper] = [VolumeWrapper]()
		
		if let collection = self.collection {
			
			let collection:     VolumeCollection = collection as! VolumeCollection
			
			// Go through each item
			for item in collection.items! {
				
				// Include items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) {
					
					// Get item wrapper
					let wrapper: VolumeWrapper = (item as! Volume).toWrapper()
					
					result.append(wrapper)
					
				}
				
			}
			
		}
		
		return result
	}
	
	
	// MARK: - Override Methods
	
	public override func newCollection() -> ProtocolModelItemCollection? {
		
		return VolumeCollection(modelAdministrator: self,
									   storageDateFormatter: self.storageDateFormatter!)
	}
	
	public override func setupForeignKeys() {
		
		// No foreign keys
	}
	
	public override func setupOmittedKeys() {
		
		// Not omitted keys
	}
	
	
	// MARK: - Private Methods
	
}
