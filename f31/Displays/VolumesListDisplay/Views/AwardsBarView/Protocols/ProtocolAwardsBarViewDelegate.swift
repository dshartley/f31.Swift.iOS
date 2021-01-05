//
//  ProtocolAwardsBarViewDelegate.swift
//  f31
//
//  Created by David on 09/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a AwardsBarView class
public protocol ProtocolAwardsBarViewDelegate: class {
	
	// MARK: - Methods
	
	func awardsBarView(didSetContentSize sender: AwardsBarView, size: CGSize)
	
}
