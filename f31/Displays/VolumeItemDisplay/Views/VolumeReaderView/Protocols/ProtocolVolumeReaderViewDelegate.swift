//
//  ProtocolVolumeReaderViewDelegate.swift
//  f31
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView
import f31Model

/// Defines a delegate for a VolumeReaderView class
public protocol ProtocolVolumeReaderViewDelegate: class {
	
	// MARK: - Methods

	func volumeReaderView(sender: VolumeReaderView, loadAssetsImageDataForItem item: VolumeWrapper, byGroupKey groupKey: String, oncomplete completionHandler:@escaping (VolumeWrapper, Error?) -> Void)
	
	func volumeReaderView(sender: VolumeReaderView, willTransitionTo pageWrapper: VolumePageWrapper)
	
	func volumeReaderView(for gesture:UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes)
	
	func volumeReaderView(for gesture:UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes)
	
	func volumeReaderView(for gesture:UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes)
	
	func volumeReaderView(for gesture:UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes)
	
	func volumeReaderView(for gesture:UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes)
	
}
