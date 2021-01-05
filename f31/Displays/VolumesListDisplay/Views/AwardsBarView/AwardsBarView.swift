//
//  AwardsBarView.swift
//  f31
//
//  Created by David on 09/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView
import f31Core
import f31Model
import f31Controller
import f31View

/// A view class for a AwardsBarView
public class AwardsBarView: UIView, ProtocolAwardsBarView {
	
	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:									AwardsBarViewControlManager?
	fileprivate var currentAwardWrapperIndex:						Int = -1
	fileprivate var awardWrappers: 									[AwardWrapper]? = nil
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate: 										ProtocolAwardsBarViewDelegate?
	public var isShownYN: 											Bool = true
	
	@IBOutlet weak var contentView:									UIView!
	@IBOutlet weak var awardsView: 									UIView!
	@IBOutlet weak var previousButtonView: 							UIView!
	@IBOutlet weak var nextButtonView: 								UIView!
	@IBOutlet weak var awardsBarItemContainerView: 					UIView!
	@IBOutlet weak var awardsBarItemView: 							AwardsBarItemView!
	@IBOutlet weak var awardsBarItemViewWidthLayoutConstraint: 		NSLayoutConstraint!
	@IBOutlet weak var awardsBarItemViewHeightLayoutConstraint: 	NSLayoutConstraint!
	
	
	// MARK: - Initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setupContentView()
		
		self.setup()
		self.setupView()
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setupContentView()
		
		self.setup()
		self.setupView()
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Public Methods
	
	public func refreshView() {
		
		self.layoutIfNeeded()
		
		guard (self.currentAwardWrapperIndex > -1) else { return }
		
		// Populate the item view
		self.awardsBarItemView.set(item: self.awardWrappers![self.currentAwardWrapperIndex])
		
	}
	
	public func present(animateYN: Bool) {
		
		self.isShownYN = true
		
		if (animateYN) {
			
			self.doPresentAwardsViewAnimation()
			
		} else {
			
			self.awardsView.alpha = 1
			
		}
		
	}
	
	public func hide(animateYN: Bool) {
	
		self.isShownYN = false
		
		if (animateYN) {
			
			self.doHideAwardsViewAnimation()
			
		} else {
			
			self.awardsView.alpha = 0
			
		}

	}
	
	public func displayAwards(items: [AwardWrapper]) {
		
		self.clearAwards()
		
		guard (items.count > 0) else { return }
		
		self.awardWrappers 				= items
		self.currentAwardWrapperIndex 	= 0
		
		// Display current award
		self.displayAward()
		
		// If more than 1 item then show the buttons
		var visibleYN: 					Bool = false
		if (items.count > 1) { visibleYN = true }
		
		self.setButtons(visibleYN: visibleYN)
		
	}
	
	public func clearAwards() {
		
		self.awardWrappers 				= nil
		self.currentAwardWrapperIndex 	= -1
		
		// Hide award bar item
		self.awardsBarItemView.alpha 	= 0
		
		// Clear item view
		self.awardsBarItemView.clear()
		
		self.setButtons(visibleYN: false)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager 			= AwardsBarViewControlManager()
		
		self.controlManager!.delegate 	= self
		
	}
	
	fileprivate func setupModelManager() {
		
		// Set the model manager
		self.controlManager!.set(modelManager: ModelFactory.modelManager)
		
		// Setup the model administrators
		//ModelFactory.setupUserProfileModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
	}
	
