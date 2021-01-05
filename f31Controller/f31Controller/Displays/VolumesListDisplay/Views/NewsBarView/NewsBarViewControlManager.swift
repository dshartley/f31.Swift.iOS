//
//  NewsBarViewControlManager.swift
//  f31Controller
//
//  Created by David on 24/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFCore
import SFController
import f31View
import f31Model
import f31Core

/// Manages the NewsBarView control layer
public class NewsBarViewControlManager: ControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:						ProtocolNewsBarViewControlManagerDelegate?
	public var viewManager:							NewsBarViewViewManager?
	
	
	// MARK: - Private Stored Properties

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager, viewManager: NewsBarViewViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager				= viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func displayText() {
		
		// Display text
		//self.viewManager!.displayText(value: "")
		
	}
	
	public func saveTextFromDisplay(oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// TODO:
		
		// Call completion handler
		completionHandler(nil)

	}
	
	public func checkTextIsChanged() -> Bool {
		
		let result: 		Bool = false
		
		// Get from view
		//let text: 		String = self.viewManager!.getText()
		
		//if (text != UserProfileWrapper.current!.text) { result = true }
		
		return result
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods
	
}
