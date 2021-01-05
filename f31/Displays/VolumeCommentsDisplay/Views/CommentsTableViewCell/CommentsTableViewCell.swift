//
//  CommentsTableViewCell.swift
//  f31
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Core
import f31Model

/// A class for a CommentsTableViewCell
public class CommentsTableViewCell: UITableViewCell {

	// MARK: - Public Stored Properties
	
	public fileprivate(set) var item:		VolumeCommentWrapper? = nil
	
	@IBOutlet weak var commentTextLabel: 	UILabel!
	@IBOutlet weak var postedByNameLabel: 	UILabel!
	@IBOutlet weak var datePostedLabel: 	UILabel!
	
	
	
	// MARK: - Public Methods
	
	public func set(item: VolumeCommentWrapper) {

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
		
		self.displayCommentText()
		self.displayPostedByName()
		self.displayDatePosted()
	}
	
	fileprivate func displayCommentText() {
		
		// commentTextLabel
		self.commentTextLabel.text	= self.item!.text
		
	}
	
	fileprivate func displayDatePosted() {
		
		// Get datePostedString from dateFormatter
		let dateFormatter			= DateFormatter()
		dateFormatter.dateFormat	= "MMM d, yyyy"
		dateFormatter.timeZone 		= TimeZone(secondsFromGMT: 0)
		
		let datePostedString 		= dateFormatter.string(from: self.item!.datePosted)
		
		// datePostedLabel
		self.datePostedLabel.text 	= ", " + datePostedString
		
	}
	
	fileprivate func displayPostedByName() {
		
		// postedByNameLabel
		self.postedByNameLabel.text	= self.item!.postedByName
		
	}
}
