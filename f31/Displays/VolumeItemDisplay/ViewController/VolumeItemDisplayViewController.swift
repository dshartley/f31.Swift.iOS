//
//  VolumeItemDisplayViewController.swift
//  f31
//
//  Created by David on 14/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView
import f31Core
import f31Model
import f31View
import f31Controller

/// A ViewController for the VolumeItemDisplay
public class VolumeItemDisplayViewController: UIViewController {
	
	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:											VolumeItemDisplayControlManager?
	fileprivate var isNotConnectedAlertIsShownYN:							Bool = false
	fileprivate var panGestureHelper:										PanGestureHelper?
	fileprivate var autoHideViewsTimer:										Timer?
	fileprivate var hideSwipeDownMessageViewTimer:							Timer?
	fileprivate var latestVolumeCommentContainerViewDefaultWidth:			CGFloat = 240
	fileprivate var viewWillTransitionYN: 									Bool = false
	
	
	// MARK: - Public Static Stored Properties
	
	public fileprivate(set) static var swipeDownMessageViewShownYN:			Bool = false
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:	ProtocolVolumeItemDisplayViewControllerDelegate?

	@IBOutlet var panGestureRecognizer:										UIPanGestureRecognizer!
	@IBOutlet var contentView:												UIView!
	@IBOutlet weak var swipeDownMessageView: 								UIView!
	@IBOutlet weak var buttonsRightContainerView: 							UIPassthroughView!
	@IBOutlet weak var likeButtonView: 										UIView!
	@IBOutlet weak var commentsButtonView: 									UIView!
	@IBOutlet weak var likedVolumeView: 									UIView!
	@IBOutlet weak var numberofLikesLabel: 									UILabel!
	@IBOutlet weak var fadeOutView: 										UIView!
	@IBOutlet weak var latestVolumeCommentView: 							UIView!
	@IBOutlet weak var latestVolumeCommentTextLabel: 						UILabel!
	@IBOutlet weak var latestVolumeCommentPostedByNameLabel: 				UILabel!
	@IBOutlet weak var latestVolumeCommentDatePostedLabel: 					UILabel!
	@IBOutlet weak var latestVolumeCommentContainerView: 					UIView!
	@IBOutlet weak var latestVolumeCommentContainerViewWidthConstraint: 	NSLayoutConstraint!
	@IBOutlet weak var volumeReaderView: 									VolumeReaderView!
	@IBOutlet weak var volumeReaderPlaceholderView: 						UIView!
	@IBOutlet weak var loadingActivityIndicator: 							UIActivityIndicatorView!
	@IBOutlet weak var watermarkContainerView: 								UIView!
	@IBOutlet weak var watermarkView: 										UIView!
	
	
	// MARK: - Override Methods
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.setup()
		
		self.view.layoutIfNeeded()
		
