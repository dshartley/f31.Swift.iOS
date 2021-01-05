//
//  NewsSnippetsTableViewCell.swift
//  f31
//
//  Created by David on 06/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Core
import f31Model

/// A class for a NewsSnippetsTableViewCell
public class NewsSnippetsTableViewCell: UITableViewCell {
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Public Stored Properties
	
	public var delegate:										ProtocolNewsSnippetsTableViewCellDelegate?
	public fileprivate(set) var item:							NewsSnippetWrapper? = nil
	
	@IBOutlet weak var itemTextLabel: 							UILabel!
	@IBOutlet weak var datePostedLabel: 						UILabel!
	@IBOutlet weak var imageImageView: 							UIImageView!
	@IBOutlet weak var imageImageViewHeightLayoutConstraint: 	NSLayoutConstraint!
	
	
	// MARK: - Public Methods
	
	public func set(item: NewsSnippetWrapper) {
		
		self.item = item
		
		self.displayItem()
	}
	
	
	// MARK: - Override Methods
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		
		self.setup()
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
	}
	
	fileprivate func displayItem() {
		
		guard (self.item != nil) else { return }
		
		self.displayText()
		self.displayDatePosted()
		self.displayImage()
	}
	
	fileprivate func displayText() {
		
		// itemTextLabel
		self.itemTextLabel.text 	= "\"" + self.item!.text + "\""
		
	}
	
	fileprivate func displayDatePosted() {
		
		// Get datePostedString from dateFormatter
		let dateFormatter			= DateFormatter()
		dateFormatter.dateFormat	= "MMM d, yyyy"
		dateFormatter.timeZone 		= TimeZone(secondsFromGMT: 0)
		
		let datePostedString 		= dateFormatter.string(from: self.item!.datePosted)
		
		// datePostedLabel
		self.datePostedLabel.text 	= datePostedString
		
	}
	
	fileprivate func displayImage() {
		
		// Clear the image
		self.imageImageView.image 							= nil
		
		// Set the height constraint to hide the image view
		self.imageImageViewHeightLayoutConstraint.constant 	= 0
		//NSLayoutConstraint.activate([self.imageImageViewHeightLayoutConstraint])
		
		if (self.item == nil) {
			
			return

		} else if (self.item!.imageData != nil) {
			
			// Set the image
			self.imageImageView.image 						= UIImage(data: self.item!.imageData!)
			self.imageImageViewHeightLayoutConstraint.constant 	= 100
			//NSLayoutConstraint.deactivate([self.imageImageViewHeightLayoutConstraint])
			
		}
		
	}
	
}
