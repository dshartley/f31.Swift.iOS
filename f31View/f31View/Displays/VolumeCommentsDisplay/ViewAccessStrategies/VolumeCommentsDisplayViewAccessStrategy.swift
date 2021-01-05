//
//  VolumeCommentsDisplayViewAccessStrategy.swift
//  f31View
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import f31Core

/// A strategy for accessing the VolumeCommentsDisplay view
public class VolumeCommentsDisplayViewAccessStrategy {

	// MARK: - Private Stored Properties
	
	fileprivate var postedByNameTextField:	UITextField!
	fileprivate var commentTextView:		UITextView!
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func setup(postedByNameTextField: 	UITextField,
	                  commentTextView: 			UITextView) {

		self.postedByNameTextField 	= postedByNameTextField
		self.commentTextView		= commentTextView
		
	}
	
}

// MARK: - Extension ProtocolVolumeCommentsDisplayViewAccessStrategy

extension VolumeCommentsDisplayViewAccessStrategy: ProtocolVolumeCommentsDisplayViewAccessStrategy {
	
	// MARK: - Methods
	
	public func getPostedByName() -> String {
		
		return self.postedByNameTextField.text ?? ""
	}
	
	public func getComment() -> String {
		
		return self.commentTextView.text
	}
	
}