		self.setupLoadingActivityIndicator()
		self.setupWatermarkContainerView()
		self.setupCommentsButtonView()
		self.setupLikeButtonView()
		self.setupLikedVolumeView()
		self.setupLatestVolumeCommentView()
		self.setupSwipeDownMessageView()
		self.setupPanGestureHelper()
		self.setupFadeOutView()
		self.setupVolumeReaderView()
		
	}
	
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
	}
	
	override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		self.viewWillTransitionYN = true
		
		//self.volumeReaderView!.viewWillTransition(to: size, with: coordinator)
		
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		
		// Present latest volume comment view
		self.presentLatestVolumeCommentView()
		
	}
	
	public override func viewDidLayoutSubviews() {
		
		// Refresh latestVolumeCommentView
		if (self.viewWillTransitionYN) {
			
			self.view.layoutIfNeeded()
			
			self.volumeReaderView!.viewDidTransition()
			
			self.setLatestVolumeCommentViewSize()
			
		}
		
		self.viewWillTransitionYN = false
		
	}
	
	
	// MARK: - Public Methods
	
	public func set(item: VolumeWrapper, selectedDaughter: Daughters, selectedYear: Int) {

		self.controlManager!.selectedDaughter	= selectedDaughter
		self.controlManager!.selectedYear		= selectedYear

		// Set selectedVolume
		self.controlManager!.selectedVolume 	= item

		self.controlManager!.displaySelectedVolume()
		
		self.presentLoadingActivityIndicator()
		
		// Create completion handler
		let loadVolumeContentDataCompletionHandler: ((VolumeWrapper?, Error?) -> Void) =
		{
			[unowned self] (wrapper, error) -> Void in

			DispatchQueue.main.async {
				
				self.hideLoadingActivityIndicator()
				
				guard (wrapper != nil && error == nil
					&& wrapper!.volumeContentData != nil) else {

					self.hideVolumeReaderView()
					self.presentWatermarkContainerView()
					self.presentOperationFailedAlert()

					return

				}
	
				// Set item in volumeReaderView
				self.volumeReaderView!.set(item: self.controlManager!.selectedVolume!)

				// Show swipeDownMessageView
				if (!VolumeItemDisplayViewController.swipeDownMessageViewShownYN) { self.presentSwipeDownMessageView() }
		
				// Show auto hide view
				self.presentAutoHideViews()
				
			}

		}

		// Load volumeContentData
		self.controlManager!.loadVolumeContentData(for: self.controlManager!.selectedVolume!, oncomplete: loadVolumeContentDataCompletionHandler)

	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager 			= VolumeItemDisplayControlManager()
		
		self.controlManager!.delegate 	= self
		
		self.controlManager!.setUrls(volumeImagesUrlRoot: UrlsHelper.volumeImagesUrlRoot,
									 awardImagesUrlRoot: UrlsHelper.awardImagesUrlRoot,
									 newsSnippetImagesUrlRoot: UrlsHelper.newsSnippetImagesUrlRoot)
		
		// Setup cacheing
		self.controlManager!.setupCacheing(managedObjectContext: CoreDataHelper.getManagedObjectContext())
	}
	
	fileprivate func setupModelManager() {
		
		// Set the model manager
		self.controlManager!.set(modelManager: ModelFactory.modelManager)
		
		// Setup the model administrators
		//ModelFactory.setupArtworkModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
	}
	
	fileprivate func setupViewManager() {
		
		// Create view strategy
		let viewAccessStrategy: VolumeItemDisplayViewAccessStrategy = VolumeItemDisplayViewAccessStrategy()
		
		viewAccessStrategy.setup(numberofLikesLabel: self.numberofLikesLabel,
								 latestVolumeCommentTextLabel: self.latestVolumeCommentTextLabel,
								 latestVolumeCommentPostedByNameLabel: self.latestVolumeCommentPostedByNameLabel,
								 latestVolumeCommentDatePostedLabel: self.latestVolumeCommentDatePostedLabel)
		
		// Setup the view manager
		self.controlManager!.viewManager = VolumeItemDisplayViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setupLoadingActivityIndicator() {
		
		self.loadingActivityIndicator.alpha = 0
		
	}
	
	fileprivate func setupWatermarkContainerView() {
		
		self.watermarkView.layer.cornerRadius 	= 10.0;
		self.watermarkView.layer.borderWidth 	= 10.0;
		self.watermarkView.layer.borderColor 	= UIColor.white.cgColor
		self.watermarkContainerView.isHidden 	= true
		
	}
	
	fileprivate func setupCommentsButtonView() {
		
		UIViewHelper.makeCircle(view: self.commentsButtonView)
		
		UIViewHelper.setShadow(view: self.commentsButtonView)
		
	}
	
	fileprivate func setupLikeButtonView() {
		
		UIViewHelper.makeCircle(view: self.likeButtonView)
		
		UIViewHelper.setShadow(view: self.likeButtonView)
		
	}
	
	fileprivate func setupFadeOutView() {
		
		self.fadeOutView.alpha = 0
	}
	
	fileprivate func setupSwipeDownMessageView() {
		
		// Hide view
		self.swipeDownMessageView.alpha = 0
	}
	
	fileprivate func setupPanGestureHelper() {
		
		self.panGestureHelper = PanGestureHelper(gesture: self.panGestureRecognizer)
		
		self.panGestureHelper!.delegate							= self
		
		self.panGestureHelper!.gestureDownEnableThresholdYN		= true
		self.panGestureHelper!.gestureDownCommitThreshold		= 150
	}
	
	fileprivate func setupLikedVolumeView() {
		
		self.likedVolumeView.layer.cornerRadius 	= 10.0;
		self.likedVolumeView.layer.borderWidth 		= 1.0;
		self.likedVolumeView.layer.borderColor 		= UIColor.lightGray.cgColor

		self.likedVolumeView.layer.masksToBounds 	= true;
		
		// Hide view
		self.likedVolumeView.alpha 					= 0
		
	}
	
	fileprivate func setupLatestVolumeCommentView() {

		self.latestVolumeCommentView.layer.cornerRadius 	= 10.0;
		self.latestVolumeCommentView.layer.borderWidth 		= 1.0;
		self.latestVolumeCommentView.layer.borderColor 		= UIColor.clear.cgColor
		self.latestVolumeCommentView.layer.masksToBounds 	= true;
		
		// Hide view
		self.latestVolumeCommentContainerView.alpha 		= 0
		
	}
	
	fileprivate func setupVolumeReaderView() {
		
		self.volumeReaderView.delegate				= self
		
		// Hide placeholder view which is just used for view in interface builder
		self.volumeReaderPlaceholderView.isHidden	= true
		
		self.volumeReaderView.alpha					= 1
	}
	
	fileprivate func presentLoadingActivityIndicator() {
		
		DispatchQueue.main.async {
			
			self.loadingActivityIndicator.alpha = 1
		}
		
	}
	
	fileprivate func presentWatermarkContainerView() {
		
		self.watermarkContainerView.isHidden = false
	}
	
	fileprivate func presentAutoHideViews() {
		
		// Reset timer
		if self.autoHideViewsTimer != nil {
			self.autoHideViewsTimer?.invalidate()
		}
		
		// Show views
		UIView.animate(withDuration: 0.2) {
			
			self.buttonsRightContainerView.alpha 	= 1
			
		}
		
		// Set timer to hide view
		self.autoHideViewsTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(autoHideViewsTimerAction(_:)), userInfo: nil, repeats: false)
		
	}
	
	fileprivate func presentButtonsRightContainerView() {
		
		// Show view
		UIView.animate(withDuration: 0.2) {
			self.buttonsRightContainerView.alpha = 1
		}
		
	}
	
	fileprivate func presentSwipeDownMessageView() {
		
		guard (VolumeItemDisplayViewController.swipeDownMessageViewShownYN == false) else { return }
		
		VolumeItemDisplayViewController.swipeDownMessageViewShownYN = true
		
		// Reset timer
		if self.hideSwipeDownMessageViewTimer != nil {
			self.hideSwipeDownMessageViewTimer?.invalidate()
		}
		
		// Show view
		UIView.animate(withDuration: 0.2) {
			self.swipeDownMessageView.alpha = 1
		}
		
		// Set timer to hide view
		self.hideSwipeDownMessageViewTimer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(hideSwipeDownMessageViewTimerAction(_:)), userInfo: nil, repeats: false)
		
	}
	
	fileprivate func presentLikedVolumeView() {
		
		self.likedVolumeView.alpha = 0
		
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
			
			self.likedVolumeView.alpha = 1
			
		}) { (completed) in
			
			UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseIn, animations: {
				
				self.likedVolumeView.alpha = 0
				
			}, completion: nil)
			
		}
		
	}
	
	fileprivate func presentVolumeCommentsDisplay() {
		
		guard (self.controlManager!.selectedVolume != nil) else { return }
		
		// Create view controller
		let viewController = storyboard?.instantiateViewController(withIdentifier: "VolumeCommentsDisplay") as? VolumeCommentsDisplayViewController
		
		// Set initial values
		viewController!.set(volumeID: self.controlManager!.selectedVolume!.id)
		
		viewController!.delegate				= self
		viewController!.modalPresentationStyle	= .overCurrentContext
		
		self.presentFadeOutView()
		
		present(viewController!, animated: true, completion: nil)
		
	}
	
	fileprivate func presentFadeOutView() {
		
		// Show view
		UIView.animate(withDuration: 0.1) {
			
			self.fadeOutView.alpha = 1
		}
		
	}
	
	fileprivate func presentLatestVolumeCommentView() {
		
		guard (self.controlManager!.selectedVolume!.latestVolumeCommentText.count > 0) else { return }
		guard (self.latestVolumeCommentContainerView.alpha == 0) else { return }
		
		self.setLatestVolumeCommentViewSize()
		
		self.latestVolumeCommentContainerView.alpha 		= 0
		self.latestVolumeCommentContainerView.transform 	= CGAffineTransform(scaleX: 0.001, y: 0.001)
		self.latestVolumeCommentContainerView.alpha 		= 1
		
		UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
			
			self.latestVolumeCommentContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
			
		}) { _ in
			
			self.latestVolumeCommentContainerView.transform = CGAffineTransform.identity
			
		}
		
	}
	
	fileprivate func hideLoadingActivityIndicator() {
		
		self.loadingActivityIndicator.alpha = 0
		
	}
	
	fileprivate func hideWatermarkContainerView() {
		
		self.watermarkContainerView.isHidden = true
	}
	
	@objc fileprivate func autoHideViewsTimerAction(_ sender:Timer) {
		
		self.hideAutoHideViews(quickAnimationYN: false)
		
	}
	
	fileprivate func hideAutoHideViews(quickAnimationYN: Bool) {
		
		var duration: TimeInterval = 0.3
		
		if (quickAnimationYN) {
			
			duration = 0.1
			
		}
		
		// Hide views
		UIView.animate(withDuration: duration) {
			
			self.buttonsRightContainerView.alpha 	= 0
			
		}
		
	}
	
	@objc fileprivate func hideSwipeDownMessageViewTimerAction(_ sender:Timer) {
		
		// Hide view
		UIView.animate(withDuration: 0.3) {
			self.swipeDownMessageView.alpha = 0
		}
	}
	
	fileprivate func hideButtonsRightContainerView() {
	
		// Hide view
		UIView.animate(withDuration: 0.3) {
			self.buttonsRightContainerView.alpha = 0
		}
		
	}
	
	fileprivate func hideFadeOutView() {
		
		// Hide view
		UIView.animate(withDuration: 0.1) {
			
			self.fadeOutView.alpha = 0
		}
		
	}
	
	fileprivate func hideLatestVolumeCommentView() {
		
		guard (self.latestVolumeCommentContainerView.alpha == 1) else { return }
		
		UIView.animate(withDuration: 0.1) {
			
			self.latestVolumeCommentContainerView.alpha 	= 0
			
		}
		
	}
	
	fileprivate func hideVolumeReaderView() {
	
		self.volumeReaderView.alpha = 0
		
	}
	
	fileprivate func setLatestVolumeCommentViewSize() {
		
		guard (self.controlManager!.selectedVolume!.latestVolumeCommentText.count > 0) else { return }
		
		let latestVolumeCommentViewPadding:						CGFloat = 10
		let quoteBubblePointImageViewHeight:					CGFloat = 18
		let postedByNameLabelTopSpacing: 						CGFloat = 5
		let postedByNameLabelHeight:							CGFloat = 18
		let latestVolumeCommentContainerViewBottomSpacing:		CGFloat = 20
		
		// Get default label width
		var labelWidth: 			CGFloat = self.latestVolumeCommentContainerViewDefaultWidth - latestVolumeCommentViewPadding - latestVolumeCommentViewPadding
		
		// Get height from top of latestVolumeCommentContainerView to bottom of view
		let heightFromLatestVolumeCommentContainerViewTop:		CGFloat = self.view.frame.size.height -  self.latestVolumeCommentContainerView.frame.origin.y
		
		// Get available label height
		let availableLabelHeight: 	CGFloat = heightFromLatestVolumeCommentContainerViewTop - latestVolumeCommentContainerViewBottomSpacing - latestVolumeCommentViewPadding - postedByNameLabelHeight - postedByNameLabelTopSpacing - latestVolumeCommentViewPadding - quoteBubblePointImageViewHeight
		
		// Get required label height for default label width
		let requiredLabelHeight: 	CGFloat = UILabelHelper.getHeightToFit(label: self.latestVolumeCommentTextLabel, maxWidth: labelWidth)
		
		// Check required label height less than available label height
		if (requiredLabelHeight > availableLabelHeight) {
			
			// Get required label width for available label height
			labelWidth = UILabelHelper.getWidthToFit(label: self.latestVolumeCommentTextLabel, maxHeight: availableLabelHeight)
			
		}
		
		// Get latestVolumeCommentContainerViewMaxWidth
		let latestVolumeCommentContainerViewMaxWidth: CGFloat = self.view.frame.size.width - 30
		
		// Set width layout constraint
		self.latestVolumeCommentContainerViewWidthConstraint.constant = min((labelWidth + latestVolumeCommentViewPadding + latestVolumeCommentViewPadding), latestVolumeCommentContainerViewMaxWidth)
		
		self.view.layoutIfNeeded()
		
	}
	
	fileprivate func presentIsNotConnectedAlert() {
		
		guard (!self.isNotConnectedAlertIsShownYN) else { return }
		
		self.isNotConnectedAlertIsShownYN = true
		
		// Create completion handler
		let completionHandler: ((UIAlertAction?) -> Void) =
		{
			[unowned self] (action) -> Void in
			
			self.isNotConnectedAlertIsShownYN = false
			
		}
		
		let alertTitle: 	String = NSLocalizedString("AlertTitleNotConnected", comment: "")
		let alertMessage: 	String = NSLocalizedString("AlertMessageNotConnected", comment: "")
		
		UIAlertControllerHelper.presentAlert(alertTitle: alertTitle, alertMessage: alertMessage, oncomplete: completionHandler)
		
	}
	
	fileprivate func presentOperationFailedAlert() {
		
		let alertTitle: 	String = NSLocalizedString("AlertTitleOperationFailed", comment: "")
		let alertMessage: 	String = NSLocalizedString("AlertMessageOperationFailed", comment: "")
		
		UIAlertControllerHelper.presentAlert(alertTitle: alertTitle, alertMessage: alertMessage, oncomplete: nil)
		
	}
	
	
	// MARK: - commentsButton TapGestureRecognizer Methods
	
	@IBAction func commentsButtonTapped(_ sender: Any) {
		
		self.presentVolumeCommentsDisplay()
		
	}
	
	
	// MARK: - likeButton TapGestureRecognizer Methods
	
	@IBAction func likeButtonTapped(_ sender: Any) {
		
		// Check is connected
		guard (self.controlManager!.checkIsConnected()) else { return }
		
		// Present liked volume view
		self.presentLikedVolumeView()
		
		// Like volume
		self.controlManager!.likeVolume()
		
		self.controlManager!.displayNumberofLikes()
		
	}
	
	
	// MARK: - latestVolumeCommentView TapGestureRecognizer Methods
	
	@IBAction func latestVolumeCommentViewTapped(_ sender: Any) {
		
		// Hide latest artwork comment view
		self.hideLatestVolumeCommentView()
		
	}
	
	
	// MARK: - contentView TapGestureRecognizer Methods
	
	@IBAction func contentViewTapped(_ sender: Any) {
		
		self.presentAutoHideViews()
		
	}
	
}


