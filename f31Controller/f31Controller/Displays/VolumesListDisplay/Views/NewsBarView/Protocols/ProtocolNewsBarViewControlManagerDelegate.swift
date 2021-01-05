//
//  ProtocolNewsBarViewControlManagerDelegate.swift
//  f31Controller
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a NewsBarViewControlManager class
public protocol ProtocolNewsBarViewControlManagerDelegate: class {
	
	// MARK: - Methods
	
	func templateViewControlManager(isNotConnected error: Error?)
	
}
