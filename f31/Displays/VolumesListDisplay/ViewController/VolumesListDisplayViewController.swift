//
//  VolumesListDisplayViewController.swift
//  f31
//
//  Created by David on 29/05/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import CoreData
import UIKit
import SFView
import SFCore
import f31Core
import f31Model
import f31View
import f31Controller

/// A ViewController for the VolumesListDisplay
class VolumesListDisplayViewController: UIViewController {
	
	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:											VolumesListDisplayControlManager?
	fileprivate var isNotConnectedAlertIsShownYN:							Bool = false
	fileprivate var hasViewAppearedYN:										Bool = false
	fileprivate var isDataViewAtBottomZoneYN:								Bool = false
	fileprivate var isInitialLoadCompleteYN:								Bool = false
	fileprivate var isAwardsLoadedYN:										Bool = false
	fileprivate var isNewsSnippetsLoadedYN:									Bool = false
	fileprivate let minNumberofItemsOutOfView:								Int = 4
	fileprivate var dashboardMenuViewIsShownYN:								Bool = false
	fileprivate var viewWillTransitionYN: 									Bool = false
	fileprivate let awardsBarViewMaximumWidth:								CGFloat = 600
	fileprivate let awardsBarViewEqualWidthLayoutConstraintConstant:		CGFloat = -200
	fileprivate let awardsBarViewPadding:									CGFloat = 20
	fileprivate let awardsBarViewContainerViewPadding:						CGFloat = 10
	fileprivate var newsBarViewLeftLayoutConstraintOffset:					CGFloat = 0
	fileprivate var setVolumesCollectionViewRightLayoutConstraintYN:		Bool = false
	fileprivate var volumesCollectionViewRightLayoutConstraintDefault:		CGFloat = 0
	fileprivate var panGestureHelper:										PanGestureHelper?
	fileprivate var screenEdgePanGestureHelper:								PanGestureHelper?
	
	
	// MARK: - Public Stored Properties
	
	@IBOutlet weak var volumesCollectionView:								UICollectionView!
	@IBOutlet weak var volumesCollectionViewRightLayoutConstraint: 			NSLayoutConstraint!
	@IBOutlet weak var newsBarView: 										NewsBarView!
	@IBOutlet weak var newsBarPlaceholderView: 								UIView!
	@IBOutlet weak var newsBarViewLeftLayoutConstraint:						NSLayoutConstraint!
	@IBOutlet weak var newsBarViewWidthLayoutConstraint:					NSLayoutConstraint!
	@IBOutlet weak var newsBarViewPanGestureRecognizer: 					UIPanGestureRecognizer!
	@IBOutlet var screenEdgePanGestureRecogniser: 							UIScreenEdgePanGestureRecognizer!
	@IBOutlet weak var dashboardBarView:									DashboardBarView!
	@IBOutlet weak var dashboardBarPlaceholderView:							UIView!
	@IBOutlet weak var dashboardBarViewHeightLayoutConstraint:				NSLayoutConstraint!
	@IBOutlet weak var dashboardMenuView:									DashboardMenuView!
	@IBOutlet weak var dashboardMenuPlaceholderView:						UIView!
	@IBOutlet weak var dashboardMenuViewTopLayoutConstraint:				NSLayoutConstraint!
	@IBOutlet weak var dashboardMenuViewBottomLayoutConstraint:				NSLayoutConstraint!
	@IBOutlet weak var activityIndicatorView: 								UIView!
	@IBOutlet weak var likedVolumeView: 									UIView!
	@IBOutlet weak var fadeOutView: 										UIView!
	@IBOutlet weak var awardsButtonView: 									UIView!
	@IBOutlet weak var awardsBarView: 										AwardsBarView!
	@IBOutlet weak var awardsBarPlaceholderView: 							UIView!
	@IBOutlet weak var awardsBarViewEqualWidthLayoutConstraint: 			NSLayoutConstraint!
	@IBOutlet weak var awardsBarViewHeightLayoutConstraint: 				NSLayoutConstraint!
	

	// MARK: - Override Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
	
		// DEBUG:
		SettingsManager.set(bool: true, forKey: "\(SettingsKeys.isSignedInYN)")
		
        // Do any additional setup after loading the view.
		self.setup()
		