// MARK: - Extension ProtocolVolumesControlManagerBaseDelegate

extension VolumeItemDisplayViewController: ProtocolVolumesControlManagerBaseDelegate {

	// MARK: - Public Methods
	
	public func volumesControlManagerBase(isNotConnected error: Error?) {
		
		self.presentIsNotConnectedAlert()
		
	}
	
	public func volumesControlManagerBase(signInFailed sender: VolumesControlManagerBase) {
		
	}
	
	public func volumesControlManagerBase(volumeImagesUrlRoot sender: VolumesControlManagerBase) -> String {
		
		let result: String = NSLocalizedString("VolumeImagesUrlRoot", tableName: "Urls", comment: "")
		
		return result
		
	}
	
	public func volumesControlManagerBase(awardImagesUrlRoot sender: VolumesControlManagerBase) -> String {
		
		let result: String = NSLocalizedString("AwardImagesUrlRoot", tableName: "Urls", comment: "")
		
		return result
		
	}
	
	public func volumesControlManagerBase(newsSnippetImagesUrlRoot sender: VolumesControlManagerBase) -> String {
		
		let result: String = NSLocalizedString("NewsSnippetImagesUrlRoot", tableName: "Urls", comment: "")
		
		return result
		
	}
	
}


// MARK: - Extension ProtocolVolumeItemDisplayControlManagerDelegate

