//
//  VolumeAssetWrapper.swift
//  f31Model
//
//  Created by David on 25/10/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Core

/// A wrapper for a VolumeAsset model item
public class VolumeAssetWrapper {

	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var id:								String = ""
	public var volumeID:						String = ""
	public var assetType:						VolumeAssetTypes = .Image
	public var groupKey:						String = ""
	public fileprivate(set) var attributes:		[String: Any]? = [String: Any]()
	public var isLoadedYN:						Bool = false
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func dispose() {
		
		self.attributes = nil
		
	}
	
	public func set(attribute key: String, value: Any) {
		
		self.attributes![key] = value
		
	}

	public func get(attribute key: String) -> Any? {
		
		return self.attributes![key]
		
	}

	public func remove(attribute key: String) {
		
		self.attributes!.removeValue(forKey: key)
		
	}
	
	public func getGroupKeyPrefix() -> String {
		
		var result: 			String = ""
		
		guard (self.groupKey.count > 0) else { return result }
		
		// Get separatorIndex
		let separatorIndex:		String.Index = self.groupKey.index(of: "_")!
		
		result 					= "\(self.groupKey[..<separatorIndex])"
		
		return result
		
	}
	
	public func getPageNumber() -> Int {
		
		var result: 			Int = 0
		
		guard (self.groupKey.count > 0) else { return result }
		
		// Get separatorIndex
		let separatorIndex:		String.Index = self.groupKey.index(of: "_")!
		let nextIndex:			String.Index = self.groupKey.index(separatorIndex, offsetBy: 1)
		
		let pageNumberString: 	String = "\(self.groupKey[nextIndex...])"
		result 					= Int(pageNumberString) ?? 0
		
		return result

		
	}
	
}
