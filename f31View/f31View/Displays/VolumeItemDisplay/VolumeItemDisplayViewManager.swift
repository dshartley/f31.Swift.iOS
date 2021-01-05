//
//  VolumeItemDisplayViewManager.swift
//  f31View
//
//  Created by David on 19/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView
import f31Model

/// Manages the VolumeItemDisplay view layer
public class VolumeItemDisplayViewManager: ViewManagerBase {
	
	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: ProtocolVolumeItemDisplayViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolVolumeItemDisplayViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func display(volume: VolumeWrapper) {
		
		self.viewAccessStrategy!.display(volume: volume)
	}
	
	public func displayNumberofLikes(numberofLikes: Int) {
		
		self.viewAccessStrategy!.displayNumberofLikes(numberofLikes: numberofLikes)
	}
	
	public func clearLatestVolumeComment() {
	
		self.viewAccessStrategy!.clearLatestVolumeComment()
	}
	
	public func displayLatestVolumeComment(text: String, postedByName: String, datePosted: Date) {
		
		self.viewAccessStrategy!.displayLatestVolumeComment(text: text, postedByName: postedByName, datePosted: datePosted)
	}
	
}
