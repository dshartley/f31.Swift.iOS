//
//  VolumeCommentsDisplayViewController.swift
//  f31
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import Foundation
import SFView
import f31Core
import f31Model
import f31View
import f31Controller

/// A ViewController for the VolumeCommentsDisplay
public class VolumeCommentsDisplayViewController: UIViewController {
	
	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:								VolumeCommentsDisplayControlManager?
	fileprivate var volumeID: 									Int = 0
	fileprivate var commentsViewBottomLayoutConstraintOffset: 	CGFloat = -10
	fileprivate var commentTextViewMaxNumberofLines: 			Int = 5
	
	
	// MARK: - Public Stored Properties
	
	public var delegate:										ProtocolVolumeCommentsDisplayViewControllerDelegate?
	
	@IBOutlet weak var commentsTableView: 						UITableView!
	@IBOutlet weak var postedByNameTextField: 					UITextField!
	@IBOutlet weak var activityIndicatorView: 					UIActivityIndicatorView!
	@IBOutlet weak var commentsView: 							UIView!
	@IBOutlet weak var commentsViewBottomLayoutConstraint: 		NSLayoutConstraint!
	@IBOutlet weak var commentTextView: 						UITextView!
	@IBOutlet weak var commentTextViewHeightLayoutConstraint: 	NSLayoutConstraint!
	@IBOutlet weak var commentPlaceholderLabel: 				UILabel!
	
	
	// MARK: - Override Methods
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.setup()
		
