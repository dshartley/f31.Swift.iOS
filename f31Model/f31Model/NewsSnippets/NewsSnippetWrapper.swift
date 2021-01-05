//
//  NewsSnippetWrapper.swift
//  f31Model
//
//  Created by David on 05/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a NewsSnippet model item
public class NewsSnippetWrapper {
	
	// MARK: - Public Stored Properties
	
	public var id:					Int = 0
	public var authorID:			Int = 0
	public var year:				Int = 0
	public var text:				String = ""
	public var datePosted:			Date = Date()
	public var imageFileName:		String = ""
	public var imageData:			Data? = nil
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
}
