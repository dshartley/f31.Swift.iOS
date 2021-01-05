//
//  VolumeReaderViewControlManager.swift
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

/// Manages the VolumeReaderView control layer
public class VolumeReaderViewControlManager: ControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:						ProtocolVolumeReaderViewControlManagerDelegate?
	public var viewManager:							VolumeReaderViewViewManager?
	public fileprivate(set) var volumeWrapper: 		VolumeWrapper? = nil
	public fileprivate(set) var numberofPages: 		Int = 0
	public var currentPageNumber:					Int = 0
	
	
	// MARK: - Private Stored Properties

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager, viewManager: VolumeReaderViewViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager				= viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func clear() {
	
		self.numberofPages 		= 0
		self.currentPageNumber 	= 0
		
	}
	
	public func set(item: VolumeWrapper) {
		
		self.clear()
		
		self.volumeWrapper = item
		
		guard (item.volumeContentData != nil) else {
		
			self.clear()
			
			return
			
		}
		
		// Get numberofPages
		self.numberofPages = item.volumeContentData!.pages!.count
		
	}
	
	
	// MARK: - Override Methods
	
	
	// MARK: - Private Methods
	
}