		self.checkIsSignedIn()
		self.setupPanGestureHelper()
		self.setupVolumesCollectionView()
		self.setupNewsBarView()
		self.setupDashboardMenuView()
		self.setupDashboardBarView()
		self.setupAwardsBarView()
		self.setupLikedVolumeView()
		self.setupAwardsButtonView()
		self.setupActivityIndicatorView()
		self.setupFadeOutView()
		
    }

	override func viewDidAppear(_ animated: Bool) {
		
		self.hasViewAppearedYN = true

		self.presentActivityIndicatorView(animateYN: false)
		
		self.setAwardsBarViewWidth()
		
		self.loadVolumes(toFillYN: true)
		
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		// Call invalidateLayout to make sure layout is updated
		self.volumesCollectionView.collectionViewLayout.invalidateLayout()

		// When transition complete
		coordinator.animate(alongsideTransition: nil) { _ in
		
			if (self.hasViewAppearedYN) {
				
				// Set newsBarView LeftLayoutConstraint
				self.setNewsBarViewLeftLayoutConstraint()
				
				// Determine default and flag whether to set volumesCollectionView RightLayoutConstraint
				self.setVolumesCollectionViewRightLayoutConstraintDefault()
				self.checkSetVolumesCollectionViewRightLayoutConstraintYN()
				
				// Set volumesCollectionView RightLayoutConstraint
				self.setVolumesCollectionViewRightLayoutConstraint(setToDefaultYN: false)
				
				// Refresh volumesCollectionView layout
				self.refreshVolumesCollectionViewLayout()
				
				// Correct newsBarView scroll position
				self.newsBarView.correctOverScroll()
			}
			
		}
		
		self.viewWillTransitionYN = true

	}

	override func viewDidLayoutSubviews() {
		
		if (!self.hasViewAppearedYN) {
			
			// Determine default and flag whether to set volumesCollectionView RightLayoutConstraint
			self.setVolumesCollectionViewRightLayoutConstraintDefault()
			self.checkSetVolumesCollectionViewRightLayoutConstraintYN()
			
			if (!self.setVolumesCollectionViewRightLayoutConstraintYN && self.controlManager!.isSignedInYN) {
				
				self.setNewsBarViewPresented()
				
			} else {
				
				self.setNewsBarViewHidden()
				
			}
			
		}

		// Refresh awardsBarView
		if (self.viewWillTransitionYN && self.awardsBarView!.isShownYN) {
			
			self.view.layoutIfNeeded()
			
			self.setAwardsBarViewWidth()
			
			self.awardsBarView.refreshView()
			
		}

		self.viewWillTransitionYN = false
		
	}
	
	
	// MARK: - Public Methods
	
	public func setNewsBarViewHidden() {
		
		self.newsBarView.alpha 		= 0
		
		self.newsBarView.isShownYN 	= false
		
		self.setNewsBarViewLeftLayoutConstraint()
		
		self.dashboardBarView.set(newsBarIsSelectedYN: self.newsBarView.isShownYN, animateYN: false)
		
	}
	
	public func setNewsBarViewPresented() {
		
		// Check isSignedInYN
		guard (self.controlManager!.isSignedInYN) else { return }
		
		self.newsBarView.alpha = 1
		
		// Set newsBarView LeftLayoutConstraint
		self.newsBarViewLeftLayoutConstraint!.constant	= 0 + self.newsBarViewLeftLayoutConstraintOffset
		
		self.newsBarView.isShownYN = true
		
		self.dashboardBarView.set(newsBarIsSelectedYN: self.newsBarView.isShownYN, animateYN: false)
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
		
		self.setDebugFlags()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager 			= VolumesListDisplayControlManager()
		
		self.controlManager!.delegate 	= self
		
		self.controlManager!.setUrls(volumeImagesUrlRoot: UrlsHelper.volumeImagesUrlRoot,
									 awardImagesUrlRoot: UrlsHelper.awardImagesUrlRoot,
									 newsSnippetImagesUrlRoot: UrlsHelper.newsSnippetImagesUrlRoot)
		
		// Setup cacheing
		self.controlManager!.setupCacheing(managedObjectContext: CoreDataHelper.getManagedObjectContext())
		
		// Setup authentication
		self.controlManager!.setupAuthentication()
		
	}
	
	fileprivate func setupModelManager() {
		
		// Set the model manager
		self.controlManager!.set(modelManager: ModelFactory.modelManager)
		
		// Setup the model administrators
		ModelFactory.setupVolumeModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
		ModelFactory.setupAwardModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
		ModelFactory.setupNewsSnippetModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
	}
	
	fileprivate func setupViewManager() {
		
		// Create view strategy
		let viewAccessStrategy: VolumesListDisplayViewAccessStrategy = VolumesListDisplayViewAccessStrategy()
		
		viewAccessStrategy.setup(awardsBarView: self.awardsBarView)
		
		// Setup the view manager
		self.controlManager!.viewManager = VolumesListDisplayViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setDebugFlags() {
		
		#if DEBUG
				
			ApplicationFlags.flag(key: "SkipCheckIsConnectedYN", value: false)
			ApplicationFlags.flag(key: "LoadVolumesDummyDataYN", value: false)
			ApplicationFlags.flag(key: "LoadVolumeCommentsDummyDataYN", value: false)
			ApplicationFlags.flag(key: "LoadAwardsDummyDataYN", value: false)
			ApplicationFlags.flag(key: "LoadNewsSnippetsDummyDataYN", value: false)
			ApplicationFlags.flag(key: "AddLikeDummyDataYN", value: false)
			ApplicationFlags.flag(key: "GetVolumeContentDataDummyDataYN", value: false)
			ApplicationFlags.flag(key: "SaveVolumeCommentDummyDataYN", value: false)
			
		#endif
		
	}
	
	fileprivate func checkIsSignedIn() {
	
		_ = self.controlManager!.checkIsSignedIn()
	}
	
	fileprivate func setupActivityIndicatorView() {
		
		self.activityIndicatorView.alpha 	= 0
	}
	
	fileprivate func setupFadeOutView() {

		self.fadeOutView.alpha 				= 0
	}
	
	fileprivate func setupPanGestureHelper() {
		
		// panGestureHelper
		self.panGestureHelper											= PanGestureHelper(gesture: self.newsBarViewPanGestureRecognizer)
		
		self.panGestureHelper!.delegate									= self
	
		self.panGestureHelper?.gestureLeftEnableThresholdYN				= true
		self.panGestureHelper?.gestureLeftCommitThreshold				= 80
		
		// screenEdgePanGestureHelper
		self.screenEdgePanGestureHelper 								= PanGestureHelper(gesture: self.screenEdgePanGestureRecogniser)
		self.screenEdgePanGestureHelper!.delegate 						= self

		self.screenEdgePanGestureHelper?.gestureRightEnableThresholdYN	= true
		self.screenEdgePanGestureHelper?.gestureRightCommitThreshold	= 80
		
	}
	
	fileprivate func setupNewsBarView() {
		
		self.newsBarView.delegate				= self
		
		// Hide placeholder view which is just used for view in interface builder
		self.newsBarPlaceholderView.isHidden	= true
		
	}
	
	fileprivate func setupDashboardBarView() {
		
		self.dashboardBarView.delegate				= self
		
		// Hide placeholder view which is just used for view in interface builder
		self.dashboardBarPlaceholderView.isHidden	= true
	
		self.dashboardBarView.set(year: self.controlManager!.selectedYear)
		self.dashboardBarView.set(daughter: self.controlManager!.selectedDaughter)
		
		self.dashboardBarView.set(newsBarIsSelectedYN: self.newsBarView.isShownYN, animateYN: false)
	}
	
	fileprivate func setupDashboardMenuView() {
	
		self.dashboardMenuView.delegate								= self
		
		// Hide placeholder view which is just used for view in interface builder
		self.dashboardMenuPlaceholderView.isHidden					= true
		
		// Hide dashboardMenuView
		self.dashboardMenuView.isHidden								= true
		
		// Set offset to fit under dashboardBoardBarView
		self.dashboardMenuView.menuViewTopLayoutConstraintOffset	= self.dashboardBarViewHeightLayoutConstraint.constant
		
		// Layout dashboardMenuView to fill superview
		self.dashboardMenuViewTopLayoutConstraint.constant			= 0
		self.dashboardMenuViewBottomLayoutConstraint.constant		= 0
		
		// Populate years and set selected year
		self.dashboardMenuView.populate(years: self.controlManager!.getYears())
		self.dashboardMenuView.set(year: self.controlManager!.selectedYear)
		
	}
	
	fileprivate func setupAwardsBarView() {
		
		self.awardsBarView.delegate				= self
		
		// Hide placeholder view which is just used for view in interface builder
		self.awardsBarPlaceholderView.isHidden	= true
		
		self.awardsBarView.isHidden				= true
		self.awardsBarView.hide(animateYN: false)
		
	}
	
	fileprivate func setupVolumesCollectionView() {
		
		volumesCollectionView!.delegate		= self
		volumesCollectionView!.dataSource	= self
		
		// Set layout delegate
		if let layout = volumesCollectionView?.collectionViewLayout as? SFCollectionViewLayout {
			layout.delegate					= self
			
			layout.dynamicCellWidthYN		= true
			layout.cellPadding				= 10

		}

		// Setup collectionView
		self.automaticallyAdjustsScrollViewInsets	= false
		
		volumesCollectionView!.backgroundColor		= UIColor.clear
		volumesCollectionView!.contentInset			= UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)

	}
	
	fileprivate func setupAwardsButtonView() {
		
		UIViewHelper.makeCircle(view: self.awardsButtonView)
		
		UIViewHelper.setShadow(view: self.awardsButtonView)
		
		self.awardsButtonView.isHidden 				= true
		
	}
	
	fileprivate func clearVolumesCollectionView(oncomplete completionHandler: ((Error?) -> Void)?) {
		
		// Check items exist
		guard (self.volumesCollectionView.numberOfItems(inSection: 0) > 0) else {
			
			// Call completion handler
			completionHandler?(nil)
			
			return
		}
		
		// Check not scrolling
		self.abortVolumesCollectionViewScroll()
		
		// Create index paths for items to be deleted
		var indexPaths:	[IndexPath] = [IndexPath]()
		let firstIndex:	Int			= 0
		
		for i in 0...self.volumesCollectionView.numberOfItems(inSection: 0) - 1 {
			
			indexPaths.append(IndexPath(item: firstIndex + i, section: 0))
		}
		
		DispatchQueue.main.async(execute: {
			
			self.volumesCollectionView.collectionViewLayout.invalidateLayout()
			
			// Delete layout attributes
			if let layout = self.volumesCollectionView?.collectionViewLayout as? SFCollectionViewLayout {
				layout.deleteAttributes(at: indexPaths)
			}
			
			self.volumesCollectionView.deleteItems(at: indexPaths)
			
			// Call completion handler
			completionHandler?(nil)
		})
		
	}
	
	fileprivate func loadVolumes(toFillYN: Bool) {
		
		// Create completion handler
		let loadVolumesCompletionHandler: (([VolumeWrapper], Error?) -> Void) =
		{
			(items, error) -> Void in
			
			self.hideActivityIndicatorView()
			
			// Check number of items loaded
			guard (items.count > 0) else {
				
				self.isInitialLoadCompleteYN = true
				
				// Load awards
				self.loadAwards(presentAwardsViewYN: true)
				
				// Load news snippets
				self.loadNewsSnippets()
				
				return
			}
			
			// Create index paths for items to be inserted
			var indexPaths:	[IndexPath] = [IndexPath]()
			let firstIndex:	Int			= VolumeWrappers.items.count - items.count
		
			for i in 0...items.count - 1 {
				
				indexPaths.append(IndexPath(item: firstIndex + i, section: 0))
			}
			
			// Refresh collection view
			DispatchQueue.main.async(execute: {

				// Call invalidateLayout to make sure layout is updated
				self.volumesCollectionView.collectionViewLayout.invalidateLayout()

				self.volumesCollectionView.insertItems(at: indexPaths)
				
				// Check shouldLoadMoreVolumes
				if (toFillYN && self.shouldLoadMoreVolumes()) {
					
					self.loadVolumes(toFillYN: true)
					
				} else {
					
					self.isInitialLoadCompleteYN = true
					
					// Load awards
					self.loadAwards(presentAwardsViewYN: true)
					
					// Load news snippets
					self.loadNewsSnippets()
					
				}
			})
		}
		
		self.controlManager!.loadVolumes(selectItemsAfterPreviousYN: true, oncomplete: loadVolumesCompletionHandler)
	}
	
	fileprivate func shouldLoadMoreVolumes() -> Bool {
		
		// Check state
		guard ( self.hasViewAppearedYN						== true &&
				self.controlManager!.isLoadingDataYN		== false &&
				VolumeWrappers.hasLoadedAllNextItemsYN		== false) else {
				return false
		}

		var result = false
		
		// Check numberofItemsOutOfView
		if (self.numberofItemsOutOfView() < self.minNumberofItemsOutOfView) {
			result = true
		}
		
		// Check initial load complete
		if (self.isInitialLoadCompleteYN == false && result == false) {
			self.isInitialLoadCompleteYN = true
		}
		
		return result
	}
	
	fileprivate func numberofItemsOutOfView() -> Int {
		
		var result = 0
		
		// Get numberofItemsOutOfView
		var lastVisibleIndexPath: IndexPath?	= nil
		
		for (_, indexPath) in self.volumesCollectionView.indexPathsForVisibleItems.enumerated() {
			
			// Get index path with highest index
			if (lastVisibleIndexPath == nil || indexPath.item > lastVisibleIndexPath!.item) {
				lastVisibleIndexPath = indexPath
			}
		}
		
		if (lastVisibleIndexPath != nil) {
			
			let lastIndex: Int = VolumeWrappers.items.count - 1
			result = lastIndex - lastVisibleIndexPath!.item
		}

		return result
	}
	
	fileprivate func presentVolumeItemDisplay(item: VolumeWrapper) {

		// Create view controller
		let viewController = storyboard?.instantiateViewController(withIdentifier: "VolumeItemDisplay") as? VolumeItemDisplayViewController

		viewController!.delegate				= self
		viewController!.modalPresentationStyle	= .overCurrentContext

		present(viewController!, animated: true, completion: nil)

		// Set initial values
		viewController!.set(item: item,
							selectedDaughter: self.controlManager!.selectedDaughter,
							selectedYear: self.controlManager!.selectedYear)
		
	}

	fileprivate func presentSignInAlert(onSignInSuccessful completionHandler: ((Error?) -> Void)?) {
		
		// Create completion handler
		let enterTappedCompletionHandler: ((String?) -> Void) =
		{
			(text) -> Void in
			
			if (text != nil && text!.count > 0) {
				
				// Sign in
				self.controlManager!.signIn(password: text!, onSignInSuccessful: completionHandler)
				
			} else {
				
				self.presentSignInAlert(onSignInSuccessful: completionHandler)
				
			}

		}
		
		let alertTitle:     			String = NSLocalizedString("AlertTitleSignIn", comment: "")
		let alertMessage:   			String = NSLocalizedString("AlertMessageSignIn", comment: "")
		
		// Create alertController
		let alertController: 			UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
		
		// Create password textField
		alertController.addTextField { (textField: UITextField) in
			
			textField.placeholder 		= NSLocalizedString("AlertMessageSignInPasswordPlaceholder", comment: "")
			textField.keyboardType 		= .default
			textField.isSecureTextEntry = true
		}
		
		// Create 'Cancel' action
		let cancelAlertActionTitle: 	String = NSLocalizedString("AlertActionTitleCancel", comment: "")
		let cancelAlertAction:			UIAlertAction = UIAlertAction(title: cancelAlertActionTitle, style: .cancel, handler: { (action: UIAlertAction) in
			
			self.dashboardBarView.set(newsBarIsSelectedYN: false, animateYN: true)
			
		})
		alertController.addAction(cancelAlertAction)
		
		// Create 'Enter' action
		let enterAlertActionTitle: 		String = NSLocalizedString("AlertActionTitleEnter", comment: "")
		let enterAlertAction:			UIAlertAction = UIAlertAction(title: enterAlertActionTitle, style: .default, handler: { (action: UIAlertAction) in
			
			// Get textField
			let textField: 				UITextField? = alertController.textFields?.first
			
			// Call completion handler
			enterTappedCompletionHandler(textField?.text)
			
		})
		alertController.addAction(enterAlertAction)
		
		DispatchQueue.main.async {
			
			// Present alertController
			UIViewControllerHelper.getPresentedViewController().present(alertController, animated: true, completion: nil)
			
		}
		
		
	}
	
	fileprivate func switchNewsBarView() {
		
		// Create completion handler
		let signInSuccessfulCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Load news snippets
			self.loadNewsSnippets()
			
			self.presentNewsBarView()
			
		}
		
		// If newsBarView is not shown then show, otherwise hide
		if (!self.newsBarView.isShownYN) {

			if (!self.controlManager!.isSignedInYN) {
				
				// Check signed in
				self.checkIsSignedIn()
				
			}
			
			// If not signed in present sign in alert
			if (!self.controlManager!.isSignedInYN) {
	
				self.presentSignInAlert(onSignInSuccessful: signInSuccessfulCompletionHandler)
				
			} else {
				
				self.presentNewsBarView()
				
			}
			
		}
		else {
			
			self.hideNewsBarView()
			
		}
	}
	
	fileprivate func presentNewsBarView() {
		
		// Check isSignedInYN
		guard (self.controlManager!.isSignedInYN) else { return }
		
		self.newsBarView.isShownYN = true
		
		self.doPresentNewsBarViewAnimation(refreshVolumesCollectionViewLayoutYN: true)

	}
	
	fileprivate func hideNewsBarView() {
		
		self.newsBarView.isShownYN = false
		
		self.doHideNewsBarViewAnimation(refreshVolumesCollectionViewLayoutYN: true)
		
	}
	
	fileprivate func doPresentNewsBarViewAnimation(refreshVolumesCollectionViewLayoutYN: Bool) {

		// Check isSignedInYN
		guard (self.controlManager!.isSignedInYN) else { return }
		
		self.newsBarView.alpha = 1
		
		UIView.animate(withDuration: 0.3, animations: {
			
			// Set newsBarView LeftLayoutConstraint
			self.newsBarViewLeftLayoutConstraint!.constant	= 0 + self.newsBarViewLeftLayoutConstraintOffset
			
			// Set volumesCollectionView RightLayoutConstraint
			self.setVolumesCollectionViewRightLayoutConstraint(setToDefaultYN: false)
			
			if (refreshVolumesCollectionViewLayoutYN) {
			
				// Call invalidateLayout to make sure layout is updated
				self.volumesCollectionView.collectionViewLayout.invalidateLayout()
				
				// Refresh volumesCollectionView layout
				//self.refreshVolumesCollectionViewLayout()
				
			}
			
			self.view.layoutIfNeeded()
			
		}) { (completedYN) in
			
			if (refreshVolumesCollectionViewLayoutYN) {

				// Refresh volumesCollectionView layout
				self.refreshVolumesCollectionViewLayout()

			}

		}
		
	}
	
	fileprivate func doHideNewsBarViewAnimation(refreshVolumesCollectionViewLayoutYN: Bool) {
		
		UIView.animate(withDuration: 0.3, animations: {

			// Set newsBarView LeftLayoutConstraint
			self.newsBarViewLeftLayoutConstraint!.constant	= (0 + self.newsBarViewLeftLayoutConstraintOffset) - self.newsBarViewWidthLayoutConstraint!.constant
			
			// Set volumesCollectionView RightLayoutConstraint to default value
			self.setVolumesCollectionViewRightLayoutConstraint(setToDefaultYN: true)

			if (refreshVolumesCollectionViewLayoutYN) {
				
				// Call invalidateLayout to make sure layout is updated
				self.volumesCollectionView.collectionViewLayout.invalidateLayout()
				
				// Refresh volumesCollectionView layout
				//self.refreshVolumesCollectionViewLayout()
				
			}
			
			self.view.layoutIfNeeded()
			
		}) { (completedYN) in
	
			self.newsBarView.alpha = 0
			
			if (refreshVolumesCollectionViewLayoutYN) {
				
				// Refresh volumesCollectionView layout
				self.refreshVolumesCollectionViewLayout()
			
			}
			
		}
		
	}
	
	fileprivate func switchDashboardMenuView() {
		
		// If dashboardMenuView is not shown then show, otherwise hide
		if (!self.dashboardMenuViewIsShownYN) {
			
			self.dashboardMenuViewIsShownYN = true
			self.dashboardMenuView.presentMenu()
		}
		else {
			self.dashboardMenuViewIsShownYN = false
			self.dashboardMenuView.dismissMenu()
		}
	}
	
	fileprivate func abortVolumesCollectionViewScroll() {
		
		if (self.volumesCollectionView.isDragging || self.volumesCollectionView.isDecelerating) {
			
			self.volumesCollectionView.setContentOffset(self.volumesCollectionView.contentOffset, animated: false)
		}
	}
	
	fileprivate func createVolumesCollectionViewCell(for dataItem: VolumeWrapper, at indexPath: IndexPath) -> VolumesCollectionViewCell {
	
		let cell = self.volumesCollectionView.dequeueReusableCell(withReuseIdentifier: "VolumesCollectionViewCell", for: indexPath) as! VolumesCollectionViewCell

		cell.delegate = self

		// Set the item in the cell
		cell.set(item: dataItem)
		
		// Load coverThumbnailImage
		if (dataItem.coverThumbnailImageData == nil && dataItem.coverThumbnailImageFileName.count > 0) {
			
			self.loadCoverThumbnailImage(for: dataItem, in: cell, indexPath: indexPath)
			
		}
		
		cell.layoutIfNeeded()
		
		return cell
		
	}
	
	fileprivate func loadCoverThumbnailImage(for dataItem: VolumeWrapper, in cell: VolumesCollectionViewCell, indexPath: IndexPath) {
		
		guard (dataItem.coverThumbnailImageFileName.count > 0) else { return }
		
		// Create completion handler
		let loadVolumeCoverThumbnailImageDataCompletionHandler: ((Data?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			guard (data != nil) else {
				
				cell.set(coverThumbnailImage: nil)
				
				return
				
			}
			
			// Create coverThumbnailImage
			let coverThumbnailImage: UIImage? = UIImage(data: data!)
			
			if (coverThumbnailImage != nil) {
				
				DispatchQueue.main.async {
					
					// Set coverThumbnailImage
					cell.set(coverThumbnailImage: coverThumbnailImage!)
				}
				
			} else {
				
				cell.set(coverThumbnailImage: nil)
			}
		}
		
		self.controlManager!.loadVolumeCoverThumbnailImageData(for: dataItem, oncomplete: loadVolumeCoverThumbnailImageDataCompletionHandler)
		
	}
	
	fileprivate func presentActivityIndicatorView(animateYN: Bool) {
		
		if (animateYN) {
			
			// Show view
			UIView.animate(withDuration: 0.3) {
				
				self.activityIndicatorView.alpha 	= 1
			}
			
		} else {
			
			self.activityIndicatorView.alpha 		= 1
		}
		
	}
	
	fileprivate func hideActivityIndicatorView() {
		
		DispatchQueue.main.async {
			
			guard (self.activityIndicatorView.alpha != 0) else { return }
			
			// Hide view
			UIView.animate(withDuration: 0.3) {
				
				self.activityIndicatorView.alpha 	= 0
			}
			
		}
	}
	
	fileprivate func setupLikedVolumeView() {
		
		self.likedVolumeView.layer.cornerRadius 	= 10.0;
		self.likedVolumeView.layer.borderWidth 		= 1.0;
		self.likedVolumeView.layer.borderColor 		= UIColor.lightGray.cgColor
		self.likedVolumeView.layer.masksToBounds 	= true;
		
		// Hide view
		self.likedVolumeView.alpha 					= 0
		
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

	fileprivate func presentVolumeCommentsDisplay(volumeID: String) {
		
		// Create view controller
		let viewController = storyboard?.instantiateViewController(withIdentifier: "VolumeCommentsDisplay") as? VolumeCommentsDisplayViewController
		
		// Set initial values
		viewController!.set(volumeID: volumeID)
		
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
	
	fileprivate func hideFadeOutView() {
		
		// Hide view
		UIView.animate(withDuration: 0.1) {
			
			self.fadeOutView.alpha = 0
		}
		
	}
	
	fileprivate func loadAwards(presentAwardsViewYN: Bool) {
		
		guard (!self.isAwardsLoadedYN) else { return }
		
		self.isAwardsLoadedYN = true
		
		// Create completion handler
		let loadAwardsCompletionHandler: (([AwardWrapper], Error?) -> Void) =
		{
			[unowned self] (items, error) -> Void in

			guard (items.count > 0) else { return }
			
			DispatchQueue.main.async(execute: {

				self.awardsButtonView.isHidden = false
				
				self.view.layoutIfNeeded()
				
				// Display awards
				self.controlManager!.displayAwards()
	
				if (presentAwardsViewYN) {
					
					self.presentAwardsView()
					
				}
				
			})
		}
		
		DispatchQueue.global().async {
			
			self.controlManager!.loadAwards(oncomplete: loadAwardsCompletionHandler)
		
		}
		
	}
	
	fileprivate func switchAwardsView() {
		
		// If awardsView is not shown then show, otherwise hide
		if (!self.awardsBarView.isShownYN) {
			
			self.presentAwardsView()
			
		}
		else {
			
			self.hideAwardsView()

		}
	}
	
	fileprivate func clearAwardsView() {
		
		self.isAwardsLoadedYN = false
		
		self.hideAwardsView()
		
		self.awardsButtonView.isHidden = true
		
		self.controlManager!.clearAwardsView()
		
	}
	
	fileprivate func presentAwardsView() {
		
		self.awardsBarView.isHidden = false

		self.doAwardsButtonShrinkAnimation()
		self.awardsBarView.present(animateYN: true)
		
	}
	
	fileprivate func hideAwardsView() {
	
		self.doAwardsButtonGrowAnimation()
		self.awardsBarView.hide(animateYN: true)
		
		self.awardsBarView.isHidden = true
	}
	
	fileprivate func doAwardsButtonGrowAnimation() {
		
		UIView.animate(withDuration: 0.2, animations: {
			
			self.awardsButtonView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

			self.view.layoutIfNeeded()

		})
		
	}
	
	fileprivate func doAwardsButtonShrinkAnimation() {
		
		UIView.animate(withDuration: 0.2, animations: {
			
			self.awardsButtonView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
			
			self.view.layoutIfNeeded()

		})
		
	}
	
	fileprivate func setAwardsBarViewWidth() {
	
		if (self.traitCollection.horizontalSizeClass != .regular) {
			
			self.awardsBarViewEqualWidthLayoutConstraint.constant = 0
			return
			
		}
		
		self.awardsBarViewEqualWidthLayoutConstraint.constant = self.awardsBarViewEqualWidthLayoutConstraintConstant
		
		
		
		self.view.layoutIfNeeded()
		
		let widthDifference: CGFloat = self.view.frame.size.width - self.awardsBarViewMaximumWidth
		
		if (self.awardsBarView.frame.size.width > self.awardsBarViewMaximumWidth) {
			
			self.awardsBarViewEqualWidthLayoutConstraint.constant = 0 - widthDifference
			
		}

	}
	
	fileprivate func setAwardsBarViewHeight(contentSize: CGSize) {
		
		self.awardsBarViewHeightLayoutConstraint.constant = self.awardsBarViewContainerViewPadding + contentSize.height + self.awardsBarViewContainerViewPadding + self.awardsBarViewPadding
		
	}

	fileprivate func setVolumesCollectionViewRightLayoutConstraintDefault() {
		
		self.volumesCollectionViewRightLayoutConstraintDefault = self.volumesCollectionViewRightLayoutConstraint.constant
		
	}
	
	fileprivate func checkSetVolumesCollectionViewRightLayoutConstraintYN() {
		
		self.setVolumesCollectionViewRightLayoutConstraintYN = false
		
		// If volumesCollectionView width is reduced below width sufficient for 1 column
		if (self.view.frame.size.width - self.newsBarViewWidthLayoutConstraint.constant < 250) {
			
			self.setVolumesCollectionViewRightLayoutConstraintYN = true
			
		}
		
	}
	
	fileprivate func setVolumesCollectionViewRightLayoutConstraint(setToDefaultYN: Bool) {
		
		// Set to default value if setToDefaultYN or newsBarView is not shown
		if (setToDefaultYN || !self.newsBarView.isShownYN) {
			
			self.volumesCollectionViewRightLayoutConstraint.constant = self.volumesCollectionViewRightLayoutConstraintDefault
			
			return
			
		}
		
		if (self.setVolumesCollectionViewRightLayoutConstraintYN) {
			
			self.volumesCollectionViewRightLayoutConstraint.constant = self.volumesCollectionViewRightLayoutConstraintDefault - self.newsBarViewWidthLayoutConstraint.constant
			
		} else {
			
			self.volumesCollectionViewRightLayoutConstraint.constant = self.volumesCollectionViewRightLayoutConstraintDefault
			
		}
		
	}
	
	fileprivate func refreshVolumesCollectionViewLayout() {
		
		// Call invalidateLayout to make sure layout is updated
		self.volumesCollectionView.collectionViewLayout.invalidateLayout()
		
		// Call reloadData to ensure cells are resized
		self.volumesCollectionView.reloadData()
		
	}
	
	fileprivate func loadNewsSnippets() {
		
		// Check isSignedInYN
		guard (self.controlManager!.isSignedInYN) else { return }
		
		guard (!self.isNewsSnippetsLoadedYN) else { return }
		
		self.isNewsSnippetsLoadedYN = true
		
		// Create completion handler
		let loadNewsSnippetsCompletionHandler: (([NewsSnippetWrapper], Error?) -> Void) =
		{
			[unowned self] (items, error) -> Void in
			
			guard (items.count > 0) else { return }
			
			DispatchQueue.main.async(execute: {
	
				self.view.layoutIfNeeded()
				
				// Display news snippets
				self.newsBarView.displayNewsSnippets(items: items)
				
				self.view.layoutIfNeeded()
				
			})
		}
		
		DispatchQueue.global().async {
			
			self.controlManager!.loadNewsSnippets(oncomplete: loadNewsSnippetsCompletionHandler)
			
		}
		
	}
	
	fileprivate func clearNewsSnippetsView() {
		
		self.isNewsSnippetsLoadedYN = false

		self.newsBarView.clearNewsSnippets()
		
		//self.controlManager!.clearNewsSnippetsView()
		
	}
	
	fileprivate func setNewsBarViewLeftLayoutConstraint() {
		
		if (!self.newsBarView.isShownYN) {
			
			// Set newsBarView LeftLayoutConstraint
			self.newsBarViewLeftLayoutConstraint!.constant	= (0 + self.newsBarViewLeftLayoutConstraintOffset) - self.newsBarViewWidthLayoutConstraint!.constant
			
		}
		
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
	
	
	// MARK: - awardsButton TapGestureRecognizer Methods
	
	@IBAction func awardsButtonTapped(_ sender: Any) {
		
		self.switchAwardsView()
		
	}
	
}

// MARK: - Extension ProtocolMainDisplayControlManagerDelegate

extension VolumesListDisplayViewController: ProtocolVolumesControlManagerBaseDelegate {

	// MARK: - Public Methods
	
	func volumesControlManagerBase(isNotConnected error: Error?) {
	
		self.presentIsNotConnectedAlert()
		
	}
	
	func volumesControlManagerBase(signInFailed sender: VolumesControlManagerBase) {
		
		self.presentSignInAlert(onSignInSuccessful: nil)
		
	}
	
}

// MARK: - Extension UIScrollViewDelegate

extension VolumesListDisplayViewController: UIScrollViewDelegate {
	
	// Public Methods
	
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		// Check user scrolling
		guard (scrollView.isDragging || scrollView.isDecelerating) else {
			return
		}
		
		// Check state
		guard ( self.isInitialLoadCompleteYN				== true &&
				self.controlManager!.isLoadingDataYN		== false &&
				VolumeWrappers.hasLoadedAllNextItemsYN		== false) else {
			return
		}
	
		// Check at bottom zone
		let detectBottomZoneHeight:		CGFloat = 150.0 as CGFloat!
		let contentOffset:				CGFloat = scrollView.contentOffset.y
		let maximumOffset:				CGFloat = scrollView.contentSize.height - scrollView.bounds.size.height
		
		if (maximumOffset - contentOffset <= detectBottomZoneHeight)
			&& (maximumOffset - contentOffset != -5.0) {
		
			self.isDataViewAtBottomZoneYN = true
		} else {
			
			self.isDataViewAtBottomZoneYN = false
		}
		
		if (!self.isDataViewAtBottomZoneYN) { return }
		
		// Check should load more
		if (self.shouldLoadMoreVolumes()) {
			
			// Load data
			self.loadVolumes(toFillYN: false)
		}
		
	}
	
}

// MARK: - Extension UICollectionViewDelegate

extension VolumesListDisplayViewController: UICollectionViewDelegate {
	
	// Public Methods
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// Get the item
		let volumeWrapper: VolumeWrapper	= VolumeWrappers.items[indexPath.row]
		
		// Create the cell
		let cell = self.createVolumesCollectionViewCell(for: volumeWrapper, at: indexPath)
		
		return cell
	}
	
}

// MARK: - Extension UICollectionViewDataSource

extension VolumesListDisplayViewController: UICollectionViewDataSource {
	
	// Public Methods
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return VolumeWrappers.items.count
	}

}

