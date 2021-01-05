//
//  ProtocolVolumeCommentsDisplayViewControllerDelegate.swift
//  f31
//
//  Created by David on 27/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a VolumeCommentsDisplayViewControllerDelegate class
public protocol ProtocolVolumeCommentsDisplayViewControllerDelegate {
	
	// MARK: - Methods
	
	func volumeCommentsDisplayViewController(didDismiss sender: VolumeCommentsDisplayViewController)
	
	func volumeCommentsDisplayViewController(didPostComment sender: VolumeCommentsDisplayViewController)
	
}