extension VolumeItemDisplayViewController: ProtocolVolumeItemDisplayControlManagerDelegate {
	
	// MARK: - Public Methods
	
}


// MARK: - Extension ProtocolPanGestureHelperDelegate

extension VolumeItemDisplayViewController: ProtocolPanGestureHelperDelegate {
	
	// MARK: - Public Methods
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes) {
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes) {
		
		// Check if moving down
		if (attributes.direction == .down) {
			
			// Move view position
			self.view.frame = CGRect(x: 0, y: attributes.currentTouchPoint.y - attributes.initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes) {
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes) {
		
		// Check if moving down
		if (attributes.direction == .down) {
			
			// Notify the delegate
			self.delegate?.volumeItemDisplayViewController(didDismiss: self)
			
			self.volumeReaderView!.clearView()
			
			// Dismiss view
			dismiss(animated: true, completion: nil)
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes) {
		
		// Check if moving down
		if (attributes.direction == .down) {
			
			// Reset view position
			UIView.animate(withDuration: 0.3, animations: {
				
				self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
				
			})
		}
		
	}
	
}


// MARK: - Extension ProtocolVolumeCommentsDisplayViewControllerDelegate

extension VolumeItemDisplayViewController: ProtocolVolumeCommentsDisplayViewControllerDelegate {
	
	// MARK: - Methods
	
	public func volumeCommentsDisplayViewController(didDismiss sender: VolumeCommentsDisplayViewController) {
		
		self.hideFadeOutView()
		
	}
	
	public func volumeCommentsDisplayViewController(didPostComment sender: VolumeCommentsDisplayViewController) {
		
		// Display latest comment
		self.controlManager!.displayLatestVolumeComment()
		
		self.presentLatestVolumeCommentView()
		
	}
	
}


// MARK: - Extension ProtocolVolumeReaderViewDelegate

extension VolumeItemDisplayViewController: ProtocolVolumeReaderViewDelegate {
	
	// MARK: - Methods
	
	public func volumeReaderView(sender: VolumeReaderView, loadAssetsImageDataForItem item: VolumeWrapper, byGroupKey groupKey: String, oncomplete completionHandler:@escaping (VolumeWrapper, Error?) -> Void) {

		// Create completion handler
		let loadVolumeAssetsImageDataCompletionHandler: ((VolumeWrapper, Error?) -> Void) =
		{
			(item, error) -> Void in	// [unowned self]

			// Call completion handler
			completionHandler(item, error)
			
		}

		self.controlManager!.loadVolumeAssetsImageData(for: item, byGroupKey: groupKey, oncomplete: loadVolumeAssetsImageDataCompletionHandler)
		
	}
	
	public func volumeReaderView(sender: VolumeReaderView, willTransitionTo pageWrapper: VolumePageWrapper) {
	
		self.hideAutoHideViews(quickAnimationYN: true)

	}
	
	public func volumeReaderView(for gesture:UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes) {
		
		self.panGestureHelper(for: gesture, panningStartedWith: attributes)
	}
	
	public func volumeReaderView(for gesture:UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes) {
		
		self.panGestureHelper(for: gesture, panningContinuedWith: attributes)
	}
	
	public func volumeReaderView(for gesture:UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes) {
		
		self.panGestureHelper(for: gesture, panningStoppedAfterThresholdWith: attributes)
	}
	
	public func volumeReaderView(for gesture:UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes) {
		
		self.panGestureHelper(for: gesture, panningStoppedBeforeThresholdWith: attributes)
	}
	
	public func volumeReaderView(for gesture:UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes) {
		
		// Check if moving down
		if (attributes.direction == .down) {
			
			// Check verticalDistance
			if (attributes.verticalDistance >= self.panGestureHelper!.gestureDownCommitThreshold) {
				
				self.panGestureHelper(for: gesture, panningStoppedAfterThresholdWith: attributes)
				
			} else {
				
				self.panGestureHelper(for: gesture, panningStoppedBeforeThresholdWith: attributes)
			}
			
		} else {
			
			self.panGestureHelper(for: gesture, panningStoppedWith: attributes)
		}
		
	}

}
