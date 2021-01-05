//
//  VolumeCommentsDisplayViewManager.swift
//  f31View
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView
import f31Core

/// Manages the GalleryItemDisplay view layer
public class VolumeCommentsDisplayViewManager: ViewManagerBase {

	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: ProtocolVolumeCommentsDisplayViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolVolumeCommentsDisplayViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func getPostedByName() -> String {
		
		return self.viewAccessStrategy!.getPostedByName()
	}
	
	public func getComment() -> String {
		
		return self.viewAccessStrategy!.getComment()
	}
	
}
