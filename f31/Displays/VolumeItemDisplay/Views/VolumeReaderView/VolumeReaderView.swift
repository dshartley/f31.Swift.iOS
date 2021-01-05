//
//  VolumeReaderView.swift
//  f31
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView
import SFCore
import f31Core
import f31Model
import f31View
import f31Controller

/// A view class for a VolumeReaderView
public class VolumeReaderView: UIView, ProtocolVolumeReaderView {
	
	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:						VolumeReaderViewControlManager?
	fileprivate var isNotConnectedAlertIsShownYN:		Bool = false
	fileprivate var pageViewController:					UIPageViewController? = nil
	fileprivate var pageViewPanGestureRecognizer: 		UIPanGestureRecognizer? = nil
	fileprivate var panGestureHelper:					PanGestureHelper?
	fileprivate var pageContentViewControllers:			[Int: VolumeReaderPageContentViewController]? = [Int: VolumeReaderPageContentViewController]()
	

	// MARK: - Public Stored Properties
	
	public weak var delegate:							ProtocolVolumeReaderViewDelegate?
	
	@IBOutlet weak var contentView:						UIView!
	
	
	// MARK: - Initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setupContentView()
		
		self.setup()
		self.setupView()
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setupContentView()
		
		self.setup()
		self.setupView()
		
	}
	
	
	// MARK: - Override Methods

	
	// MARK: - Public Methods
	
	public func viewDidAppear() {
		
	}
	
	public func viewDidTransition() {
	
		self.layoutIfNeeded()
		
		self.setPageContentViewControllersActualTraitCollection()
		
	}
	
	public func clearView() {

		// Go through each item
		for pcvc in self.pageContentViewControllers!.values {
			
			pcvc.clear()
			
		}
		
		self.pageContentViewControllers 		= nil
		
		let vc: UIViewController 				= UIViewController()
		self.pageViewController?.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
		
		self.controlManager!.clear()
		
	}
	
	public func set(item: VolumeWrapper) {
		
		self.controlManager!.set(item: item)

		// Check volumeContentData
		guard (item.volumeContentData != nil) else { return }
		
		// Check numberofPages
		guard (self.controlManager!.numberofPages > 0) else { return }
		
		// Create PageContentViewControllers
		self.createPageContentViewControllers()
		
		self.controlManager!.currentPageNumber = 1
		
		
		// Create completion handler
		let loadAssetsCompletionHandler: ((VolumeWrapper, Error?) -> Void) =
		{
			(item, error) -> Void in
			
			// Display first page
			self.doDisplayPage(pageNumber: 1)
			
			// Preload next page assets
			self.doPreloadAssets()
			
		}
		
		// Load assets for the first page
		self.doLoadAssets(forPage: 1, oncomplete: loadAssetsCompletionHandler)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager 			= VolumeReaderViewControlManager()
		
		self.controlManager!.delegate 	= self
		
	}
	
	fileprivate func setupModelManager() {
		
		// Set the model manager
		self.controlManager!.set(modelManager: ModelFactory.modelManager)
		
		// Setup the model administrators
		//ModelFactory.setupUserProfileModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
	}
	
	fileprivate func setupViewManager() {
		
		// Create view strategy
		let viewAccessStrategy: VolumeReaderViewViewAccessStrategy = VolumeReaderViewViewAccessStrategy()
		
		viewAccessStrategy.setup()
		
		// Setup the view manager
		self.controlManager!.viewManager = VolumeReaderViewViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setupContentView() {
		
		// Load xib
		Bundle.main.loadNibNamed("VolumeReaderView", owner: self, options: nil)
		
		addSubview(contentView)
		
		self.layoutIfNeeded()
		
		// Position the contentView to fill the view
		contentView.frame				= self.bounds
		contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
	}
	
	fileprivate func setupView() {

		self.setupPageViewController()
		self.setupPanGestureHelper()
		
	}
	
	fileprivate func setupPageViewController() {
		
		// Create pageViewController
		self.pageViewController 				= UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)

		self.pageViewController!.view.backgroundColor = UIColor.white
		self.pageViewController!.delegate 		= self
		self.pageViewController!.dataSource 	= self
		
		self.pageViewController!.view.translatesAutoresizingMaskIntoConstraints = false
		self.contentView!.addSubview(self.pageViewController!.view)
		
		// Set layout constraints
		let views = ["pageController": self.pageViewController!.view] as [String: AnyObject]
		
		self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
		self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
		
		// Get UIPanGestureRecognizer from pageViewController
		for recognizer in self.pageViewController!.gestureRecognizers {
			
			if (recognizer is UIPanGestureRecognizer) {
				
				self.pageViewPanGestureRecognizer 	= recognizer as? UIPanGestureRecognizer

			}
			
		}

	}
	
	fileprivate func setupPanGestureHelper() {
	
		// Create panGestureHelper
		self.panGestureHelper									= PanGestureHelper(gesture: self.pageViewPanGestureRecognizer!)
		
		self.panGestureHelper!.delegate							= self
		
		self.panGestureHelper!.gestureDownEnableThresholdYN		= true
		self.panGestureHelper!.gestureDownCommitThreshold		= 150
		
	}
	
	fileprivate func doLoadAssets(forPage pageNumber: Int, oncomplete completionHandler:@escaping (VolumeWrapper, Error?) -> Void) {
		
		// Create completion handler
		let loadAssetsImageDataCompletionHandler: ((VolumeWrapper, Error?) -> Void) =
		{
			[weak self] (item, error) -> Void in
			
			if (error == nil) {
				
				// Get pageWrapper
				let pageWrapper: VolumePageWrapper? = self?.controlManager!.volumeWrapper!.volumeContentData!.pages![pageNumber]
				
				pageWrapper?.allAssetsLoadedYN = true
				
				if (pageWrapper != nil) {
					
					self?.doDisplayAssets(pageWrapper: pageWrapper!)
					
				}
				
			}

			// Call completion handler
			completionHandler(item, error)
			
		}
		
		// Create groupKey
		let groupKey: String = "\(VolumeGroupKeyPrefixes.page)_\(pageNumber)"
		
		self.loadAssetsImageData(for: self.controlManager!.volumeWrapper!, byGroupKey: groupKey, oncomplete: loadAssetsImageDataCompletionHandler)
		
	}
	
	fileprivate func loadAssetsImageData(for item: VolumeWrapper, byGroupKey groupKey: String, oncomplete completionHandler:@escaping (VolumeWrapper, Error?) -> Void) {
		
		// Create completion handler
		let loadAssetsImageDataForItemCompletionHandler: ((VolumeWrapper, Error?) -> Void) =
		{
			(item, error) -> Void in
			
			// Call completion handler
			completionHandler(item, error)
			
		}
		
		// Load image data
		self.delegate!.volumeReaderView(sender: self, loadAssetsImageDataForItem: item, byGroupKey: groupKey, oncomplete: loadAssetsImageDataForItemCompletionHandler)
		
	}
	
	fileprivate func doDisplayPage(pageNumber: Int) {
		
		// Check currentPageNumber
		guard (pageNumber >= 1 && pageNumber <= self.controlManager!.numberofPages
			&& self.pageContentViewControllers != nil) else {
				
			self.controlManager!.currentPageNumber = 0
				
			return
				
		}
		
		DispatchQueue.main.async {
		
			self.controlManager!.currentPageNumber = pageNumber
			
			let vc: VolumeReaderPageContentViewController? = self.pageContentViewControllers![pageNumber]
			
			self.pageViewController!.setViewControllers([vc!], direction: .forward, animated: false, completion: nil)
			
		}
		
	}
	
	fileprivate func createPageContentViewControllers() {
		
		self.pageContentViewControllers = [Int: VolumeReaderPageContentViewController]()

		// Go through each item
		for pageWrapper in self.controlManager!.volumeWrapper!.volumeContentData!.pages!.values {
			
			// Create VolumeReaderPageContentViewController
			let vc: VolumeReaderPageContentViewController = VolumeReaderPageContentViewController()
			
			vc.set(volumeWrapper: self.controlManager!.volumeWrapper!, pageWrapper: pageWrapper)
			
			// Set actualTraitCollection
			vc.actualTraitCollection = self.traitCollection
			
			self.pageContentViewControllers![pageWrapper.pageNumber] = vc
			
		}
		
	}
	
	fileprivate func doDisplayAssets(pageWrapper: VolumePageWrapper) {
		
		guard (self.pageContentViewControllers != nil) else { return }
		
		DispatchQueue.main.async {
			
			// Get view controller
			let vc: VolumeReaderPageContentViewController? = self.pageContentViewControllers![pageWrapper.pageNumber]
			
			vc!.set(volumeWrapper: self.controlManager!.volumeWrapper!, pageWrapper: pageWrapper)
			vc!.displayAssets()
			
		}

	}
	
	fileprivate func doPreloadAssets() {
	
		guard (self.controlManager!.currentPageNumber < self.controlManager!.numberofPages) else { return }
		
		// Create completion handler
		let loadAssetsCompletionHandler: ((VolumeWrapper, Error?) -> Void) =
		{
			(item, error) -> Void in
			
			// TODO:
			
		}
		
		let nextPageNumber: 	Int = self.controlManager!.currentPageNumber + 1
		
		// Get next pageWrapper
		let pageWrapper: 		VolumePageWrapper? = self.controlManager!.volumeWrapper!.volumeContentData!.pages![nextPageNumber]
		
		// Check allAssetsLoadedYN
		if (!pageWrapper!.allAssetsLoadedYN) {

			self.doLoadAssets(forPage: nextPageNumber, oncomplete: loadAssetsCompletionHandler)
			
		}
		
	}

	fileprivate func setPageContentViewControllersActualTraitCollection() {
		
		let currentVC: 	VolumeReaderPageContentViewController? = self.pageContentViewControllers![self.controlManager!.currentPageNumber]
		
		if (currentVC != nil) {
			
			currentVC!.actualTraitCollection = self.traitCollection
			currentVC!.viewDidTransition()
			
			// Go through each item
			for vc in self.pageContentViewControllers!.values {
				
				vc.actualTraitCollection = self.traitCollection
				
			}
			
		}
		
	}
	
}


