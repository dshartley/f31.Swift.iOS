//
//  ProtocolVolumeItemDisplayViewAccessStrategy.swift
//  f31View
//
//  Created by David on 19/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import f31Model

/// Defines a class which provides a strategy for accessing the VolumeItemDisplay view
public protocol ProtocolVolumeItemDisplayViewAccessStrategy {
	
	// MARK: - Methods
	
	/// Display volume
	///
	func display(volume: VolumeWrapper)
	
	func displayNumberofLikes(numberofLikes: Int)
	
	func clearLatestVolumeComment()
	
	func displayLatestVolumeComment(text: String, postedByName: String, datePosted: Date)
	
}
