//
//  ProtocolVolumesControlManagerBaseDelegate.swift
//  f31Controller
//
//  Created by David on 07/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a VolumesControlManagerBase class
public protocol ProtocolVolumesControlManagerBaseDelegate: class {
	
	// MARK: - Methods
	
	func volumesControlManagerBase(isNotConnected error: Error?)
	
	func volumesControlManagerBase(signInFailed sender: VolumesControlManagerBase)

}
