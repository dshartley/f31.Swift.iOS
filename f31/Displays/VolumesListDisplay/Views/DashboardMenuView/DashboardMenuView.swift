//
//  DashboardMenuView.swift
//  f31
//
//  Created by David on 29/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Core

/// A view class for a DashboardMenuView
public class DashboardMenuView: UIView {
	
	// MARK: - Private Stored Properties
	
	fileprivate var selectedYear:						Int = 0
	fileprivate var years								= [Int]()
	
	// MARK: - Public Stored Properties
	
	public var delegate:								ProtocolDashboardMenuViewDelegate?
	public var menuViewTopLayoutConstraintOffset:		CGFloat = 0
	
	@IBOutlet var contentView:							UIView!
	@IBOutlet weak var menuViewTopLayoutConstraint:		NSLayoutConstraint!
	@IBOutlet weak var menuViewHeightLayoutConstraint:	NSLayoutConstraint!
	@IBOutlet weak var backgroundView:					UIView!
	@IBOutlet weak var yearPickerView:					UIPickerView!
	@IBOutlet weak var menuShadowView:					UIView!
	@IBOutlet weak var elenaButtonView:					UIView!
	@IBOutlet weak var sofiaButtonView:					UIView!
	
	
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
		self.setupBackgroundView()
		self.setupYearPickerView()
		self.setupDaughterButtonViews()
		
	}
	
	public func presentMenu() {
		
		self.isHidden = false
		
		// Make sure the menu is at correct position
		self.setMenuViewHidden()
		
		self.layoutIfNeeded()
		
		UIView.animate(withDuration: 0.3, animations: {
			
			self.backgroundView.alpha					= 0.5
			self.menuShadowView.alpha					= 0.5
			self.menuViewTopLayoutConstraint.constant	= 0 + self.menuViewTopLayoutConstraintOffset
			
			self.layoutIfNeeded()
			
		}) { (completedYN) in
			
			// Not required
		}
	}
	
	public func dismissMenu() {
		
		self.layoutIfNeeded()
		
		UIView.animate(withDuration: 0.3, animations: {
			
			self.backgroundView.alpha = 0
			self.menuShadowView.alpha = 0
			
			self.setMenuViewHidden()
			
			self.layoutIfNeeded()
			
		}) { (completedYN) in
			
			self.isHidden = true
			
			// Notify the delegate
			self.delegate?.dashboardMenuView(didDismiss: self)
		}
	}
	
	public func populate(years: [Int]) {
		
		self.years = years
		
		self.yearPickerView.reloadAllComponents()
	}
	
	public func set(year: Int) {
		
		self.selectedYear = year
		
		// Determine the row of the specified year
		var row: Int = -1
		for (index, item) in self.years.enumerated() {
			
			if (item == year) { row = index }
		}
		
		// Display selected year
		if (row >= 0) {
			
			self.yearPickerView.selectRow(row, inComponent: 0, animated: false)
		}
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setupContentView() {
		
		// Load xib
		Bundle.main.loadNibNamed("DashboardMenuView", owner: self, options: nil)
		
		addSubview(contentView)
		
		// Position the contentView to fill the view
		contentView.frame				= self.bounds
		contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
		
	}
	
	fileprivate func setupBackgroundView() {
		
		// Set backgroundView alpha
		self.backgroundView.alpha = 0
		
		// Position menuView out of view
		self.setMenuViewHidden()
		
	}
	
	fileprivate func setupYearPickerView() {
	
		self.yearPickerView.delegate	= self
		self.yearPickerView.dataSource	= self
	}
	
	fileprivate func setMenuViewHidden() {
		
		self.menuViewTopLayoutConstraint.constant	= (0 + self.menuViewTopLayoutConstraintOffset) - self.menuViewHeightLayoutConstraint.constant
		
		self.menuShadowView.alpha = 0
	}
	
	fileprivate func setupDaughterButtonViews() {
		
		self.elenaButtonView.layer.cornerRadius = self.elenaButtonView.frame.size.width / 2
		self.sofiaButtonView.layer.cornerRadius = self.sofiaButtonView.frame.size.width / 2
	}
	
	
	// MARK: - elenaButton Methods
	
	@IBAction func elenaButtonTapped(_ sender: Any) {
		
		self.dismissMenu()
		
		// Notify the delegate
		self.delegate?.dashboardMenuView(sender: self, didSelectDaughter: .elena)
	}
	
	
	// MARK: - sofiaButton Methods
	
	@IBAction func sofiaButtonTapped(_ sender: Any) {
		
		self.dismissMenu()
		
		// Notify the delegate
		self.delegate?.dashboardMenuView(sender: self, didSelectDaughter: .sofia)
	}
	
	
	// MARK: - backgroundView Methods
	
	@IBAction func backgroundViewTapped(_ sender: Any) {
		
		self.dismissMenu()
	}
	
}

// MARK: - Extension UIPickerViewDelegate

extension DashboardMenuView: UIPickerViewDelegate {

}

// MARK: - Extension UIPickerViewDataSource

extension DashboardMenuView: UIPickerViewDataSource {
	
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		return self.years.count
	}
	
	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		return String(self.years[row])
	}
	
	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

		self.selectedYear = self.years[row]
		
		// Notify the delegate
		self.delegate?.dashboardMenuView(sender: self, didSelectYear: self.selectedYear)
	}
}

