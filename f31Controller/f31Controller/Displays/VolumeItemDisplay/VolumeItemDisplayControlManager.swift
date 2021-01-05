//
//  VolumeItemDisplayControlManager.swift
//  f31Controller
//
//  Created by David on 14/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFController
import f31Core
import f31Model
import f31View

/// Manages the VolumeItemDisplay control layer
public class VolumeItemDisplayControlManager: VolumesControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public var viewManager:	VolumeItemDisplayViewManager?
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager,
				viewManager: VolumeItemDisplayViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager	= viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func displaySelectedVolume() {
		
		guard (self.selectedVolume != nil) else { return }
		
		self.displayLatestVolumeComment()
		
		self.viewManager!.display(volume: self.selectedVolume!)
	}
	
	public func displayNumberofLikes() {
		
		guard (self.selectedVolume != nil) else { return }
		
		self.viewManager!.displayNumberofLikes(numberofLikes: self.selectedVolume!.numberofLikes)
		
	}
	
	public func displayLatestVolumeComment() {
		
		guard (self.selectedVolume != nil) else { return }
		
		if (self.selectedVolume!.latestVolumeCommentText.count > 0) {
			
			self.viewManager!.displayLatestVolumeComment(text: self.selectedVolume!.latestVolumeCommentText,
														 postedByName: self.selectedVolume!.latestVolumeCommentPostedByName,
														 datePosted: self.selectedVolume!.latestVolumeCommentDatePosted)
			
		} else {
			
			self.viewManager!.clearLatestVolumeComment()
			
		}
		
	}
	
}
