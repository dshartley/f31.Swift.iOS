//
//  VolumesListDisplayViewAccessStrategy.swift
//  f31View
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Model

/// A strategy for accessing the VolumesListDisplay view
public class VolumesListDisplayViewAccessStrategy {

	// MARK: - Private Stored Properties
	
	fileprivate weak var awardsBarView: ProtocolAwardsBarView?
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func setup(awardsBarView: ProtocolAwardsBarView) {
		
		self.awardsBarView = awardsBarView
		
	}
	
}

// MARK: - Extension ProtocolVolumesListDisplayViewAccessStrategy

extension VolumesListDisplayViewAccessStrategy: ProtocolVolumesListDisplayViewAccessStrategy {

	// MARK: - Methods
	
	public func displayAwards(items: [AwardWrapper]) {
		
		self.awardsBarView!.displayAwards(items: items)
		
	}
	
	public func clearAwards() {
		
		self.awardsBarView!.clearAwards()
		
	}
	
}