// MARK: - Extension ProtocolVolumeReaderViewControlManagerDelegate

extension VolumeReaderView: ProtocolVolumeReaderViewControlManagerDelegate {
	
	// MARK: - Public Methods
	
}


// MARK: - Extension UIPageViewControllerDelegate

extension VolumeReaderView: UIPageViewControllerDelegate {
	
	// MARK: - Public Methods
	
	public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		
		if let vc = pendingViewControllers.first as? VolumeReaderPageContentViewController {
			
			// Notify the delegate
			self.delegate?.volumeReaderView(sender: self, willTransitionTo: vc.pageWrapper!)
			
			let doPreloadYN: Bool = (vc.pageWrapper!.pageNumber > self.controlManager!.currentPageNumber)
			
			self.controlManager!.currentPageNumber = vc.pageWrapper!.pageNumber

			if (doPreloadYN) {

				self.doPreloadAssets()

			}
			
		}
		
	}
	
}


// MARK: - Extension UIPageViewControllerDataSource

extension VolumeReaderView: UIPageViewControllerDataSource {
	
	// MARK: - Public Methods
	
	public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		// Check currentPageNumber
		guard (self.controlManager!.currentPageNumber > 1
			&& self.pageContentViewControllers != nil) else { return nil }
		
		let result: VolumeReaderPageContentViewController? = self.pageContentViewControllers![self.controlManager!.currentPageNumber - 1]
		
