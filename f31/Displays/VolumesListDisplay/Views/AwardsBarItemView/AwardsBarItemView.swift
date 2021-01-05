//
//  AwardsBarItemView.swift
//  f31
//
//  Created by David on 10/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView
import f31Core
import f31Model

/// A view class for a AwardsBarItemView
public class AwardsBarItemView: UIView {
	
	// MARK: - Private Stored Properties
	
	fileprivate var item: 											AwardWrapper? = nil
	fileprivate var maxTextLabelSize:								CGSize = CGSize(width: 100, height: 50)
	fileprivate let maxTextLabelNumberofLines:						Int = 2
	fileprivate var maxCompetitionNameLabelSize:					CGSize = CGSize(width: 100, height: 50)
	fileprivate let maxCompetitionNameLabelNumberofLines:			Int = 2
	fileprivate var maxImageViewSize:								CGSize = CGSize(width: 100, height: 100)
	fileprivate var maxQuoteLabelSize:								CGSize = CGSize(width: 100, height: 50)
	fileprivate let maxQuoteLabelNumberofLines:						Int = 8
	fileprivate var contentSize:									CGSize = CGSize(width: 0, height: 0)
	fileprivate var maximumContentSize:								CGSize? = nil
	fileprivate let labelsStackViewLeadingSpacing: 					CGFloat = 10
	fileprivate let labelsStackViewSpacing: 						CGFloat = 5
	fileprivate let competitionNameLabelTopSpacing:					CGFloat = 5
	fileprivate let imageViewTopSpacing:							CGFloat = 5
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate: 										ProtocolAwardsBarItemViewDelegate?

	@IBOutlet weak var contentView:									UIView!
	@IBOutlet weak var textLabel: 									UILabel!
	@IBOutlet weak var textLabelWidthLayoutConstraint: 				NSLayoutConstraint!
	@IBOutlet weak var textLabelHeightLayoutConstraint: 			NSLayoutConstraint!
	@IBOutlet weak var competitionNameLabel: 						UILabel!
	@IBOutlet weak var competitionNameLabelWidthLayoutConstraint: 	NSLayoutConstraint!
	@IBOutlet weak var competitionNameLabelHeightLayoutConstraint: 	NSLayoutConstraint!
	@IBOutlet weak var imageView: 									UIImageView!
	@IBOutlet weak var imageViewWidthLayoutConstraint: 				NSLayoutConstraint!
	@IBOutlet weak var imageViewHeightLayoutConstraint: 			NSLayoutConstraint!
	@IBOutlet weak var quoteLabel: 									UILabel!
	@IBOutlet weak var quoteLabelWidthLayoutConstraint: 			NSLayoutConstraint!
	@IBOutlet weak var quoteLabelHeightLayoutConstraint: 			NSLayoutConstraint!
	@IBOutlet weak var labelsStackViewLeadingLayoutConstraint: 		NSLayoutConstraint!
	
	
	// MARK: - Initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setupContentView()
		
		self.setupView()
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setupContentView()

		self.setupView()
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Public Methods
	
	public func set(item: AwardWrapper?) {
		
		self.item = item
		
		// Get maximumContentSize
		if (item != nil) {
			
			self.getMaximumContentSize()
			
		}
		
		self.displayText()
		self.displayCompetitionName()
		self.displayImage()
		self.displayQuote()
		
		// Set contentSize
		if (item != nil) {
			
			self.setContentSize()
			
		}
		
	}
	
