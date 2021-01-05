//
//  ProtocolVolumeCommentsDisplayViewAccessStrategy.swift
//  f31View
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import f31Core

/// Defines a class which provides a strategy for accessing the VolumeCommentsDisplay view
public protocol ProtocolVolumeCommentsDisplayViewAccessStrategy {
	
	// MARK: - Methods
	
	func getPostedByName() -> String
	
	func getComment() -> String
}