		return result
		
	}
	
	public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		// Check currentPageNumber
		guard (self.controlManager!.currentPageNumber < self.controlManager!.numberofPages
			&& self.pageContentViewControllers != nil) else { return nil }
		
		let result: VolumeReaderPageContentViewController? = self.pageContentViewControllers![self.controlManager!.currentPageNumber + 1]
		
		return result
		
	}

}


// MARK: - Extension ProtocolPanGestureHelperDelegate

extension VolumeReaderView: ProtocolPanGestureHelperDelegate {
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .down) {
			
			// Notify the delegate
			self.delegate?.volumeReaderView(for: gesture, panningStartedWith: attributes)
			
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .down) {
			
			// Notify the delegate
			self.delegate?.volumeReaderView(for: gesture, panningContinuedWith: attributes)
			
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes) {
	
		if (attributes.direction == .down) {
			
			// Notify the delegate
			self.delegate?.volumeReaderView(for: gesture, panningStoppedWith: attributes)
			
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .down) {
			
			// Notify the delegate
			self.delegate?.volumeReaderView(for: gesture, panningStoppedAfterThresholdWith: attributes)
			
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .down) {
			
			// Notify the delegate
			self.delegate?.volumeReaderView(for: gesture, panningStoppedBeforeThresholdWith: attributes)
			
		}
		
	}
	
}