	public func clear() {
		
		self.set(item: nil)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setupContentView() {
		
		// Load xib
		Bundle.main.loadNibNamed("AwardsBarItemView", owner: self, options: nil)
		
		addSubview(contentView)
		
		self.layoutIfNeeded()
		
		// Position the contentView to fill the view
		contentView.frame				= self.bounds
		contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
	}
	
	fileprivate func setupView() {
		
		
	}

	fileprivate func displayText() {
		
		self.textLabel.isHidden 						= false
		self.textLabel.text 							= ""
		self.textLabelWidthLayoutConstraint.constant 	= 0
		self.textLabelHeightLayoutConstraint.constant 	= 0
		
		if (self.item == nil) {
	
			return
			
		} else if (self.item!.text.count == 0) {
			
			self.textLabel.isHidden 	= true
			
		} else {
			
			self.textLabel.text 		= self.item!.text

			self.setTextLabelSize()
			
		}
		
	}
	
	fileprivate func displayCompetitionName() {
		
		self.competitionNameLabel.isHidden 							= false
		self.competitionNameLabel.text 								= ""
		self.competitionNameLabelWidthLayoutConstraint.constant 	= 0
		self.competitionNameLabelHeightLayoutConstraint.constant 	= 0
		
		if (self.item == nil) {
			
			return
			
		} else if (self.item!.competitionName.count == 0) {
			
			self.competitionNameLabel.isHidden 	= true
			
		} else {
			
			self.competitionNameLabel.text 		= self.item!.competitionName
			
			self.setCompetitionNameLabelSize()
		}
		
	}
	
	fileprivate func displayImage() {
	
		self.imageView.isHidden 								= false
		self.imageView.image 									= nil
		self.imageViewWidthLayoutConstraint.constant 			= 0
		self.imageViewHeightLayoutConstraint.constant 			= 0
		self.labelsStackViewLeadingLayoutConstraint.constant 	= 0
		
		if (self.item == nil) {
			
			return
			
		} else if (self.item!.imageData == nil) {
			
			self.imageView.isHidden 								= true
			
		} else {
			
			self.imageView.image 									= UIImage(data: self.item!.imageData!)
			self.labelsStackViewLeadingLayoutConstraint.constant 	= self.labelsStackViewLeadingSpacing
			
			self.setImageViewSize()
			
		}
		
	}
	
	fileprivate func displayQuote() {
		
		self.quoteLabel.isHidden 						= false
		self.quoteLabel.text 							= ""
		self.quoteLabelWidthLayoutConstraint.constant 	= 0
		self.quoteLabelHeightLayoutConstraint.constant 	= 0
		
		if (self.item == nil) {
			
			return
			
		} else if (self.item!.quote.count == 0) {
			
			self.quoteLabel.isHidden 	= true
			
		} else {
			
			self.quoteLabel.text 		= self.item!.quote
			
			self.setQuoteLabelSize()
			
		}
		
	}
	
	fileprivate func setTextLabelSize() {
		
		// Set maxTextLabelSize
		self.maxTextLabelSize.width 		= self.maximumContentSize!.width
		
		// Set label size
		UILabelHelper.setSizeToFit(label: 					self.textLabel,
								   widthLayoutConstraint: 	self.textLabelWidthLayoutConstraint,
								   heightLayoutConstraint: 	self.textLabelHeightLayoutConstraint,
								   maxWidth: 				self.maxTextLabelSize.width,
								   maxNumberofLines: 		self.maxTextLabelNumberofLines)

	}

	fileprivate func setCompetitionNameLabelSize() {
		
		// Set maxCompetitionNameLabelSize
		self.maxCompetitionNameLabelSize.width 		= self.maximumContentSize!.width
	
		// Set label size
		UILabelHelper.setSizeToFit(label: 					self.competitionNameLabel,
								   widthLayoutConstraint: 	self.competitionNameLabelWidthLayoutConstraint,
								   heightLayoutConstraint: 	self.competitionNameLabelHeightLayoutConstraint,
								   maxWidth: 				self.maxCompetitionNameLabelSize.width,
								   maxNumberofLines: 		self.maxCompetitionNameLabelNumberofLines)
		
	}

	fileprivate func setQuoteLabelSize() {
		
		// Get remainingContentWidth
		var remainingContentWidth: 			CGFloat = self.maximumContentSize!.width
		
		if (!self.imageView.isHidden) {
			
			remainingContentWidth 			-= self.imageViewWidthLayoutConstraint.constant + labelsStackViewLeadingSpacing
			
		}
		
		// Set maxQuoteLabelSize
		self.maxQuoteLabelSize.width 	= remainingContentWidth
		
		// Set label size
		UILabelHelper.setSizeToFit(label: 					self.quoteLabel,
								   widthLayoutConstraint: 	self.quoteLabelWidthLayoutConstraint,
								   heightLayoutConstraint: 	self.quoteLabelHeightLayoutConstraint,
								   maxWidth: 				self.maxQuoteLabelSize.width,
								   maxNumberofLines: 		self.maxQuoteLabelNumberofLines)
		
	}
	
	fileprivate func setImageViewSize() {
		
		// Set imageView max size
		self.maxImageViewSize.height 	= self.maximumContentSize!.height
		self.maxImageViewSize.width 	= self.maximumContentSize!.width * 0.3	// 30% of available width
		
		var imageViewWidth: 			CGFloat = self.imageView.image!.size.width
		var imageViewHeight: 			CGFloat = self.imageView.image!.size.height
		
		// Get aspect ratio
		let aspectRatio: 				CGFloat = imageViewWidth / imageViewHeight
		
		// Check imageViewWidth less than max
		if (imageViewWidth > self.maxImageViewSize.width) {
			
			imageViewWidth 				= self.maxImageViewSize.width
			imageViewHeight 			= imageViewWidth / aspectRatio
			
		}
		
		// Get remainingContentHeight
		var remainingContentHeight: 	CGFloat = self.maximumContentSize!.height
		
		if (!self.textLabel.isHidden) {
			
			remainingContentHeight 		-= self.textLabelHeightLayoutConstraint.constant
			
		}
		
		if (!self.competitionNameLabel.isHidden) {
			
			remainingContentHeight 		-= self.competitionNameLabelHeightLayoutConstraint.constant
			
		}
		
		// Set maxImageViewSize
		self.maxImageViewSize.height 	= remainingContentHeight
		
		// Check imageViewHeight less than max
		if (imageViewHeight > self.maxImageViewSize.height) {
			
			imageViewHeight 			= self.maxImageViewSize.height
			imageViewWidth 				= imageViewHeight * aspectRatio
			
		}
		
		// Set size layout constraints
		self.imageViewWidthLayoutConstraint.constant 	= imageViewWidth
		self.imageViewHeightLayoutConstraint.constant 	= imageViewHeight
		
	}
	
	fileprivate func setContentSize() {

		var contentWidth: 					CGFloat = 0
		var contentHeight: 					CGFloat = 0
		
		// Width is the greatest of; textLabel, competitionNameLabel, imageView + quoteLabel
		contentWidth = max(self.textLabelWidthLayoutConstraint.constant,
						    self.competitionNameLabelWidthLayoutConstraint.constant,
						   (self.imageViewWidthLayoutConstraint.constant + labelsStackViewLeadingSpacing + self.quoteLabelWidthLayoutConstraint.constant))
		
		// Height is the greatest of; textLabel + competitionNameLabel + imageView, textLabel + competitionNameLabel + quoteLabel
		contentHeight = max((self.textLabelHeightLayoutConstraint.constant + competitionNameLabelTopSpacing + competitionNameLabelHeightLayoutConstraint.constant + imageViewTopSpacing + self.imageViewHeightLayoutConstraint.constant),
							(self.textLabelHeightLayoutConstraint.constant + competitionNameLabelTopSpacing + competitionNameLabelHeightLayoutConstraint.constant + imageViewTopSpacing +
							self.quoteLabelHeightLayoutConstraint.constant))
		
		
		// Set contentSize
		self.contentSize = CGSize(width: contentWidth, height: contentHeight)
		
		// Notify the delegate
		self.delegate?.awardsBarItemView(didSetContentSize: self, size: self.contentSize)
		
	}
	
	fileprivate func getMaximumContentSize() {
		
		// Notify the delegate
		self.maximumContentSize = self.delegate?.awardsBarItemView(maximumContentSize: self)
		
	}
	
}

