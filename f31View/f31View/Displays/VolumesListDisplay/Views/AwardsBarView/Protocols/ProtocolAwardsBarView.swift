//
//  ProtocolAwardsBarView.swift
//  f31View
//
//  Created by David on 10/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Model

/// Defines a class which is a AwardsBarView
public protocol ProtocolAwardsBarView: class {
	
	// MARK: - Stored Properties
	
	// MARK: - Methods
	
	func displayAwards(items: [AwardWrapper])
	
	func clearAwards()
	
}
