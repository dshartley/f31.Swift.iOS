//
//  ProtocolVolumesCollectionViewCellDelegate.swift
//  f31
//
//  Created by David on 12/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import f31Core
import f31Model

/// Defines a delegate for a VolumesCollectionViewCell class
public protocol ProtocolVolumesCollectionViewCellDelegate {
	
	// MARK: - Methods
	
	func volumesCollectionViewCell(cell: VolumesCollectionViewCell, didTapCover item: VolumeWrapper)
	
	func volumesCollectionViewCell(cell: VolumesCollectionViewCell, didTapLikeButton item: VolumeWrapper, oncomplete completionHandler:@escaping () -> Void)

	func volumesCollectionViewCell(cell: VolumesCollectionViewCell, didTapCommentsButton item: VolumeWrapper)
	
}
