//
//  VolumeCommentsDisplayControlManager.swift
//  f31Controller
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFController
import SFNet
import SFCore
import f31Core
import f31Model
import f31View

/// Manages the VolumeCommentsDisplay control layer
public class VolumeCommentsDisplayControlManager: ControlManagerBase {

	// MARK: - Public Stored Properties
	
	public var viewManager:									VolumeCommentsDisplayViewManager?
	public fileprivate(set) var volumeCommentWrappers: 		[VolumeCommentWrapper] = [VolumeCommentWrapper]()
	public var volumeID:									Int = 0
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager, viewManager: VolumeCommentsDisplayViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager				= viewManager
		self.volumeCommentWrappers 	= [VolumeCommentWrapper]()
	}
	
	
	// MARK: - Public Methods
	
	public func loadVolumeComments(oncomplete completionHandler:@escaping ([VolumeCommentWrapper]?, Error?) -> Void) {
		
		// Check is connected
		if (self.checkIsConnected()) {
			
			// Create completion handler
			let loadVolumeCommentsFromDataSourceCompletionHandler: (([VolumeCommentWrapper]?, Error?) -> Void) =
			{
				(items, error) -> Void in
				
				if (items != nil && error == nil) {
					
					// Call completion handler
					completionHandler(items!, error)
					
				}
				
			}
			
			// Load from data source
			self.loadVolumeCommentsFromDataSource(volumeID: self.volumeID, oncomplete: loadVolumeCommentsFromDataSourceCompletionHandler)
			
		} else {
			
			// Call completion handler
			completionHandler(nil, nil)
		}
		
	}
	
	public func getVolumeCommentModelAdministrator() -> VolumeCommentModelAdministrator {
		
		return (self.modelManager! as! ModelManager).getVolumeCommentModelAdministrator!
	}
	
	public func postComment(oncomplete completionHandler:@escaping (VolumeCommentWrapper?, Error?) -> Void) {
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "SaveVolumeCommentDummyDataYN")) {
				
				self.doDummySaveVolumeComment(oncomplete: completionHandler)
				return
				
			}
			
		#endif
		
		// Create completion handler
		let saveCompletionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			var result: [VolumeCommentWrapper]? = nil
			
			if (error == nil) {
				
				// Copy items to wrappers array
				result = self.getVolumeCommentModelAdministrator().toWrappers()
				
				if (result!.count > 0) {
					
					// Prepend to the wrappers array
					self.volumeCommentWrappers.insert(result!.first!, at: 0)
					
					// Update volume wrapper
					self.updateVolumeWrapperLatestVolumeComment(volumeCommentWrapper: result!.first!)
					
				}
				
			}
			
			// Call completion handler
			completionHandler(result?.first, error)
			
		}
		
		// Check is connected
		if (self.checkIsConnected()) {
			
			// Create item
			let item: 		VolumeComment = self.createVolumeComment()
			
			// Set status to ensure item is inserted
			item.status 	= .new
			
			// Save data
			self.getVolumeCommentModelAdministrator().save(oncomplete: saveCompletionHandler)
		
		} else {
			
			// Call completion handler
			completionHandler(nil, nil)
		}
		
	}
	
	
	
	// MARK: - Private Methods
	
	fileprivate func createVolumeComment() -> VolumeComment {
		
		self.getVolumeCommentModelAdministrator().initialise()
		
		// Create new item
		let result: VolumeComment 	= self.getVolumeCommentModelAdministrator().collection!.addItem() as! VolumeComment

		result.id 					= String(0)
		result.volumeID 			= self.volumeID
		result.text 				= self.viewManager!.getComment()
		result.postedByName 		= self.viewManager!.getPostedByName()
		result.datePosted 			= Date()
		
		result.status 				= .new
		
		return result
		
	}
	
	fileprivate func doDummySaveVolumeComment(oncomplete completionHandler:@escaping (VolumeCommentWrapper?, Error?) -> Void) {
		
		// Setup dummy item
		let vcw: 			VolumeCommentWrapper = VolumeCommentWrapper()
		vcw.volumeID 		= self.volumeID
		vcw.datePosted 		= Date()
		vcw.text			= "dummycomment"
		vcw.postedByName 	= "dummyname"
		
		// Prepend to the wrappers array
		self.volumeCommentWrappers.insert(vcw, at: 0)
		
		// Update volume wrapper
		self.updateVolumeWrapperLatestVolumeComment(volumeCommentWrapper: vcw)
		
		// DEBUG:
		//let error: Error? = NSError()
		let error: 			Error? = nil
		
		// Call completion handler
		completionHandler(vcw, error)
		
	}
	
	fileprivate func loadVolumeCommentsFromDataSource(volumeID: Int, oncomplete completionHandler:@escaping ([VolumeCommentWrapper]?, Error?) -> Void) {
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var result: [VolumeCommentWrapper]? = nil
			
			if (data != nil && error == nil) {
				
				// Copy items to wrappers array
				result = self.loadedVolumeCommentsToWrappers()
			}
			
			// Set state
			self.setStateAfterLoad()
			
			// Call completion handler
			completionHandler(result, error)
		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getVolumeCommentModelAdministrator().select(byVolumeID: volumeID, oncomplete: loadCompletionHandler)
		
	}
	
	fileprivate func loadedVolumeCommentsToWrappers() -> [VolumeCommentWrapper] {
		
		var result:						[VolumeCommentWrapper]	= [VolumeCommentWrapper]()
		
		if let collection = self.getVolumeCommentModelAdministrator().collection {
			
			let collection:				VolumeCommentCollection = collection as! VolumeCommentCollection
			
			// Go through each item
			for item in collection.items! {

				// Include items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) {
					
					// Get item wrapper
					let wrapper: VolumeCommentWrapper = (item as! VolumeComment).toWrapper()
					
					result.append(wrapper)

				}
			}
		}
		
		self.volumeCommentWrappers = result
		
		return result
	}	

	fileprivate func updateVolumeWrapperLatestVolumeComment(volumeCommentWrapper: VolumeCommentWrapper) {
		
		// Find the volume wrapper
		var volumeWrapper: VolumeWrapper? = nil
		
		// Go through each item
		for item in VolumeWrappers.items {
			
			if (item.id == "\(self.volumeID)") { volumeWrapper = item }
		}
		
		guard (volumeWrapper != nil) else { return }

		// Update the volume wrapper
		volumeWrapper!.latestVolumeCommentText 			= volumeCommentWrapper.text
		volumeWrapper!.latestVolumeCommentDatePosted 	= volumeCommentWrapper.datePosted
		volumeWrapper!.latestVolumeCommentPostedByName 	= volumeCommentWrapper.postedByName
		volumeWrapper!.numberofVolumeComments 			+= 1
		
		// Clone volume from volumeWrapper
		let volume: Volume = VolumeCollection().getNewItem() as! Volume
		volume.clone(fromWrapper: volumeWrapper!)
		
		// Merge to cache
		VolumesCacheManager.shared.mergeToCache(from: volume)
		
		// Save to cache
		VolumesCacheManager.shared.saveToCache()
	}
	
}
