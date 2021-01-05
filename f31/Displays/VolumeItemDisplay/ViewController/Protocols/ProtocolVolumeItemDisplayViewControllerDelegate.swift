//
//  ProtocolVolumeItemDisplayViewControllerDelegate.swift
//  f31
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a VolumeItemDisplayViewController class
public protocol ProtocolVolumeItemDisplayViewControllerDelegate: class {
	
	// MARK: - Methods
	
	func volumeItemDisplayViewController(didDismiss sender: VolumeItemDisplayViewController)
	
}
