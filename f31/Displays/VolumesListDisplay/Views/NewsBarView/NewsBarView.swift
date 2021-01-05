//
//  NewsBarView.swift
//  f31
//
//  Created by David on 15/11/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView
import f31Core
import f31Model
import f31View
import f31Controller

/// A view class for a NewsBarView
public class NewsBarView: UIView, ProtocolNewsBarView {
	
	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:				NewsBarViewControlManager?
	fileprivate var newsSnippetWrappers: 		[NewsSnippetWrapper]? = nil
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:					ProtocolNewsBarViewDelegate?
	public var isShownYN: 						Bool = false

	@IBOutlet weak var contentView:				UIView!
	@IBOutlet weak var newsSnippetsTableView: 	UITableView!
	
	
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
	
	// Comment; touchesBegan won't be invoked because a UIScrollView is used to frame the content. We implement a tap gesture recognizer on the UIScrollView to call endTyping.
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		//self.endTyping()
	}
	
	public override func resignFirstResponder() -> Bool {
		
		//self.endTyping()
		
		return super.resignFirstResponder()
	}

	
	// MARK: - Public Methods
	
	public func set() {
		
	}
	
	public func viewDidAppear() {
		
	}
	
	public func clearView() {
		
	}

	public func handleTouchesBeganInside(_ point: CGPoint, with event: UIEvent?) {
		
		// Check view is displayed
		guard (!isHidden && alpha != 0) else { return }
		
		// Handle cancelButton touches
		//		if (self.cancelButton.frame.contains(point)) {
		//
		//			self.cancelButton.sendActions(for: .touchUpInside)
		//
		//		}
		
	}
	
	public func displayNewsSnippets(items: [NewsSnippetWrapper]) {
		
		self.clearNewsSnippets()
		
		guard (items.count > 0) else { return }
		
		self.newsSnippetWrappers = items

		// Refresh table view
		DispatchQueue.main.async(execute: {
			
			self.newsSnippetsTableView.reloadData()
			
			self.layoutIfNeeded()
			
		})
		
	}
	
	public func clearNewsSnippets() {
		
		self.newsSnippetWrappers = nil

		// Refresh table view
		DispatchQueue.main.async(execute: {
			
			self.newsSnippetsTableView.reloadData()
			
		})
		
	}
	
	public func correctOverScroll() {
		
		UIScrollViewHelper.correctOverScroll(scrollView: self.newsSnippetsTableView, animate: true)
		
	}

	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager 			= NewsBarViewControlManager()
		
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
		let viewAccessStrategy: NewsBarViewViewAccessStrategy = NewsBarViewViewAccessStrategy()
		
		viewAccessStrategy.setup()
		
		// Setup the view manager
		self.controlManager!.viewManager = NewsBarViewViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setupContentView() {
		
		// Load xib
		Bundle.main.loadNibNamed("NewsBarView", owner: self, options: nil)
		
		addSubview(contentView)
		
		self.layoutIfNeeded()
		
		// Position the contentView to fill the view
		contentView.frame				= self.bounds
		contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
	}
	
	fileprivate func setupView() {

		self.setupNewsSnippetsTableView()
		
	}
	
	fileprivate func setupNewsSnippetsTableView() {
		
		// Enable table row automatic height
		self.newsSnippetsTableView.rowHeight 			= UITableViewAutomaticDimension
		self.newsSnippetsTableView.estimatedRowHeight 	= UITableViewAutomaticDimension

		// Set edge inset (Note: this can't be done in Storyboard)
		let inset: UIEdgeInsets = UIEdgeInsetsMake(10, 0, 20, 0)
		self.newsSnippetsTableView.contentInset = inset
		
		self.newsSnippetsTableView.delegate				= self
		self.newsSnippetsTableView.dataSource			= self
		
		// Register custom TableViewCell using nib because the TableView is defined in a custom View and not in the Storyboard
		self.newsSnippetsTableView.register(UINib(nibName: "NewsSnippetsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsSnippetsTableViewCell")
		
	}
	
	fileprivate func createNewsSnippetsTableViewCell(for item: NewsSnippetWrapper, at indexPath: IndexPath) -> NewsSnippetsTableViewCell {
		
		let cell = self.newsSnippetsTableView.dequeueReusableCell(withIdentifier: "NewsSnippetsTableViewCell", for: indexPath) as! NewsSnippetsTableViewCell
		
		cell.delegate = self
		
		// Set the item in the cell
		cell.set(item: item)
		
		return cell
		
	}
	
}

// MARK: - Extension ProtocolNewsBarViewControlManagerDelegate

extension NewsBarView: ProtocolNewsBarViewControlManagerDelegate {
	
	// MARK: - Public Methods
	
	public func templateViewControlManager(isNotConnected error: Error?) {

	}
	
}

// MARK: - Extension UITableViewDelegate, UITableViewDataSource

extension NewsBarView : UITableViewDelegate, UITableViewDataSource {
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return self.newsSnippetWrappers?.count ?? 0
		
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// Get the item
		let newsSnippetWrapper: NewsSnippetWrapper = self.newsSnippetWrappers![indexPath.row]
		
		// Create the cell
		let cell = self.createNewsSnippetsTableViewCell(for: newsSnippetWrapper, at: indexPath)
		
		return cell
	}
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
}


// MARK: - Extension ProtocolNewsSnippetsTableViewCellDelegate

extension NewsBarView: ProtocolNewsSnippetsTableViewCellDelegate {
	
	// MARK: - Public Methods
	
}



