//
//  VolumesCollectionViewCell.swift
//  f31
//
//  Created by David on 12/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView
import f31Core
import f31Model

/// A class for an VolumesCollectionViewCell
public class VolumesCollectionViewCell: UICollectionViewCell {
	
	// MARK: - Private Stored Properties
	
	fileprivate let coverViewTapGestureRecognizer					= UITapGestureRecognizer()
	fileprivate let volumeCommentsButtonViewTapGestureRecognizer	= UITapGestureRecognizer()
	

	// MARK: - Public Stored Properties
	
	public var delegate:											ProtocolVolumesCollectionViewCellDelegate?
	public fileprivate(set) var item:								VolumeWrapper? = nil
	@IBOutlet weak var coverView: 									UIView!
	@IBOutlet weak var coverImageView: 								UIImageView!
	@IBOutlet weak var titleLabel: 									UILabel!
	@IBOutlet weak var itemLatestVolumeCommentView: 				UIView!
	@IBOutlet weak var latestVolumeCommentTextLabel: 				UILabel!
	@IBOutlet weak var latestVolumeCommentPostedByNameLabel:		UILabel!
	@IBOutlet weak var latestVolumeCommentDatePostedLabel: 			UILabel!
	@IBOutlet weak var seeAllVolumeCommentsButton: 					UIButton!
	@IBOutlet weak var volumeCommentsButtonView: 					UIView!
	@IBOutlet weak var datePublishedLabel: 							UILabel!
	@IBOutlet weak var numberofPagesLabel: 							UILabel!

	
	// MARK: - Public Methods
	
	public func set(item: VolumeWrapper) {
		
		self.item = item
		
		self.displayItem()
		
		self.layoutIfNeeded()
		
		self.setHeights()
		
	}
	
	public func set(coverThumbnailImage: UIImage?) {
		
		DispatchQueue.main.async {
			
			if (coverThumbnailImage != nil) {
				
				self.presentCoverImageView()
				self.coverImageView.image = coverThumbnailImage
				
			} else {
				
				self.hideCoverImageView()
				self.coverImageView.image = nil
				
			}
			
		}

	}

	
	// MARK: - Override Methods
	
	public override func awakeFromNib() {
		
		self.setup()
	}
	
	public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		
		self.contentView.frame = self.bounds
		