// MARK: - Extension SFProtocolCollectionViewLayoutDelegate

extension VolumesListDisplayViewController: SFProtocolCollectionViewLayoutDelegate {
	
	// Public Methods
	
	func collectionView(collectionView:UICollectionView, heightForCellAtIndexPath indexPath:NSIndexPath, withWidth:CGFloat) -> CGFloat {

		// Get the item
		let volumeWrapper: 	VolumeWrapper = VolumeWrappers.items[indexPath.row]
		
		// Calculate cell height
		let result: 		CGFloat = self.heightForCell(of: volumeWrapper, withWidth: withWidth)
		
		return result
		
	}
	
	func collectionView(collectionView:UICollectionView, widthForCellAtIndexPath indexPath:NSIndexPath) -> CGFloat {
		
		// Get the item
		let volumeWrapper: 	VolumeWrapper = VolumeWrappers.items[indexPath.row]
		
		// Calculate cell width
		let result: 		CGFloat = self.widthForCell(of: volumeWrapper)
		
		return result
		
	}
	
	func setCustomAttributes(attributes: SFCollectionViewLayoutAttributes) {
		
		// TODO:
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func heightForCell(of volumeWrapper: VolumeWrapper, withWidth width: CGFloat) -> CGFloat {
		
		var result: 						CGFloat = 0
		
		// itemCoverViewHeight
		let itemCoverViewHeight: 			CGFloat = self.heightForItemCoverView(of: volumeWrapper, withWidth: width)

		//volumeWrapper.itemCoverViewHeight 	= itemCoverViewHeight
		result += itemCoverViewHeight
		
		// itemCoverFooterViewHeight
		let itemCoverFooterViewHeight: 		CGFloat = self.heightForItemCoverFooterView(of: volumeWrapper, withWidth: width)
		result += itemCoverFooterViewHeight
		
		return result
	}

	fileprivate func heightForItemCoverView(of volumeWrapper: VolumeWrapper, withWidth width: CGFloat) -> CGFloat {
		
		var result: CGFloat = 0
		
		// margin = 0
		result += 0
		
		// coverView height
		result += 178

		// margin = 5
		result += 5
		
		return result
		
	}

	fileprivate func heightForItemCoverFooterView(of volumeWrapper: VolumeWrapper, withWidth width: CGFloat) -> CGFloat {
		
		var result: CGFloat = 0
		
		// margin = 3
		result += 3
		
		// coverFooterView height
		result += 15
		
		// margin = 0
		result += 0
		
		return result
		
	}
	
	fileprivate func widthForCell(of volumeWrapper: VolumeWrapper) -> CGFloat {
		
		var result: CGFloat = 0
		
		// coverView
		result += 130
		
		// Check latestVolumeCommentText
		if (volumeWrapper.latestVolumeCommentText.count > 0) {
			
			// margin = 10
			result += 10
			
			// itemLatestVolumeCommentView
			result += 150
			
			// margin = 10
			result += 10
			
		}
		
		return result
	}
	
}

// MARK: - Extension ProtocolVolumesCollectionViewCellDelegate

extension VolumesListDisplayViewController: ProtocolVolumesCollectionViewCellDelegate {
	
