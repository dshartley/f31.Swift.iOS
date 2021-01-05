//
//  VolumeItemDisplayViewAccessStrategy.swift
//  f31View
//
//  Created by David on 19/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import f31Model

/// A strategy for accessing the VolumeItemDisplay view
public class VolumeItemDisplayViewAccessStrategy {
	
	// MARK: - Private Stored Properties
	
	fileprivate var numberofLikesLabel: 						UILabel!
	fileprivate var latestVolumeCommentTextLabel: 				UILabel!
	fileprivate var latestVolumeCommentPostedByNameLabel: 		UILabel!
	fileprivate var latestVolumeCommentDatePostedLabel: 		UILabel!
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func setup(numberofLikesLabel: 						UILabel,
					  latestVolumeCommentTextLabel: 			UILabel,
					  latestVolumeCommentPostedByNameLabel: 	UILabel,
					  latestVolumeCommentDatePostedLabel: 		UILabel) {

		self.numberofLikesLabel						= numberofLikesLabel
		self.latestVolumeCommentTextLabel 			= latestVolumeCommentTextLabel
		self.latestVolumeCommentPostedByNameLabel 	= latestVolumeCommentPostedByNameLabel
		self.latestVolumeCommentDatePostedLabel 	= latestVolumeCommentDatePostedLabel

	}
	
}

// MARK: - Extension ProtocolVolumeItemDisplayViewAccessStrategy

extension VolumeItemDisplayViewAccessStrategy: ProtocolVolumeItemDisplayViewAccessStrategy {
	
	public func display(volume: VolumeWrapper) {

		self.displayNumberofLikes(numberofLikes: volume.numberofLikes)
		
	}
	
	public func displayNumberofLikes(numberofLikes: Int) {
		
		var value: String = ""
		
		if (numberofLikes > 0) { value = String(numberofLikes) }
		
		self.numberofLikesLabel!.text = value
		
	}
	
	public func clearLatestVolumeComment() {
		
		self.latestVolumeCommentTextLabel.text 			= ""
		self.latestVolumeCommentPostedByNameLabel.text 	= ""
		self.latestVolumeCommentDatePostedLabel.text 	= ""
		
	}
	
	public func displayLatestVolumeComment(text: String, postedByName: String, datePosted: Date) {
		
		self.latestVolumeCommentTextLabel.text 				= "\"" + text + "\""
		self.latestVolumeCommentPostedByNameLabel.text 		= postedByName
		
		// Get latestVolumeCommentDatePostedString from dateFormatter
		let dateFormatter									= DateFormatter()
		dateFormatter.dateFormat							= "MMM d, yyyy"
		dateFormatter.timeZone 								= TimeZone(secondsFromGMT: 0)
		
		let latestVolumeCommentDatePostedString 			= dateFormatter.string(from: datePosted)
		
		self.latestVolumeCommentDatePostedLabel.text 		= ", " + latestVolumeCommentDatePostedString
		
	}
}
