//
//  ProtocolDashboardBarViewDelegate.swift
//  f31
//
//  Created by David on 30/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import f31Core

/// Defines a delegate for a DashboardBarView class
public protocol ProtocolDashboardBarViewDelegate {
	
	// MARK: - Methods
	
	func dashboardBarView(sender: DashboardBarView, daughterChanged daughter: Daughters)
	
	func dashboardBarView(sender: DashboardBarView, yearChanged year: Int)
	
	func dashboardBarView(sender: DashboardBarView, daughterButtonTapped daughter: Daughters)
	
	func dashboardBarView(sender: DashboardBarView, yearButtonTapped year: Int)
	
	func dashboardBarView(sender: DashboardBarView, newsBarButtonTapped newsBarIsSelectedYN: Bool)
	
}