	// Public Methods
	
	func volumesCollectionViewCell(cell: VolumesCollectionViewCell, didTapCover item: VolumeWrapper) {
		
		self.presentVolumeItemDisplay(item: cell.item!)
		
	}
	
	public func volumesCollectionViewCell(cell: VolumesCollectionViewCell, didTapLikeButton item: VolumeWrapper, oncomplete completionHandler:@escaping () -> Void) {
		
		// Check is connected
		guard (self.controlManager!.checkIsConnected()) else { return }
		
		// Present 'liked volume' view
		self.presentLikedVolumeView()
		
		// Like volume
		self.controlManager!.likeVolume(for: item)
		
		// Call completion handler
		completionHandler()
	}
	
	func volumesCollectionViewCell(cell: VolumesCollectionViewCell, didTapCommentsButton item: VolumeWrapper) {
		
		self.presentVolumeCommentsDisplay(volumeID: item.id)
		
	}

}

// MARK: - Extension ProtocolNewsBarViewDelegate

extension VolumesListDisplayViewController: ProtocolNewsBarViewDelegate {

	// Public Methods
	
}

// MARK: - Extension ProtocolDashboardMenuViewDelegate

extension VolumesListDisplayViewController: ProtocolDashboardMenuViewDelegate {
	
	// Public Methods
	
