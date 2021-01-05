//
//  ProtocolVolumesListDisplayViewAccessStrategy.swift
//  f31View
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import f31Core
import f31Model

/// Defines a class which provides a strategy for accessing the VolumesListDisplay view
public protocol ProtocolVolumesListDisplayViewAccessStrategy {

	// MARK: - Methods
	
	func displayAwards(items: [AwardWrapper])
	
	func clearAwards()
	
}
