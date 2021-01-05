//
//  VolumesListDisplayViewManager.swift
//  f31View
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView
import f31Model

/// Manages the VolumesListDisplay view layer
public class VolumesListDisplayViewManager: ViewManagerBase {

	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: ProtocolVolumesListDisplayViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolVolumesListDisplayViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func displayAwards(items: [AwardWrapper]) {
		
		self.viewAccessStrategy!.displayAwards(items: items)
		
	}
	
	public func clearAwards() {
		
		self.viewAccessStrategy!.clearAwards()
		
	}
	
}