	public func dashboardMenuView(didDismiss sender: DashboardMenuView) {
		
		self.dashboardMenuViewIsShownYN = false
	}
	
	public func dashboardMenuView(sender: DashboardMenuView, didSelectDaughter daughter: Daughters) {
		
		// Create completion handler
		let completionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Reload volumes
			self.loadVolumes(toFillYN: true)
		}
		
		// Check daughter has changed
		if (daughter != self.controlManager!.selectedDaughter) {
			
			self.presentActivityIndicatorView(animateYN: true)
			
			// Store selected daughter. This clears data
			self.controlManager!.set(selectedDaughter: daughter)
			
			// Set daughter in dashboard bar
			self.dashboardBarView.set(daughter: daughter)
			
			// Clear awards view
			self.clearAwardsView()
			
			// Clear news snippets view
			self.clearNewsSnippetsView()
			
			// Clear volumes view
			self.clearVolumesCollectionView(oncomplete: completionHandler)
			
		}
		
	}
	
	public func dashboardMenuView(sender: DashboardMenuView, didSelectYear year: Int) {
		
		// Create completion handler
		let completionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Reload volumes
			self.loadVolumes(toFillYN: true)
		}
		
		// Check year has changed
		if (year != self.controlManager!.selectedYear) {
			
			self.presentActivityIndicatorView(animateYN: true)
			
			// Store selected year. This clears data
			self.controlManager!.set(selectedYear: year)
			
			// Set year in dashboard bar
			self.dashboardBarView.set(year: year)
			
			// Clear awards view
			self.clearAwardsView()
			
			// Clear news snippets view
			self.clearNewsSnippetsView()
			
			// Clear volumes view
			self.clearVolumesCollectionView(oncomplete: completionHandler)
			
		}
	}
	
}

