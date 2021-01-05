//
//  VolumeWrapper.swift
//  f31Model
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Core

/// A wrapper for a Volume model item
public class VolumeWrapper {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var id:									String = ""
	public var authorID:							Int = 1
	public var title:								String = ""
	public var datePublished:						Date = Date()
	public var coverThumbnailImageFileName:			String = ""
	public var coverThumbnailImageData:				Data? = nil
	public var coverColor:							String = ""
	public var numberofPages:						Int = 0
	public var numberofLikes:						Int = 0
	public var numberofVolumeComments:				Int = 0
	public var latestVolumeCommentDatePosted:		Date = Date()
	public var latestVolumeCommentPostedByName:		String = ""
	public var latestVolumeCommentText:				String = ""
	public var itemCoverViewHeight: 				CGFloat = 0
	public var itemLatestVolumeCommentViewHeight: 	CGFloat = 0
	public fileprivate(set) var contentData:		String = ""
	public fileprivate(set) var volumeContentData:	VolumeContentDataWrapper? = nil

	
	// MARK: - Initializers
	
	public init() {
		
	}
	

	// MARK: - Public Methods
	
	public func dispose() {
		
		self.volumeContentData 	= nil

	}
	
	public func set(contentData: String) {
		
		self.contentData 					= contentData
		
		if (contentData.count > 0) {
			
			// Create VolumeContentDataWrapper
			self.volumeContentData 			= VolumeContentDataWrapper(volumeID: self.id, contentData: contentData)
			
		} else {
			
			self.volumeContentData 			= nil
			
		}
		
	}
	
	public func get(assetsByGroupKey groupKey: String, type: VolumeAssetTypes) -> [VolumeAssetWrapper] {
		
		var result: [VolumeAssetWrapper] = [VolumeAssetWrapper]()

		guard (self.volumeContentData?.assets != nil) else {
			
			return result
			
		}
		
		let groupKey = groupKey.lowercased()
		
		// Go through each item
		for asset in self.volumeContentData!.assets!.values {
			
			if (asset.groupKey.lowercased() == groupKey && asset.assetType == type) {
				
				result.append(asset)
				
			}
		}
		
		return result
		
	}
	
}