		self.setupPostedByNameTextField()
		self.setupCommentsView()
		self.setupCommentTextView()
		self.setupCommentsTableView()
		self.setupKeyboard()
	
	}
	
	public override func viewDidLayoutSubviews() {
		
		self.setupCommentsView()
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		
		self.presentActivityIndicatorView(animateYN: false)
		
		self.loadVolumeComments()
	}
	
	public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		// Call reloadData to ensure cells are resized
		self.commentsTableView.reloadData()

	}
	
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		self.endTyping()
	}
	
	
	// MARK: - Public Methods
	
	public func set(volumeID: String) {
		
		self.volumeID = Int(volumeID) ?? 0

	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
	}

	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager = VolumeCommentsDisplayControlManager()
		
		self.controlManager!.volumeID = self.volumeID
		
	}
	
	fileprivate func setupModelManager() {
		
		// Set the model manager
		self.controlManager!.set(modelManager: ModelFactory.modelManager)
		
		// Setup the model administrators
		ModelFactory.setupVolumeCommentModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
	}
	
	fileprivate func setupViewManager() {
		
		// Create view strategy
		let viewAccessStrategy: VolumeCommentsDisplayViewAccessStrategy = VolumeCommentsDisplayViewAccessStrategy()
		
		viewAccessStrategy.setup(postedByNameTextField:		self.postedByNameTextField,
		                         commentTextView:			self.commentTextView)
		
		// Setup the view manager
		self.controlManager!.viewManager = VolumeCommentsDisplayViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setupPostedByNameTextField() {
		
		self.postedByNameTextField.delegate = self
	}
	
	fileprivate func setupCommentTextView() {
		
		// Set left inset 0
		self.commentTextView.textContainer.lineFragmentPadding 	= 0
		self.commentTextView.textContainerInset.left 			= 0
		
		self.commentTextView.delegate 							= self

		// Set initial height
		self.setCommentTextViewHeight()

	}
	
	fileprivate func setupCommentsTableView() {
		
		// Enable table row automatic height
		self.commentsTableView.rowHeight 			= UITableViewAutomaticDimension
		self.commentsTableView.estimatedRowHeight 	= 100
		
		self.commentsTableView.delegate				= self
		self.commentsTableView.dataSource			= self
	
	}
	
	fileprivate func createCommentsTableViewCell(for dataItem: VolumeCommentWrapper, at indexPath: IndexPath) -> CommentsTableViewCell {
		
		let cell = self.commentsTableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
		
		//cell.delegate = self
		
		// Set the item in the cell
		cell.set(item: dataItem)
		
		return cell
		
	}
	
	fileprivate func presentActivityIndicatorView(animateYN: Bool) {

		if (animateYN) {

			// Show view
			UIView.animate(withDuration: 0.3) {
				self.activityIndicatorView.alpha = 1
			}

		} else {

			self.activityIndicatorView.alpha = 1
		}

	}

	fileprivate func hideActivityIndicatorView() {

		DispatchQueue.main.async {

			guard (self.activityIndicatorView.alpha != 0) else { return }

			// Hide view
			UIView.animate(withDuration: 0.3) {
				self.activityIndicatorView.alpha = 0
			}

		}
	}
	
	fileprivate func loadVolumeComments() {
		
		// Create completion handler
		let loadVolumeCommentsCompletionHandler: (([VolumeCommentWrapper]?, Error?) -> Void) =
		{
			(items, error) -> Void in
			
			self.hideActivityIndicatorView()
			
			if (items != nil && error == nil) {
				
				// Refresh table view
				DispatchQueue.main.async(execute: {
					
					self.commentsTableView.reloadData()
					
				})
			}
		}
		
		self.controlManager!.loadVolumeComments(oncomplete: loadVolumeCommentsCompletionHandler)
	}
	
	fileprivate func clearCommentDisplay() {
		
		self.postedByNameTextField.text = nil
		self.commentTextView.text 		= ""
	}
	
	fileprivate func setupCommentsView() {
		
		self.commentsView.layer.cornerRadius = 10.0;
		self.commentsView.layer.borderWidth = 1.0;
		self.commentsView.layer.borderColor = UIColor.clear.cgColor
		self.commentsView.layer.masksToBounds = true;
	}
	
	fileprivate func setupKeyboard() {
		
		self.setupKeyboardWillShowNotification()
		self.setupKeyboardWillHideNotification()
		
	}
	
	fileprivate func setupKeyboardWillShowNotification() {
		
		// Create completion handler
		let keyboardWillShowCompletionHandler: (Notification) -> Void =
		{
			(sender) -> Void in
			
			self.keyboardWillShow(sender)
		}
		
		NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow,
		                                       object: 	nil,
		                                       queue: 	OperationQueue.main,
		                                       using: 	keyboardWillShowCompletionHandler)
	}
	
	fileprivate func setupKeyboardWillHideNotification() {
		
		// Create completion handler
		let keyboardWillHideCompletionHandler: (Notification) -> Void =
		{
			(sender) -> Void in
			
			self.keyboardWillHide(sender)
		}
		
		NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide,
		                                       object: 	nil,
		                                       queue: 	OperationQueue.main,
		                                       using: 	keyboardWillHideCompletionHandler)
	}
	
	fileprivate func keyboardWillShow(_ sender:Notification) {
		
		// Animate the constraint so that the textfield is sitting above the keyboard
		
		let keyboardHeight = (sender.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect)?.size.height ?? 258
		
		view.layoutIfNeeded()
		
		UIView.animate(withDuration: 0.25, animations: {
			
			self.commentsViewBottomLayoutConstraint.constant = keyboardHeight + self.commentsViewBottomLayoutConstraintOffset

			self.view.layoutIfNeeded()
		})
		
	}
	
	fileprivate func keyboardWillHide(_ sender:Notification) {
		
		// Animate the constraint back to original values
		view.layoutIfNeeded()
		
		UIView.animate(withDuration: 0.25, animations: {
			
			self.commentsViewBottomLayoutConstraint.constant = 0 + self.commentsViewBottomLayoutConstraintOffset
		
			self.view.layoutIfNeeded()
		})
	}
	
	fileprivate func endTyping() {
		
		self.postedByNameTextField.resignFirstResponder()
		self.commentTextView.resignFirstResponder()
		
	}
	
	fileprivate func setCommentTextViewHeight() {
		
		UITextViewHelper.setHeightToFit(textView: self.commentTextView, heightLayoutConstraint: self.commentTextViewHeightLayoutConstraint, maxNumberofLines: self.commentTextViewMaxNumberofLines)
		
	}
	
	fileprivate func setCommentTextViewPlaceholderLabel() {
		
		if (self.commentTextView.attributedText.length == 0) {
			
			self.commentPlaceholderLabel.isHidden = false
			
		} else {
			
			self.commentPlaceholderLabel.isHidden = true
			
		}
	}
	
	
	// MARK: - commentsTableView Methods
	
	@IBAction func commentsTableViewTapped(_ sender: Any) {
		
		self.postedByNameTextField.resignFirstResponder()
		self.commentTextView.resignFirstResponder()
		
	}
	
	
	// MARK: - closeViewButton Methods
	
	@IBAction func closeViewButtonTapped(_ sender: Any) {
	
		self.endTyping()
		
		// Notify the delegate
		self.delegate?.volumeCommentsDisplayViewController(didDismiss: self)
		
		// Dismiss view
		dismiss(animated: true, completion: nil)
		
	}
	
	
	// MARK: - postCommentButton Methods
	
	@IBAction func postCommentButtonTapped(_ sender: Any) {

		// Check postedByNameTextField and commentTextField
		guard (	(self.postedByNameTextField.text?.count ?? 0) > 0 &&
				self.commentTextView.text.count > 0) else { return }
		
		self.endTyping()
		self.presentActivityIndicatorView(animateYN: true)
		
		// Create completion handler
		let postCommentCompletionHandler: ((VolumeCommentWrapper?, Error?) -> Void) =
		{
			(item, error) -> Void in

			self.hideActivityIndicatorView()
			
			if (item != nil && error == nil) {
				
				// Refresh table view
				DispatchQueue.main.async(execute: {
					
					self.clearCommentDisplay()
					self.commentsTableView.reloadData()
					
					// Notify the delegate
					self.delegate?.volumeCommentsDisplayViewController(didPostComment: self)
				})
			}

		}
		
		self.controlManager!.postComment(oncomplete: postCommentCompletionHandler)

	}
	
}

