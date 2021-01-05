//
//  ProtocolNewsBarView.swift
//  f31View
//
//  Created by David on 31/03/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Model

/// Defines a class which is a NewsBarView
public protocol ProtocolNewsBarView: class {
	
	// MARK: - Stored Properties
	
	// MARK: - Methods
	
	func displayNewsSnippets(items: [NewsSnippetWrapper])
	
	func clearNewsSnippets()
	
}
