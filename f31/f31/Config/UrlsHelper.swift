//
//  UrlsHelper.swift
//  f31
//
//  Created by David on 07/11/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import UIKit

/// A helper for handling Urls.strings
public final class UrlsHelper {

	// MARK: - Initializers
	
	private init () {}
	
	
	// MARK: - Static Computed Properties
	
	public static var volumeImagesUrlRoot: String = {
		
		let result: String = NSLocalizedString("VolumeImagesUrlRoot", tableName: "Urls", comment: "")

		return result
		
	}()
	
	public static var awardImagesUrlRoot: String = {
		
		let result: String = NSLocalizedString("AwardImagesUrlRoot", tableName: "Urls", comment: "")

		return result
		
	}()
	
	public static var newsSnippetImagesUrlRoot: String = {
		
		let result: String = NSLocalizedString("NewsSnippetImagesUrlRoot", tableName: "Urls", comment: "")

		return result

	}()
	
}