// MARK: - Extension ProtocolDashboardBarViewDelegate

extension VolumesListDisplayViewController: ProtocolDashboardBarViewDelegate {
	
	// Public Methods
	
	public func dashboardBarView(sender: DashboardBarView, daughterChanged daughter: Daughters) {
		
		if (!hasViewAppearedYN) { return }
		
		// TODO:
	}
	
	public func dashboardBarView(sender: DashboardBarView, yearChanged year: Int) {
		
		if (!hasViewAppearedYN) { return }
		
		// TODO:
	}
	
	public func dashboardBarView(sender: DashboardBarView, daughterButtonTapped daughter: Daughters) {
		
		self.switchDashboardMenuView()
	}
	
	public func dashboardBarView(sender: DashboardBarView, yearButtonTapped year: Int) {

		self.switchDashboardMenuView()
	}

	public func dashboardBarView(sender: DashboardBarView, newsBarButtonTapped newsBarIsSelectedYN: Bool) {
		
		self.switchNewsBarView()
		
	}
	
}


// MARK: - Extension ProtocolAwardsBarViewDelegate

extension VolumesListDisplayViewController: ProtocolAwardsBarViewDelegate {
	
	// Public Methods
	
	public func awardsBarView(didSetContentSize sender: AwardsBarView, size: CGSize) {
		
		self.setAwardsBarViewHeight(contentSize: size)
		
	}
	
}


