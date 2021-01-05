//
//  VolumeReaderPageContentViewController.swift
//  f31
//
//  Created by David on 26/10/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView
import f31Core
import f31Model

public class VolumeReaderPageContentViewController: UIViewController {

	// MARK: - Private Stored Properties
	
	fileprivate var imageView: 							UIImageView? = nil
	fileprivate var headerView: 						UIView? = nil
	fileprivate var headerViewHeightLayoutConstraint: 	NSLayoutConstraint? = nil
	fileprivate var volumeTitleLabel:					UILabel? = nil
	fileprivate var footerView: 						UIView? = nil
	fileprivate var pageNumberLabel:					UILabel? = nil
	fileprivate var assetsDisplayedYN:					Bool = false
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var volumeWrapper: 			VolumeWrapper? = nil
	public fileprivate(set) var pageWrapper: 			VolumePageWrapper? = nil
	public var actualTraitCollection: 					UITraitCollection? = nil
	
	
	// MARK: - Initializers
	
	
	// MARK: - Override Methods
	
	override public func viewDidLoad() {
		super.viewDidLoad()
	
		self.setupView()
	
		self.displayPageDetails()
		self.displayAssets()
		
	}
	
	public func viewDidTransition() {
		
		self.view.layoutIfNeeded()
		
		self.setHeaderViewHeight()
		
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		
		self.setHeaderViewHeight()
		
		if (!self.assetsDisplayedYN) {
			
			self.displayAssets()
			
		}
		
	}
	
	
	// MARK: - Public Methods
	
	public func set(volumeWrapper: VolumeWrapper, pageWrapper: VolumePageWrapper) {
		
		self.volumeWrapper 	= volumeWrapper
		self.pageWrapper 	= pageWrapper

	}

	public func clear() {
		
		self.volumeWrapper 			= nil
		self.pageWrapper 			= nil
		
		DispatchQueue.main.async {
			
			self.imageView?.image 		= nil
			self.volumeTitleLabel?.text = nil
			self.pageNumberLabel?.text 	= nil
			
		}
		
	}
	
	public func displayPageDetails() {
		
		DispatchQueue.main.async {
			
			self.volumeTitleLabel?.text = self.volumeWrapper!.title.uppercased()
			
			self.pageNumberLabel?.text = "Page \(self.pageWrapper!.pageNumber)"
			
		}

	}
	
