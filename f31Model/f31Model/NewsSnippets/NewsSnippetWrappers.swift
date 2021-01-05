//
//  NewsSnippetWrappers.swift
//  f31Model
//
//  Created by David on 05/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A singleton class which encapsulates an array of NewsSnippetWrappers
public class NewsSnippetWrappers {
	
	// MARK: - Private Stored Properties
	
	fileprivate var items:						[NewsSnippetWrapper] = [NewsSnippetWrapper]()
	
	
	// MARK: - Private Static Properties
	
	fileprivate static var singleton:			NewsSnippetWrappers?
	
	
	// MARK: - Initializers
	
	fileprivate init() {
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var items: [NewsSnippetWrapper] {
		get {
			
			return NewsSnippetWrappers.getSingleton.items
		}
		set (value) {
			
			NewsSnippetWrappers.getSingleton.items = value
		}
	}
	
	
	// MARK: - Private Class Computed Properties
	
	fileprivate class var getSingleton: NewsSnippetWrappers {
		get {
			
			if (NewsSnippetWrappers.singleton == nil) {
				NewsSnippetWrappers.singleton = NewsSnippetWrappers()
			}
			
			return NewsSnippetWrappers.singleton!
		}
	}
}
