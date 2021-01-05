//
//  AwardsCacheManager.swift
//  f31Controller
//
//  Created by David on 09/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import CoreData
import SFController
import f31Core
import f31Model

/// Manages cacheing for Awards model data
public class AwardsCacheManager: CacheManagerBase {

	// MARK: - Private Static Properties
	
	fileprivate static var singleton:		AwardsCacheManager?
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var year:		Int = 0
	public fileprivate(set) var authorID:	Int = 0
	
	
	// MARK: - Initializers
	
	fileprivate override init() {
		super.init()
		
		self.entityName = "Awards"
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var shared: AwardsCacheManager {
		get {
			
			if (AwardsCacheManager.singleton == nil) {
				AwardsCacheManager.singleton = AwardsCacheManager()
			}
			
			return AwardsCacheManager.singleton!
		}
	}
	
	
	// MARK: - Public Methods
	
	public func set(year: Int, authorID: Int) {
		
		self.year 		= year
		self.authorID 	= authorID
		
		// Set predicate
		self.predicate = NSPredicate(format: "year == %@ AND authorID == %@", argumentArray: [year, authorID])
		
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseCacheData() {
		
		self.collection	= AwardCollection()
		
	}
	
	public override func setAttributes(cacheData: NSManagedObject) {
		
		// Set year
		cacheData.setValue(self.year, forKeyPath: "year")
		
		// Set authorID
		cacheData.setValue(self.authorID, forKeyPath: "authorID")
		
	}
	
}
