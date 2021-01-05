//
//  ProtocolAwardsBarItemViewDelegate.swift
//  f31
//
//  Created by David on 10/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Model

/// Defines a delegate for a AwardsBarItemView class
public protocol ProtocolAwardsBarItemViewDelegate: class {
	
	// MARK: - Methods
	
	func awardsBarItemView(didTap item: AwardWrapper)
	
	func awardsBarItemView(didSetContentSize sender: AwardsBarItemView, size: CGSize)
	
	func awardsBarItemView(maximumContentSize sender: AwardsBarItemView) -> CGSize
	
}
