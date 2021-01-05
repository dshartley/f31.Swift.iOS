//
//  AwardWrappers.swift
//  f31Model
//
//  Created by David on 09/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// A singleton class which encapsulates an array of AwardWrappers
public class AwardWrappers {
	
	// MARK: - Private Stored Properties
	
	fileprivate var items:						[AwardWrapper] = [AwardWrapper]()

	
	// MARK: - Private Static Properties
	
	fileprivate static var singleton:			AwardWrappers?
	
	
	// MARK: - Initializers
	
	fileprivate init() {
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var items: [AwardWrapper] {
		get {
			
			return AwardWrappers.getSingleton.items
		}
		set (value) {
			
			AwardWrappers.getSingleton.items = value
		}
	}
	
	
	// MARK: - Private Class Computed Properties
	
	fileprivate class var getSingleton: AwardWrappers {
		get {
			
			if (AwardWrappers.singleton == nil) {
				AwardWrappers.singleton = AwardWrappers()
			}
			
			return AwardWrappers.singleton!
		}
	}
}