		self.layoutIfNeeded()
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupContentView()
		self.setupCoverView()
		self.setupVolumeCommentsButtonView()
		
	}
	
	fileprivate func setupContentView() {
		
	}
	
	fileprivate func setupCoverView() {
		
		self.coverView.layer.cornerRadius 	= 3.0;
		
		//UIViewHelper.roundCorners(view: self.coverView, corners: [.topRight, .bottomLeft], radius: 5.0)
		//UIViewHelper.roundCorners(view: self.coverView, corners: [.topRight, .bottomRight], radius: 4)
		
		self.coverView.layer.borderWidth	= 1.0;
		self.coverView.layer.borderColor 	= UIColor.darkGray.cgColor
		self.coverView.layer.masksToBounds 	= true;
		
		
		UIViewHelper.setShadow(view: self.coverView)
		
		// Setup coverViewTapGestureRecognizer
		self.coverViewTapGestureRecognizer.addTarget(self, action: #selector(VolumesCollectionViewCell.coverViewTapped))
		self.coverView.addGestureRecognizer(self.coverViewTapGestureRecognizer)
		
	}
	
	fileprivate func setupVolumeCommentsButtonView() {
		
		UIViewHelper.makeCircle(view: self.volumeCommentsButtonView)
	
		// Setup volumeCommentsButtonViewTapGestureRecognizer
		self.volumeCommentsButtonViewTapGestureRecognizer.addTarget(self, action: #selector(VolumesCollectionViewCell.volumeCommentsButtonViewTapped))
		self.volumeCommentsButtonView.addGestureRecognizer(self.volumeCommentsButtonViewTapGestureRecognizer)
		
	}
	
	fileprivate func displayItem() {
		
		guard (self.item != nil) else { return }
		
		self.displayTitle()
		self.displayDatePublished()
		self.displayNumberofPages()
		self.displayCover()
		self.displayLatestVolumeComment()
		
	}
	
	fileprivate func displayTitle() {
		
		// titleLabel
		self.titleLabel.text = self.item!.title
		
	}
	
	fileprivate func displayDatePublished() {
		
		// Get datePublishedString from dateFormatter
		let dateFormatter				= DateFormatter()
		dateFormatter.dateFormat		= "MMM d, yyyy"
		dateFormatter.timeZone 			= TimeZone(secondsFromGMT: 0)
		
		let datePublishedString			= dateFormatter.string(from: self.item!.datePublished)
		
		self.datePublishedLabel.text 	= datePublishedString
		
	}
	
	fileprivate func displayNumberofPages() {
		
		var localizedStringKey: 			String = "PageN"

		if (self.item!.numberofPages == 1) {
			localizedStringKey = "Page1"
		}

		// Get numberofPagesText from localized string
		let numberofPagesTextLocalized:		String = NSLocalizedString(localizedStringKey, comment: "")
		let numberofPagesText: 				String = String(format: numberofPagesTextLocalized, String(self.item!.numberofPages))
			
		// numberofPagesLabel
		self.numberofPagesLabel.text 		= numberofPagesText
		
	}
	
	fileprivate func displayCover() {
		
		DispatchQueue.main.async {
			
			if (self.item!.coverThumbnailImageData != nil) {
				
				// Create coverThumbnailImage
				let coverThumbnailImage: UIImage? = UIImage(data: self.item!.coverThumbnailImageData!)
				
				if (coverThumbnailImage != nil) {
					
					// Set coverThumbnailImage
					self.set(coverThumbnailImage: coverThumbnailImage!)

				} else {
					
					self.set(coverThumbnailImage: nil)
				}
				
			} else {
				
				self.set(coverThumbnailImage: nil)
				
			}
			
			if (self.item!.coverColor.count > 0) {
				
				let cg: UIColor = UIColorHelper.toColor(hex: self.item!.coverColor)
				
				self.coverView.backgroundColor = cg
				
			} else {
				
				self.coverView.backgroundColor = UIColorHelper.randomColor()
				
			}
		
		}
	
	}
	
	fileprivate func presentCoverImageView() {
		
		DispatchQueue.main.async {
			
			self.coverImageView.alpha 	= 1
			self.titleLabel.alpha 		= 0
			
		}
		
	}

	fileprivate func hideCoverImageView() {
		
		DispatchQueue.main.async {
			
			self.coverImageView.alpha 	= 0
			self.titleLabel.alpha 		= 1
			
		}

	}
	
	fileprivate func displayLatestVolumeComment() {

		// Check latestVolumeCommentText
		if (self.item!.latestVolumeCommentText.count > 0) {
			
			// itemLatestVolumeCommentView
			self.itemLatestVolumeCommentView.alpha 			= 1
			
			self.latestVolumeCommentTextLabel.text 			= "\"" + self.item!.latestVolumeCommentText + "\""
			self.latestVolumeCommentPostedByNameLabel.text 	= self.item!.latestVolumeCommentPostedByName
			
			// Get latestVolumeCommentDatePostedString from dateFormatter
			let dateFormatter									= DateFormatter()
			dateFormatter.dateFormat							= "MMM d, yyyy"
			dateFormatter.timeZone 								= TimeZone(secondsFromGMT: 0)
			
			let latestVolumeCommentDatePostedString 			= dateFormatter.string(from: self.item!.latestVolumeCommentDatePosted)
			
			// latestVolumeCommentDatePostedLabel
			self.latestVolumeCommentDatePostedLabel.text 		= ", " + latestVolumeCommentDatePostedString
			
			// Get seeAllVolumeCommentsText from localized string
			let seeAllVolumeCommentsTextLocalized 				= NSLocalizedString("SeeAllVolumeComments", comment: "")
			
			let numberofVolumeCommentsString					= String(self.item!.numberofVolumeComments)
			let seeAllVolumeCommentsText						= String(format: seeAllVolumeCommentsTextLocalized, numberofVolumeCommentsString)
			
			// seeAllVolumeCommentsButton
			self.seeAllVolumeCommentsButton.setTitle(seeAllVolumeCommentsText, for: .normal)
			
		} else {
			
			// itemLatestVolumeCommentView
			self.itemLatestVolumeCommentView.alpha = 0
			
		}
		
	}
	
	fileprivate func setHeights() {
		
		// Get maxHeight for latestVolumeCommentTextLabel
		let maxHeight: CGFloat = self.coverView.frame.height - self.seeAllVolumeCommentsButton.frame.height - 5 - self.latestVolumeCommentPostedByNameLabel.frame.height - 5
		
		self.latestVolumeCommentTextLabel.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight).isActive = true
		
	}
	
	
	// MARK: - likeButton Methods
	
	@IBAction func likeButtonTapped(_ sender: Any) {
		
		// Create completion handler
		let didTapLikeButtonCompletionHandler: (() -> Void) =
		{
			() -> Void in
			
			//self.displayNumberofLikes()
		}
		
		// Notify the delegate
		self.delegate!.volumesCollectionViewCell(cell: self, didTapLikeButton: self.item!, oncomplete: didTapLikeButtonCompletionHandler)
	}
	
	
	// MARK: - volumeCommentsButton Methods
	
	@IBAction func volumeCommentsButtonTapped(_ sender: Any) {
		
		// Notify the delegate
		self.delegate!.volumesCollectionViewCell(cell: self, didTapCommentsButton: self.item!)
		
	}
	
	
	// MARK: - volumeCommentsButtonView TapGestureRecognizer Methods
	
	@IBAction func volumeCommentsButtonViewTapped(_ sender: Any) {
		
		// Notify the delegate
		self.delegate!.volumesCollectionViewCell(cell: self, didTapCommentsButton: self.item!)
		
	}
	
	
	// MARK: - seeAllVolumeCommentsButton Methods
	
	@IBAction func seeAllVolumeCommentsButtonTapped(_ sender: Any) {
		
		// Notify the delegate
		self.delegate!.volumesCollectionViewCell(cell: self, didTapCommentsButton: self.item!)
		
	}
	
	
	// MARK: - coverView TapGestureRecognizer Methods
	
	@IBAction func coverViewTapped(_ sender: Any) {
		
		// Notify the delegate
		self.delegate!.volumesCollectionViewCell(cell: self, didTapCover: self.item!)
		
	}
	
}
