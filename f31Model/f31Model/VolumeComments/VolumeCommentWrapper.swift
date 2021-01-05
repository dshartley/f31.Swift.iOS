//
//  VolumeCommentWrapper.swift
//  f31Model
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Core

/// A wrapper for a VolumeComment model item
public class VolumeCommentWrapper {
	
	// MARK: - Public Stored Properties
	
	public var id:				String = ""
	public var volumeID:		Int = 0
	public var datePosted:		Date = Date()
	public var postedByName:	String = ""
	public var text:			String = ""
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	public class func find(byID id: String, wrappers: [VolumeCommentWrapper]) -> VolumeCommentWrapper? {
		
		for item in wrappers {
			
			if (item.id == id) {
				
				return item
			}
			
		}
		
		return nil
		
	}
	
	
	// MARK: - Public Methods
	
	public func dispose() {
		
	}
	
}
