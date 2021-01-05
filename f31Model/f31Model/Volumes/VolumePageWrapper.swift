//
//  VolumePageWrapper.swift
//  f31Model
//
//  Created by David on 25/10/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a VolumePage model item
public class VolumePageWrapper {

	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var pageNumber:					Int = 0
	public var volumeID:					String = ""
	public fileprivate(set) var assets: 	[String: VolumeAssetWrapper]? = [String: VolumeAssetWrapper]()
	public var allAssetsLoadedYN:			Bool = false
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func dispose() {
	}
	
	public func set(asset key: String, wrapper: VolumeAssetWrapper) {
		
		self.assets![key] = wrapper
		
	}
	
}
