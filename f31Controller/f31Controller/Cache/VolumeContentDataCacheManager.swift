//
//  VolumeContentDataCacheManager.swift
//  f31Controller
//
//  Created by David on 09/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import CoreData
import SFController
import f31Core
import f31Model

/// Manages cacheing for VolumeContentData model data
public class VolumeContentDataCacheManager: CacheManagerBase {

	// MARK: - Private Static Properties
	
	fileprivate static var singleton:		VolumeContentDataCacheManager?
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var volumeID:	Int = 0
	
	
	// MARK: - Initializers
	
	fileprivate override init() {
		super.init()
		
		self.entityName = "VolumeContentData"
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var shared: VolumeContentDataCacheManager {
		get {
			
			if (VolumeContentDataCacheManager.singleton == nil) {
				VolumeContentDataCacheManager.singleton = VolumeContentDataCacheManager()
			}
			
			return VolumeContentDataCacheManager.singleton!
		}
	}
	
	
	// MARK: - Public Methods
	
	public func set(volumeID: Int) {
		
		self.volumeID 	= volumeID
		
		// Set predicate
		self.predicate = NSPredicate(format: "volumeID == %@", argumentArray: [volumeID])
		
	}
	
	
	// MARK: - Override Methods
	
	public override func setAttributes(cacheData: NSManagedObject) {
		
		// Set volumeID
		cacheData.setValue(self.volumeID, forKeyPath: "volumeID")
		
	}
	
}
