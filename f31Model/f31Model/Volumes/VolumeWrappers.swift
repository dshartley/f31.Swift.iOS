//
//  VolumeWrappers.swift
//  f31Model
//
//  Created by David on 20/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// A singleton class which encapsulates an array of VolumeWrappers
public class VolumeWrappers {
	
	// MARK: - Private Stored Properties
	
	fileprivate var items:							[VolumeWrapper] = [VolumeWrapper]()
	fileprivate var hasLoadedAllPreviousItemsYN:	Bool = false
	fileprivate var hasLoadedAllNextItemsYN:		Bool = false
	
	
	// MARK: - Private Static Properties
	
	fileprivate static var singleton:				VolumeWrappers?
	
	
	// MARK: - Initializers
	
	fileprivate init() {
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var items: [VolumeWrapper] {
		get {
			
			return VolumeWrappers.getSingleton.items
		}
		set (value) {
			
			VolumeWrappers.getSingleton.items = value
		}
	}
	
	public class var hasLoadedAllPreviousItemsYN: Bool {
		get {
			
			return VolumeWrappers.getSingleton.hasLoadedAllPreviousItemsYN
		}
		set (value) {
			
			VolumeWrappers.getSingleton.hasLoadedAllPreviousItemsYN = value
		}
	}
	
	public class var hasLoadedAllNextItemsYN: Bool {
		get {
			
			return VolumeWrappers.getSingleton.hasLoadedAllNextItemsYN
		}
		set (value) {
			
			VolumeWrappers.getSingleton.hasLoadedAllNextItemsYN = value
		}
	}
	
	
	// MARK: - Private Class Computed Properties
	
	fileprivate class var getSingleton: VolumeWrappers {
		get {
			
			if (VolumeWrappers.singleton == nil) {
				VolumeWrappers.singleton = VolumeWrappers()
			}
			
			return VolumeWrappers.singleton!
		}
	}
}

