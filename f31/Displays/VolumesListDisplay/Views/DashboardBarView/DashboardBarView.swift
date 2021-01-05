//
//  DashboardBarView.swift
//  f31
//
//  Created by David on 30/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Core

/// A view class for a DashboardBarView
public class DashboardBarView: UIView {

	// MARK: - Private Stored Properties
	
	fileprivate var selectedDaughter:				Daughters = .elena
	fileprivate var selectedYear:					Int = 0
	fileprivate var newsBarIsSelectedYN:			Bool = false
	
	
	// MARK: - Public Stored Properties
	
	public var delegate:							ProtocolDashboardBarViewDelegate?
	
	@IBOutlet var contentView:						UIView!
	@IBOutlet weak var newsBarButtonView: 			UIImageView!
	@IBOutlet weak var daughterLabel:				UILabel!
	@IBOutlet weak var yearLabel:					UILabel!
	@IBOutlet weak var daughterButtonInitialLabel:	UILabel!
	@IBOutlet weak var daughterButtonView:			UIView!
	
	
	// MARK: - Initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setup()
	}
	
	
	// MARK: - Public Methods
	
	public func setup() {

		self.setupContentView()
		self.setupDaughterButtonView()
		self.setupNewsBarButtonView()
	}

	public func set(daughter: Daughters) {
		
		self.selectedDaughter = daughter
	
		// Get daughter initial
		let daughterString						= "\(daughter)"
		let index								= daughterString.index(daughterString.startIndex, offsetBy: 1)
		let daughterInitial						= String(daughterString[..<index]).lowercased()
		
		// Display selected daughter
		self.daughterButtonInitialLabel.text	= daughterInitial
		self.daughterLabel.text					= daughterString.capitalized
		
		// Notify the delegate
		self.delegate?.dashboardBarView(sender: self, daughterChanged: self.selectedDaughter)
		
	}
	
	public func set(year: Int) {
		
		self.selectedYear = year
		
		// Display selected year
		self.yearLabel.text = String(year)
	
		// Notify the delegate
		self.delegate?.dashboardBarView(sender: self, yearChanged: self.selectedYear)
	}

	public func set(newsBarIsSelectedYN: Bool, animateYN: Bool) {
		
		self.newsBarIsSelectedYN = newsBarIsSelectedYN
		
		// Set button
		
		if (animateYN) {
			
			self.doNewsBarButtonIsSelectedYNAnimation()
			
		} else {
			
			if (self.newsBarIsSelectedYN) {
				
				self.newsBarButtonView.alpha = 1
				
			} else {
				
				self.newsBarButtonView.alpha = 0.5
				
			}
			
		}
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setupContentView() {
		
		// Load xib
		Bundle.main.loadNibNamed("DashboardBarView", owner: self, options: nil)
		
		addSubview(contentView)
		
		// Position the contentView to fill the view
		contentView.frame				= self.bounds
		contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
		
	}
	
	fileprivate func setupDaughterButtonView() {
		
		self.daughterButtonView.layer.cornerRadius = self.daughterButtonView.frame.size.width / 2
	}

	fileprivate func setupNewsBarButtonView() {
		
		self.newsBarButtonView.alpha = 0.5

	}
	
	fileprivate func doNewsBarButtonIsSelectedYNAnimation() {
		
		UIView.animate(withDuration: 0.3, animations: {
			
			if (self.newsBarIsSelectedYN) {
				
				self.newsBarButtonView.alpha = 1
				
			} else {
				
				self.newsBarButtonView.alpha = 0.5
				
			}

		}) { (completedYN) in
			
			// Not required
		}
		
	}

	
	// MARK: - daughterButton Methods TapGestureRecognizer Methods
	
	@IBAction func daughterButtonTapped(_ sender: Any) {
		
		// Notify the delegate
		self.delegate?.dashboardBarView(sender: self, daughterButtonTapped: self.selectedDaughter)
	}

	
	// MARK: - daughterLabel TapGestureRecognizer Methods
	
	@IBAction func daughterLabelTapped(_ sender: Any) {
		
		// Notify the delegate
		self.delegate?.dashboardBarView(sender: self, daughterButtonTapped: self.selectedDaughter)
	}
	
	
	// MARK: - yearLabel TapGestureRecognizer Methods
	
	@IBAction func yearLabelTapped(_ sender: Any) {
		
		// Notify the delegate
		self.delegate?.dashboardBarView(sender: self, yearButtonTapped: self.selectedYear)
	}
	
	
	// MARK: - newsBarButton Methods TapGestureRecognizer Methods
	
	@IBAction func newsBarButtonTapped(_ sender: Any) {
		
		self.newsBarIsSelectedYN = !self.newsBarIsSelectedYN
		
		self.doNewsBarButtonIsSelectedYNAnimation()
		
		// Notify the delegate
		self.delegate?.dashboardBarView(sender: self, newsBarButtonTapped: self.newsBarIsSelectedYN)
	}
	
}