// MARK: - Extension UITextFieldDelegate

extension VolumeCommentsDisplayViewController : UITextFieldDelegate {

	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		// Get maxLength
		var maxLength: 		Int = Int.max
		
		// postedByNameTextField
		if (textField == self.postedByNameTextField) { maxLength = 50 }
		
		let result: 		Bool = UITextFieldHelper.checkMaxLength(textField: textField, shouldChangeCharactersIn: range, replacementString: string, maxLength: maxLength)
		
		return result
	}
}

// MARK: - Extension UITextViewDelegate

extension VolumeCommentsDisplayViewController : UITextViewDelegate {
	
	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		
		// Get maxLength
		var maxLength: 		Int = Int.max
		
		// commentTextView
		if (textView == self.commentTextView) { maxLength = 250 }
		
		let result: 		Bool = UITextViewHelper.checkMaxLength(textView: textView, shouldChangeTextIn: range, replacementText: text, maxLength: maxLength)

		return result
	}
	
	public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		
		self.setCommentTextViewPlaceholderLabel()
		
		return true
	}
	
	public func textViewDidChange(_ textView: UITextView) {
		
		self.setCommentTextViewPlaceholderLabel()
		self.setCommentTextViewHeight()

	}
}

// MARK: - Extension UITableViewDelegate, UITableViewDataSource
	
extension VolumeCommentsDisplayViewController : UITableViewDelegate, UITableViewDataSource {
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return self.controlManager!.volumeCommentWrappers.count

	}
		
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		// Get the item
		let volumeCommentWrapper: VolumeCommentWrapper	= self.controlManager!.volumeCommentWrappers[indexPath.row]

		// Create the cell
		let cell = self.createCommentsTableViewCell(for: volumeCommentWrapper, at: indexPath)

		return cell
	}

	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

}
