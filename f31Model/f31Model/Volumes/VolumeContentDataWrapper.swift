//
//  VolumeContentDataWrapper.swift
//  f31Model
//
//  Created by David on 26/10/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFSerialization
import f31Core

/// A wrapper for a VolumeContentData model item
public class VolumeContentDataWrapper {
	
	// MARK: - Private Stored Properties
	
	fileprivate var wrapper: 				DataJSONWrapper?
	fileprivate var imageData:				[String: Data]? = [String: Data]()
	
	
	// MARK: - Public Stored Properties
	
	public var id:							String = ""
	public var volumeID:					String = ""
	public fileprivate(set) var pages:		[Int: VolumePageWrapper]? = [Int: VolumePageWrapper]()
	public fileprivate(set) var assets:		[String: VolumeAssetWrapper]? = [String: VolumeAssetWrapper]()
	
	
	// MARK: - Initializers
	
	fileprivate init() {
		
	}
	
	public init(volumeID: String, contentData: String) {
		
		self.volumeID = volumeID
		
		self.set(contentData: contentData)
		
	}
	
	
	// MARK: - Public Methods
	
	
	// MARK: - Private Methods
	
	fileprivate func set(contentData: String) {
		
		guard (contentData.count > 0) else { return }
		
		// Get DataJSONWrapper from contentData
		self.wrapper = JSONHelper.DeserializeDataJSONWrapper(dataString: contentData)
		
		guard (self.wrapper != nil) else { return }
		
		// Deserialize pages
		self.doDeserializePages()
		
		// Deserialize assets
		self.doDeserializeAssets()
		
	}
	
	fileprivate func doDeserializePages() {
		
		self.pages = [Int: VolumePageWrapper]()
		
		guard (self.wrapper != nil) else { return }
		
		// Get pagesWrapper
		let pagesWrapper: DataJSONWrapper? = self.wrapper!.getItem(id: "\(VolumeContentKeys.Pages)")
		
		guard (pagesWrapper != nil) else { return }
		
		// Go through each item
		for p in pagesWrapper!.Items {
			
			// Create pageWrapper
			let pageWrapper: VolumePageWrapper = VolumePageWrapper()
			
			pageWrapper.volumeID 	= self.volumeID
			pageWrapper.pageNumber 	= Int(p.ID) ?? 0
			
			// Add to pages
			self.pages![pageWrapper.pageNumber] = pageWrapper
			
		}
		
	}

	fileprivate func doDeserializeAssets() {
		
		self.assets = [String: VolumeAssetWrapper]()
		
		guard (self.wrapper != nil) else { return }
		
		// Get assetsWrapper
		let assetsWrapper: DataJSONWrapper? = self.wrapper!.getItem(id: "\(VolumeContentKeys.Assets)")
		
		guard (assetsWrapper != nil) else { return }
		
		// Go through each item
		for a in assetsWrapper!.Items {
			
			// Create assetWrapper
			let assetWrapper: VolumeAssetWrapper = VolumeAssetWrapper()
			
			assetWrapper.id 		= a.ID
			assetWrapper.volumeID 	= self.volumeID
			assetWrapper.assetType 	= VolumeAssetTypes(rawValue: Int(a.getParameterValue(key: "\(VolumeDataParameterKeys.AssetType)")!)!)!
			assetWrapper.groupKey 	= a.getParameterValue(key: "\(VolumeDataParameterKeys.GroupKey)") ?? ""
			
			// Go through each parameter
			for p in a.Params {
			
				// Set attribute
				assetWrapper.set(attribute: p.Key, value: p.Value)
				
			}
			
			// Remove attributes which are stored as properties
			assetWrapper.remove(attribute: "\(VolumeDataParameterKeys.AssetType)")
			assetWrapper.remove(attribute: "\(VolumeDataParameterKeys.GroupKey)")
			
			// Add to assets
			self.assets![assetWrapper.id] = assetWrapper
			
			// Get groupKeyPrefix
			let groupKeyPrefix: 	String = assetWrapper.getGroupKeyPrefix()
			
			// Check groupKeyPrefix
			if (groupKeyPrefix.lowercased() == "\(VolumeGroupKeyPrefixes.page)") {
				
				let pageNumber:		Int = assetWrapper.getPageNumber()
				
				if (pageNumber > 0) {
					
					// Get pageWrapper
					let pageWrapper: VolumePageWrapper? = self.pages![pageNumber]
					
					// Set in pageWrapper
					pageWrapper?.set(asset: assetWrapper.id, wrapper: assetWrapper)
					
				}
				
			}

		}
		
	}
	
}