	fileprivate func setupViewManager() {
		
		// Create view strategy
		let viewAccessStrategy: AwardsBarViewViewAccessStrategy = AwardsBarViewViewAccessStrategy()

		viewAccessStrategy.setup()

		// Setup the view manager
		self.controlManager!.viewManager = AwardsBarViewViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setupContentView() {
		
		// Load xib
		Bundle.main.loadNibNamed("AwardsBarView", owner: self, options: nil)
		
		addSubview(contentView)
		
		self.layoutIfNeeded()
		
		// Position the contentView to fill the view
		contentView.frame				= self.bounds
		contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
	}
	
	fileprivate func setupView() {

		self.setupAwardsView()
		self.setupAwardsBarItemView()
	}

	fileprivate func setupAwardsView() {
	
		self.awardsView.layer.cornerRadius = 10
		
	}
	
	fileprivate func setupAwardsBarItemView() {
		
		self.awardsBarItemView.delegate = self

		self.awardsBarItemView.alpha 	= 0
		
	}
	
	fileprivate func doPresentAwardsViewAnimation() {
		
		self.awardsView.alpha 		= 0
		self.awardsView.transform 	= CGAffineTransform(scaleX: 0.001, y: 0.001)
		self.awardsView.alpha 		= 1
		
		UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
			
			self.awardsView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
			
		}) { _ in
			
			self.awardsView.transform = CGAffineTransform.identity
			
		}
		
	}
	
	fileprivate func doHideAwardsViewAnimation() {
		
		UIView.animate(withDuration: 0.1) {
			
			self.awardsView.alpha 	= 0
			
		}
		
	}
	
	fileprivate func setButtons(visibleYN: Bool) {
		
		self.previousButtonView.isHidden 	= !visibleYN
		self.nextButtonView.isHidden 		= !visibleYN
		
	}

	fileprivate func displayAward() {
		
		// Populate the item view
		self.awardsBarItemView.set(item: self.awardWrappers![self.currentAwardWrapperIndex])
		
		// Present the item view
		self.presentAwardBarItemView()
		
	}
	
	fileprivate func presentAwardBarItemView() {
		
		UIView.animate(withDuration: 0.3, animations: {
			
			self.awardsBarItemView.alpha = 1
			
		})
		
	}
	
	fileprivate func hideAwardBarItemView(oncomplete completionHandler:((Error?) -> Void)?) {
		
		UIView.animate(withDuration: 0.3, animations: {
			
			self.awardsBarItemView.alpha = 0
			
		}) { (completedYN) in
			
			// Call completion handler
			completionHandler?(nil)

		}
		
	}
	
	fileprivate func showPreviousAward() {
		
		guard (self.awardWrappers != nil && self.awardWrappers!.count > 1) else { return }
		
		// Create completion handler
		let completionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			// Clear the item view
			self.awardsBarItemView.clear()
			
			// Display current award
			self.displayAward()
			
		}
		
		// Set the currentAwardWrapperIndex to previous item
		if (self.currentAwardWrapperIndex <= 0) {
			
			self.currentAwardWrapperIndex = self.awardWrappers!.count - 1
			
		} else {
			
			self.currentAwardWrapperIndex -= 1
			
		}
		
		// Hide the item view
		self.hideAwardBarItemView(oncomplete: completionHandler)
		
	}
	
	fileprivate func showNextAward() {
	
		guard (self.awardWrappers != nil && self.awardWrappers!.count > 1) else { return }
		
		// Create completion handler
		let completionHandler: ((Error?) -> Void) =
		{
			[unowned self] (error) -> Void in
			
			// Clear the item view
			self.awardsBarItemView.clear()
			
			// Display current award
			self.displayAward()
			
		}
		
		// Set the currentAwardWrapperIndex to next item
		if (self.currentAwardWrapperIndex >= self.awardWrappers!.count - 1) {
			
			self.currentAwardWrapperIndex = 0
			
		} else {
			
			self.currentAwardWrapperIndex += 1
			
		}
		
		// Hide the item view
		self.hideAwardBarItemView(oncomplete: completionHandler)
		
	}
	
	
	// MARK: - previousButtonView TapGestureRecognizer Methods
	
	@IBAction func previousButtonViewTapped(_ sender: Any) {
		
		self.showPreviousAward()

	}
	
	
	// MARK: - nextButtonView TapGestureRecognizer Methods
	
	@IBAction func nextButtonViewTapped(_ sender: Any) {
		
		self.showNextAward()
		
	}
	
}

// MARK: - Extension ProtocolAwardsBarViewControlManagerDelegate

extension AwardsBarView: ProtocolAwardsBarViewControlManagerDelegate {

	// MARK: - Public Methods

}

// MARK: - Extension ProtocolAwardsBarItemViewDelegate

extension AwardsBarView: ProtocolAwardsBarItemViewDelegate {
	
	// MARK: - Public Methods
	
	public func awardsBarItemView(didTap item: AwardWrapper) {
		
		// TODO:
	}
	
	public func awardsBarItemView(didSetContentSize sender: AwardsBarItemView, size: CGSize) {
		
		// Set item view layout constraints
		self.awardsBarItemViewWidthLayoutConstraint.constant 	= size.width
		self.awardsBarItemViewHeightLayoutConstraint.constant 	= size.height
		
		// Notify the delegate
		self.delegate?.awardsBarView(didSetContentSize: self, size: size)
		
	}
	
	public func awardsBarItemView(maximumContentSize sender: AwardsBarItemView) -> CGSize {
		
		return self.awardsBarItemContainerView.frame.size
		
	}
	
}