// MARK: - Extension ProtocolVolumeItemDisplayViewControllerDelegate

extension VolumesListDisplayViewController: ProtocolVolumeItemDisplayViewControllerDelegate {

	// MARK: - Methods

	public func volumeItemDisplayViewController(didDismiss sender: VolumeItemDisplayViewController) {

		self.volumesCollectionView.reloadData()
	}

}


// MARK: - Extension ProtocolVolumeCommentsDisplayViewControllerDelegate

extension VolumesListDisplayViewController: ProtocolVolumeCommentsDisplayViewControllerDelegate {
	
	// MARK: - Methods
	
	public func volumeCommentsDisplayViewController(didDismiss sender: VolumeCommentsDisplayViewController) {
		
		self.hideFadeOutView()
	}
	
	public func volumeCommentsDisplayViewController(didPostComment sender: VolumeCommentsDisplayViewController) {
		
		self.volumesCollectionView.reloadData()
	}
	
}


// MARK: - Extension ProtocolPanGestureHelperDelegate

extension VolumesListDisplayViewController: ProtocolPanGestureHelperDelegate {

	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .right) {		// Check if moving right
			
			// Call invalidateLayout to make sure layout is updated
			self.volumesCollectionView.collectionViewLayout.invalidateLayout()
			
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .left) {		// Check if moving left
			
			if (!self.newsBarView.isShownYN) { return }
			
			// Get distance moved
			let distanceMovedLeft: CGFloat = attributes.initialTouchPoint.x - attributes.currentTouchPoint.x
			
			// Check distance moved is not to the right
			if (distanceMovedLeft < 0) { return }
			
			// Move view position
			self.newsBarViewLeftLayoutConstraint!.constant	= (0 + self.newsBarViewLeftLayoutConstraintOffset) - distanceMovedLeft
			
			self.view.layoutIfNeeded()

		} else if (attributes.direction == .right) {	// Check if moving right
			
			if (!self.controlManager!.isSignedInYN) { return }
			if (self.newsBarView.isShownYN) { return }
			if (self.newsBarViewLeftLayoutConstraint!.constant >= (0 + self.newsBarViewLeftLayoutConstraintOffset)) { return }
		
			self.newsBarView.alpha = 1
			
			// Get distance moved
			let distanceMovedRight: CGFloat = attributes.currentTouchPoint.x - attributes.initialTouchPoint.x
			
			// Check distance moved is not to the left
			if (distanceMovedRight < 0) { return }
			
			// Move view position
			self.newsBarViewLeftLayoutConstraint!.constant	= ((0 + self.newsBarViewLeftLayoutConstraintOffset) - self.newsBarViewWidthLayoutConstraint!.constant) + distanceMovedRight
			
			self.view.layoutIfNeeded()
			
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes) {
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .left) {			// Check if moving left
			
			if (!self.newsBarView.isShownYN) { return }
			
			self.dashboardBarView.set(newsBarIsSelectedYN: false, animateYN: true)
			
			// Hide news bar
			self.hideNewsBarView()

		} else if (attributes.direction == .right) {	// Check if moving right
			
			if (self.newsBarView.isShownYN) { return }
			
			self.dashboardBarView.set(newsBarIsSelectedYN: true, animateYN: true)
			
			// Present news bar
			self.presentNewsBarView()
			
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .left) {			// Check if moving left
			
			if (!self.newsBarView.isShownYN) { return }

			// Reset view position
			self.doPresentNewsBarViewAnimation(refreshVolumesCollectionViewLayoutYN: false)

		} else if (attributes.direction == .right) {	// Check if moving right
			
			if (self.newsBarView.isShownYN) { return }
			
			// Reset view position
			self.doHideNewsBarViewAnimation(refreshVolumesCollectionViewLayoutYN: false)
			
		}
		
	}
	
}