	public func displayAssets() {
		
		guard (self.imageView != nil
			&& self.pageWrapper != nil) else { return }
		
		DispatchQueue.main.async {
			
			// Get assetWrapper
			let assetWrapper: 	VolumeAssetWrapper? = self.pageWrapper!.assets?.first?.value
			
			guard (assetWrapper != nil) else { return }
			
			// Get imageData
			let imageData: 		Data? = assetWrapper!.get(attribute: "\(VolumeAssetAttributes.ImageData)") as? Data
			
			// Create image
			var image: 			UIImage? = nil
			
			if (imageData != nil) {
				
				image = UIImage(data: imageData!)
				
			}
			
			// Set imageView.contentMode
			if (image != nil
				&& (image!.size.width > self.imageView!.frame.width
				|| image!.size.height > self.imageView!.frame.height)) {
				
				self.imageView!.contentMode	= .scaleAspectFit
				
			} else {
				
				self.imageView!.contentMode	= .center
				
			}
			
			self.imageView!.image = image
		
			self.assetsDisplayedYN = true
			
		}
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setupView() {
		
		self.view!.backgroundColor = UIColor.white
		
		self.setupHeaderView()
		self.setupFooterView()
		self.setupImageView()
		self.setupVolumeTitleLabel()
		self.setupPageNumberLabel()
		
	}
	
	fileprivate func setupImageView() {
		
		// Create imageView
		self.imageView 			= UIImageView()
		
		self.imageView!.backgroundColor 							= UIColor.clear
		self.imageView!.translatesAutoresizingMaskIntoConstraints 	= false
		
		// Nb: Set contentMode in displayAssets depending on image size
		//self.imageView!.contentMode 								= .scaleAspectFit
		
		self.view.addSubview(self.imageView!)
		
		// Constraints leading, trailing, top, bottom
		let lcleading: 			NSLayoutConstraint = NSLayoutConstraint(item: self.imageView!, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 10)
		let lctrailing: 		NSLayoutConstraint = NSLayoutConstraint(item: self.imageView!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -10)
		let lctop: 				NSLayoutConstraint = NSLayoutConstraint(item: self.imageView!, attribute: .top, relatedBy: .equal, toItem: self.headerView, attribute: .bottom, multiplier: 1, constant: 10)
		let lcbottom: 			NSLayoutConstraint = NSLayoutConstraint(item: self.imageView!, attribute: .bottom, relatedBy: .equal, toItem: self.footerView, attribute: .top, multiplier: 1, constant: -10)
		
		NSLayoutConstraint.activate([lcleading, lctrailing, lctop, lcbottom])
		
	}
	
	fileprivate func setupHeaderView() {
		
		// Create headerView
		self.headerView 						= UIView()

		self.headerView!.backgroundColor 		= UIColor.clear
		self.headerView!.translatesAutoresizingMaskIntoConstraints 	= false
		
		self.view!.addSubview(self.headerView!)
		
		// Constraints leading, trailing, top
		let lcleading: 		NSLayoutConstraint = NSLayoutConstraint(item: self.headerView!, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
		let lctrailing: 	NSLayoutConstraint = NSLayoutConstraint(item: self.headerView!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
		let lctop: 			NSLayoutConstraint = NSLayoutConstraint(item: self.headerView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)

		self.setHeaderViewHeight()

		NSLayoutConstraint.activate([lcleading, lctrailing, lctop])
		
	}

	fileprivate func setHeaderViewHeight() {
		
		guard (self.headerView != nil) else { return }
		
		DispatchQueue.main.async {
			
			var viewHeight:	CGFloat = 50
			
			if (self.actualTraitCollection!.verticalSizeClass == .compact) {

				viewHeight = 30
				
			}
			
			if (self.headerViewHeightLayoutConstraint == nil) {
				
				// Constraints height
				self.headerViewHeightLayoutConstraint 	= NSLayoutConstraint(item: self.headerView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewHeight)
				
				self.headerView!.addConstraints([self.headerViewHeightLayoutConstraint!])
				
			} else {
				
				self.headerViewHeightLayoutConstraint?.constant = viewHeight
				
			}
			
			self.view.layoutIfNeeded()
		
		}
		
	}
	
	fileprivate func setupVolumeTitleLabel() {
		
		// Create volumeTitleLabel
		self.volumeTitleLabel 					= UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
		
		self.volumeTitleLabel!.textAlignment 	= .center
		self.volumeTitleLabel!.textColor 		= UIColor.lightGray
		self.volumeTitleLabel!.font 			= UIFont(name: "Avenir-Book", size: 16)
		self.volumeTitleLabel!.translatesAutoresizingMaskIntoConstraints 	= false

		self.headerView!.addSubview(self.volumeTitleLabel!)
		
		// Constraints centerX, bottom
		let lccenterx: 		NSLayoutConstraint = NSLayoutConstraint(item: self.volumeTitleLabel!, attribute: .centerX, relatedBy: .equal, toItem: self.headerView!, attribute: .centerX, multiplier: 1, constant: 0)
		let lcbottom: 		NSLayoutConstraint = NSLayoutConstraint(item: self.volumeTitleLabel!, attribute: .bottom, relatedBy: .equal, toItem: self.headerView!, attribute: .bottom, multiplier: 1, constant: 0)

		// Constraints width
		let lcwidth: 		NSLayoutConstraint = NSLayoutConstraint(item: self.volumeTitleLabel!, attribute: .width, relatedBy: .equal, toItem: self.headerView!, attribute: .width, multiplier: 1, constant: -40)
		
		//self.volumeTitleLabel!.addConstraints([lcwidth])
		NSLayoutConstraint.activate([lccenterx, lcbottom, lcwidth])
		
	}
	
	fileprivate func setupFooterView() {
		
		// Create footerView
		self.footerView 						= UIView()
		
		self.footerView!.backgroundColor 		= UIColor.clear
		self.footerView!.translatesAutoresizingMaskIntoConstraints 	= false
		
		self.view!.addSubview(self.footerView!)
		
		// Constraints leading, trailing, bottom
		let lcleading: 		NSLayoutConstraint = NSLayoutConstraint(item: self.footerView!, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
		let lctrailing: 	NSLayoutConstraint = NSLayoutConstraint(item: self.footerView!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
		let lcbottom: 		NSLayoutConstraint = NSLayoutConstraint(item: self.footerView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
		
		let viewMaxHeight:	CGFloat = 30
		
		// Constraints height
		let lcheight: 		NSLayoutConstraint = NSLayoutConstraint(item: self.footerView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewMaxHeight)
		
		self.footerView!.addConstraints([lcheight])
		NSLayoutConstraint.activate([lcleading, lctrailing, lcbottom])
		
	}
	
	fileprivate func setupPageNumberLabel() {
		
		// Create pageNumberLabel
		self.pageNumberLabel 					= UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
		
		self.pageNumberLabel!.textAlignment 	= .center
		self.pageNumberLabel!.textColor 		= UIColor.lightGray
		self.pageNumberLabel!.font 				= UIFont(name: "Avenir-Book", size: 16)
		self.pageNumberLabel!.translatesAutoresizingMaskIntoConstraints 	= false
		
		self.footerView!.addSubview(self.pageNumberLabel!)
		
		// Constraints centerX, top
		let lccenterx: 		NSLayoutConstraint = NSLayoutConstraint(item: self.pageNumberLabel!, attribute: .centerX, relatedBy: .equal, toItem: self.footerView!, attribute: .centerX, multiplier: 1, constant: 0)
		let lctop: 			NSLayoutConstraint = NSLayoutConstraint(item: self.pageNumberLabel!, attribute: .top, relatedBy: .equal, toItem: self.footerView!, attribute: .top, multiplier: 1, constant: 0)
		
		// Constraints width
		let lcwidth: 		NSLayoutConstraint = NSLayoutConstraint(item: self.pageNumberLabel!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
		
		self.pageNumberLabel!.addConstraints([lcwidth])
		NSLayoutConstraint.activate([lccenterx, lctop])
		
	}
	
}


