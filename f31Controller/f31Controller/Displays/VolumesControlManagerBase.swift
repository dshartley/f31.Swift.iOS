//
//  VolumesControlManagerBase.swift
//  f31Controller
//
//  Created by David on 10/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import CoreData
import SFCore
import SFController
import SFNet
import SFSecurity
import SFSerialization
import SFView
import f31Core
import f31Model

/// A base class for classes which manage the volumes control layer
public class VolumesControlManagerBase: ControlManagerBase  {

	// MARK: - Private Stored Properties
	
	fileprivate let numberofItemsToLoad:					Int = 10
	fileprivate var isLoadingVolumeContentDataYN:			Bool = false
	fileprivate var isLoadingAwardsDataYN:					Bool = false
	fileprivate var isLoadingNewsSnippetsDataYN:			Bool = false
	fileprivate var volumeImagesUrlRoot:					String? = nil
	fileprivate var awardImagesUrlRoot:						String? = nil
	fileprivate var newsSnippetImagesUrlRoot:				String? = nil
	fileprivate var onSignInSuccessfulCompletionHandler: 	((Error?) -> Void)? = nil
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:								ProtocolVolumesControlManagerBaseDelegate?
	public var selectedVolume:								VolumeWrapper? = nil
	public var previousVolumeID:							Int = 0
	public var selectedDaughter:							Daughters = .elena
	public var selectedYear:								Int = 2013
	public fileprivate(set) var isSignedInYN: 				Bool = false
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager) {
		super.init(modelManager: modelManager)

	}
	
	
	// MARK: - Public Methods
	
	public func setupCacheing(managedObjectContext:	NSManagedObjectContext) {
		
		VolumesCacheManager.shared.set(managedObjectContext: managedObjectContext)
		VolumeContentDataCacheManager.shared.set(managedObjectContext: managedObjectContext)
		AwardsCacheManager.shared.set(managedObjectContext: managedObjectContext)
		NewsSnippetsCacheManager.shared.set(managedObjectContext: managedObjectContext)
		
	}
	
	public func setUrls(volumeImagesUrlRoot: String,
						awardImagesUrlRoot: String,
						newsSnippetImagesUrlRoot: String) {
		
		self.volumeImagesUrlRoot 		= volumeImagesUrlRoot
		self.awardImagesUrlRoot 		= awardImagesUrlRoot
		self.newsSnippetImagesUrlRoot 	= newsSnippetImagesUrlRoot
		
	}
	
	
	// MARK: - Public Methods
	
	public func checkIsSignedIn() -> Bool {
	
		self.isSignedInYN = self.isSignedInYN()

		return self.isSignedInYN
		
	}
	
	public func signIn(password: String, onSignInSuccessful completionHandler: ((Error?) -> Void)?) {
		
		// If a completionHandler is specified then set it, otherwise retain the existing completionHandler
		if (completionHandler != nil) {
			
			self.onSignInSuccessfulCompletionHandler = completionHandler
			
		}
		
		let email = ""	// Not required
		
		// Sign in
		AuthenticationManager.shared.signIn(withEmail: email, password: password)
	}
	
	public override func onSignInSuccessful(userProperties: UserProperties) {
		
		self.isSignedInYN = true
		
		// Call completion handler
		self.onSignInSuccessfulCompletionHandler?(nil)
		
	}
	
	public override func onSignInFailed(userProperties: UserProperties?,
										error: 			Error?,
										code: 			AuthenticationErrorCodes?) {
		
		self.isSignedInYN = false
		
		// Notify the delegate
		self.delegate?.volumesControlManagerBase(signInFailed: self)
		
	}
	
	
	// MARK: - Volumes
	
	public func loadVolumes(selectItemsAfterPreviousYN: Bool, oncomplete completionHandler:@escaping ([VolumeWrapper], Error?) -> Void) {

		// Get authorID
		let authorID: Int = self.getAuthorID(from: self.selectedDaughter)
		
		// Check is connected
		if (self.checkIsConnected()) {
			
			// Create completion handler
			let loadVolumesFromDataSourceCompletionHandler: (([VolumeWrapper]?, Error?) -> Void) =
			{
				(items, error) -> Void in
				
				if (items != nil && error == nil) {
					
					// Get the collection
					if let collection = self.getVolumeModelAdministrator().collection as? VolumeCollection {
						
						// Merge to cache
						VolumesCacheManager.shared.mergeToCache(from: collection)
					}
					
					// Save to cache
					VolumesCacheManager.shared.saveToCache()
					
					// Call completion handler
					completionHandler(items!, error)
					
				} else {
					
					// Load from cache
					self.loadVolumesFromCache(selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, authorID: authorID, year: self.selectedYear, oncomplete: completionHandler)
					
				}

			}
			
			// Load from cache
			if (VolumesCacheManager.shared.collection == nil) {
				
				// Setup the cache
				VolumesCacheManager.shared.set(year: self.selectedYear, authorID: authorID)
				
				VolumesCacheManager.shared.loadFromCache()
			}
			
			// Load from data source
			self.loadVolumesFromDataSource(selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, authorID: authorID, year: self.selectedYear, oncomplete: loadVolumesFromDataSourceCompletionHandler)
			
		} else {

			// Load from cache
			self.loadVolumesFromCache(selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, authorID: authorID, year: self.selectedYear, oncomplete: completionHandler)

		}
		
	}
	
	public func getVolumeModelAdministrator() -> VolumeModelAdministrator {
		
		return (self.modelManager! as! ModelManager).getVolumeModelAdministrator!
	}
	
	public func loadVolumeCoverThumbnailImageData(for item: VolumeWrapper, oncomplete completionHandler:@escaping (Data?, Error?) -> Void) {
		
		let fileName: String	= item.coverThumbnailImageFileName
		
		// Create completion handler
		let loadImageDataCompletionHandler: ((Bool, Data?) -> Void) =
		{
			(isCachedYN, imageData) -> Void in
		
			if (imageData != nil) {
				
				item.coverThumbnailImageData = imageData
				
				if (!isCachedYN) {
					
					// Save to cache
					VolumesCacheManager.shared.saveImageToCache(imageData: imageData!, fileName: fileName)
				}
				
			} else {
				// Error
			}
			
			// Call completion handler
			completionHandler(imageData, nil)
			
		}
		
		// Load image data
		self.loadImageData(fileName: fileName, urlRoot: self.volumeImagesUrlRoot!, oncomplete: loadImageDataCompletionHandler)
		
	}
	
	public func loadVolumeAssetsImageData(for item: VolumeWrapper, byGroupKey groupKey: String, oncomplete completionHandler:@escaping (VolumeWrapper, Error?) -> Void) {
		
		// Get image assets
		let assets: [VolumeAssetWrapper] = item.get(assetsByGroupKey: groupKey, type: .Image)
		
		guard (assets.count > 0) else {
		
			// Call completion handler
			completionHandler(item, nil)
			
			return
			
		}
		
		// Go through each item
		for vaw in assets {
			
			// Get imageFileName from the VolumeAssetWrapper
			let imageFileName: String?	= vaw.get(attribute: "\(VolumeAssetAttributes.ImageFileName)") as? String
			
			// Create completion handler
			let loadImageDataCompletionHandler: ((Bool, Data?) -> Void) =
			{
				[unowned self] (isCachedYN, imageData) -> Void in
				
				if (imageData != nil) {
					
					// Set imageData in the VolumeAssetWrapper
					vaw.set(attribute: "\(VolumeAssetAttributes.ImageData)", value: imageData!)
					
					if (!isCachedYN) {
						
						// Save to cache
						VolumesCacheManager.shared.saveImageToCache(imageData: imageData!, fileName: imageFileName!)
						
					}
					
				} else {
					// Error
				}
				
				vaw.isLoadedYN = true
				
				// Check assets loaded
				if (self.checkAssetsLoadedYN(volumeAssetWrappers: assets)) {
					
					// Call completion handler
					completionHandler(item, nil)
					
				}

			}
			
			if (imageFileName != nil) {
	
				// Load image data
				self.loadImageData(fileName: imageFileName!, urlRoot: self.volumeImagesUrlRoot!, oncomplete: loadImageDataCompletionHandler)
				
			}
		
		}
	
	}
	
	public func likeVolume() {
		
		guard (self.selectedVolume != nil) else { return }
		
		self.likeVolume(for: self.selectedVolume!)
		
	}
	
	public func likeVolume(for item: VolumeWrapper) {
		
		// Check is connected
		guard (self.checkIsConnected()) else { return }
		
		// Add like
		self.getVolumeModelAdministrator().addLike(id: Int(item.id)!)
		
		// Update item
		item.numberofLikes += 1
		
		// Update the item in the cache
		if let collection = VolumesCacheManager.shared.collection {
			
			let volume: Volume? = collection.getItem(id: String(item.id)) as? Volume
			
			if let volume = volume {
				
				volume.numberofLikes = item.numberofLikes
				
				// Save to cache
				VolumesCacheManager.shared.saveToCache()
			}
		}
	}
	
	
	// MARK: - VolumeContentData
	
	public func loadVolumeContentData(for item: VolumeWrapper, oncomplete completionHandler:@escaping (VolumeWrapper?, Error?) -> Void) {
		
		// Check is connected
		if (self.checkIsConnected()) {
			
			// Create completion handler
			let loadVolumeContentDataFromDataSourceCompletionHandler: ((VolumeWrapper?, Error?) -> Void) =
			{
				[unowned self] (item, error) -> Void in
			
				guard (item != nil && error == nil) else {
					
					// Call completion handler
					completionHandler(item, NSError())
					
					return
					
				}
				
				if (item!.volumeContentData != nil) {
					
					// Setup the cache
					VolumeContentDataCacheManager.shared.set(volumeID: Int(item!.id)!)
					
					// Save to cache
					VolumeContentDataCacheManager.shared.saveStringToCache(dataString: item!.contentData)
					
					// Call completion handler
					completionHandler(item, nil)
					
				} else {
					
					// Load from cache
					self.loadVolumeContentDataFromCache(item: item!, oncomplete: completionHandler)
					
				}
				
			}
			
			// Load from data source
			self.loadVolumeContentDataFromDataSource(item: item, oncomplete: loadVolumeContentDataFromDataSourceCompletionHandler)
			
		} else {
			
			// Load from cache
			self.loadVolumeContentDataFromCache(item: item, oncomplete: completionHandler)
			
		}
		
	}
	
	
	// MARK: - Awards
	
	public func loadAwards(oncomplete completionHandler:@escaping ([AwardWrapper], Error?) -> Void) {
		
		// Get authorID
		let authorID: Int  = self.getAuthorID(from: self.selectedDaughter)
		
		// Create completion handler
		let loadAwardsCompletionHandler: (([AwardWrapper]?, Error?) -> Void) =
		{
			[unowned self] (items, error) -> Void in
			
			if (items != nil && error == nil) {
				
				// Load images
				self.loadAwardsImages(items: items!, oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(items!, error)
				
			}
			
		}
		
		// Check is connected
		if (self.checkIsConnected()) {
		
			// Create completion handler
			let loadAwardsFromDataSourceCompletionHandler: (([AwardWrapper]?, Error?) -> Void) =
			{
				[unowned self] (items, error) -> Void in
				
				if (items != nil && error == nil) {
					
					// Get the collection
					if let collection = self.getAwardModelAdministrator().collection as? AwardCollection {
						
						// Merge to cache
						AwardsCacheManager.shared.mergeToCache(from: collection)
					}
					
					// Save to cache
					AwardsCacheManager.shared.saveToCache()
					
					// Call completion handler
					loadAwardsCompletionHandler(items!, error)
					
				} else {
					
					// Load from cache
					self.loadAwardsFromCache(authorID: authorID, year: self.selectedYear, oncomplete: loadAwardsCompletionHandler)
					
				}
				
			}
		
			// Load from cache
			if (AwardsCacheManager.shared.collection == nil) {
				
				// Setup the cache
				AwardsCacheManager.shared.set(year: self.selectedYear, authorID: self.getAuthorID(from: self.selectedDaughter))
				
				AwardsCacheManager.shared.loadFromCache()
			}
		
			// Load from data source
			self.loadAwardsFromDataSource(authorID: authorID, year: self.selectedYear, oncomplete: loadAwardsFromDataSourceCompletionHandler)
			
		} else {

			// Load from cache
			self.loadAwardsFromCache(authorID: authorID, year: self.selectedYear, oncomplete: loadAwardsCompletionHandler)

		}
		
	}
	
	public func getAwardModelAdministrator() -> AwardModelAdministrator {
		
		return (self.modelManager! as! ModelManager).getAwardModelAdministrator!
	}
	
	public func loadAwardImageData(for item: AwardWrapper, oncomplete completionHandler:@escaping (Data?, Error?) -> Void) {
		
		let fileName: String	= item.imageFileName
		
		// Create completion handler
		let loadImageDataCompletionHandler: ((Bool, Data?) -> Void) =
		{
			(isCachedYN, imageData) -> Void in
			
			if (imageData != nil && UIImage(data: imageData!) != nil) {
				
				item.imageData = imageData
				
				if (!isCachedYN) {
					
					// Save to cache
					AwardsCacheManager.shared.saveImageToCache(imageData: imageData!, fileName: fileName)
				}
				
			} else {
				// Error
			}
			
			// Call completion handler
			completionHandler(imageData, nil)
			
		}
		
		// Load image data
		self.loadImageData(fileName: fileName, urlRoot: self.awardImagesUrlRoot!, oncomplete: loadImageDataCompletionHandler)
		
	}
	

	// MARK: - NewsSnippets
	
	public func loadNewsSnippets(oncomplete completionHandler:@escaping ([NewsSnippetWrapper], Error?) -> Void) {
		
		// Get authorID
		let authorID: Int  = self.getAuthorID(from: self.selectedDaughter)

		// Create completion handler
		let loadNewsSnippetsCompletionHandler: (([NewsSnippetWrapper]?, Error?) -> Void) =
		{
			[unowned self] (items, error) -> Void in
			
			if (items != nil && error == nil) {
				
				// Load images
				self.loadNewsSnippetsImages(items: items!, oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(items!, error)
				
			}
			
		}
		
		// Check is connected
		if (self.checkIsConnected()) {
			
			// Create completion handler
			let loadNewsSnippetsFromDataSourceCompletionHandler: (([NewsSnippetWrapper]?, Error?) -> Void) =
			{
				[unowned self] (items, error) -> Void in
				
				if (items != nil && error == nil) {
					
					// Get the collection
					if let collection = self.getNewsSnippetModelAdministrator().collection as? NewsSnippetCollection {
						
						// Merge to cache
						NewsSnippetsCacheManager.shared.mergeToCache(from: collection)
					}
					
					// Save to cache
					NewsSnippetsCacheManager.shared.saveToCache()
					
					// Call completion handler
					loadNewsSnippetsCompletionHandler(items!, error)
					
				} else {
					
					// Load from cache
					self.loadNewsSnippetsFromCache(authorID: authorID, year: self.selectedYear, oncomplete: loadNewsSnippetsCompletionHandler)
					
				}
				
			}
			
			// Check cache is loaded
			if (NewsSnippetsCacheManager.shared.collection == nil) {
				
				// Setup the cache
				NewsSnippetsCacheManager.shared.set(year: self.selectedYear, authorID: self.getAuthorID(from: self.selectedDaughter))
				
				// Load from cache
				NewsSnippetsCacheManager.shared.loadFromCache()
			}
			
			// Load from data source
			self.loadNewsSnippetsFromDataSource(authorID: authorID, year: self.selectedYear, oncomplete: loadNewsSnippetsFromDataSourceCompletionHandler)
			
		} else {
			
			// Load from cache
			self.loadNewsSnippetsFromCache(authorID: authorID, year: self.selectedYear, oncomplete: loadNewsSnippetsCompletionHandler)
			
		}
		
	}
	
	public func getNewsSnippetModelAdministrator() -> NewsSnippetModelAdministrator {
		
		return (self.modelManager! as! ModelManager).getNewsSnippetModelAdministrator!
	}
	
	public func loadNewsSnippetImageData(for item: NewsSnippetWrapper, oncomplete completionHandler:@escaping (Data?, Error?) -> Void) {
		
		let fileName: String	= item.imageFileName
		
		guard (fileName.count > 0) else {
			
			// Call completion handler
			completionHandler(nil, nil)
			return
			
		}
		
		// Create completion handler
		let loadImageDataCompletionHandler: ((Bool, Data?) -> Void) =
		{
			(isCachedYN, imageData) -> Void in
			
			if (imageData != nil && UIImage(data: imageData!) != nil) {
				
				item.imageData = imageData
				
				if (!isCachedYN) {
					
					// Save to cache
					NewsSnippetsCacheManager.shared.saveImageToCache(imageData: imageData!, fileName: fileName)
				}
				
			} else {
				// Error
			}
			
			// Call completion handler
			completionHandler(imageData, nil)
			
		}
		
		// Load image data
		self.loadImageData(fileName: fileName, urlRoot: self.newsSnippetImagesUrlRoot!, oncomplete: loadImageDataCompletionHandler)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func loadAwardsImages(items: [AwardWrapper], oncomplete completionHandler:@escaping ([AwardWrapper], Error?) -> Void) {
		
		var loadAwardImageDataResultCount: Int = 0
		
		// Create completion handler
		let loadAwardImageDataCompletionHandler: ((Data?, Error?) -> Void) =
		{
			(data, error) -> Void in

			loadAwardImageDataResultCount += 1
			
			// Call completion handler
			if (loadAwardImageDataResultCount >= items.count) {
				
				completionHandler(items, nil)
				
			}

		}

		// Go through each item
		for item in items {

			// Load image data
			self.loadAwardImageData(for: item, oncomplete: loadAwardImageDataCompletionHandler)

		}
		
	}
	
	fileprivate func loadNewsSnippetsImages(items: [NewsSnippetWrapper], oncomplete completionHandler:@escaping ([NewsSnippetWrapper], Error?) -> Void) {
		
		guard (items.count > 0) else {
			
			// Call completion handler
			completionHandler(items, nil)
			
			return
			
		}
		
		var loadNewsSnippetImageDataResultCount: Int = 0
		
		// Create completion handler
		let loadNewsSnippetImageDataCompletionHandler: ((Data?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			loadNewsSnippetImageDataResultCount += 1
			
			if (loadNewsSnippetImageDataResultCount >= items.count) {
				
				// Call completion handler
				completionHandler(items, nil)
				
			}
			
		}
		
		// Go through each item
		for item in items {
			
			// Load image data
			self.loadNewsSnippetImageData(for: item, oncomplete: loadNewsSnippetImageDataCompletionHandler)
			
		}
		
	}
	
	fileprivate func loadImageData(fileName: String, urlRoot: String, oncomplete completionHandler:@escaping (Bool, Data?) -> Void) {
		
		var imageData: Data? = nil
		
		// Load image from cache
		imageData = VolumesCacheManager.shared.loadImageFromCache(with: fileName)
		
		if (imageData != nil) {
			
			let isCachedYN: Bool = true
			
			// Call completion handler
			completionHandler(isCachedYN, imageData)
			
		} else {
		
			// Check is connected
			if (self.checkIsConnected()) {

				// Load image from URL
				self.loadImageDataFromUrl(fileName: fileName, urlRoot: urlRoot, oncomplete: completionHandler)
				
			} else {
				
				// Notify the delegate
				self.delegate?.volumesControlManagerBase(isNotConnected: nil)
				
			}
			
		}
	}
	
	fileprivate func loadImageDataFromUrl(fileName: String, urlRoot: String, oncomplete completionHandler:@escaping (Bool, Data?) -> Void) {
		
		guard (self.checkIsConnected()) else {
			
			// Call completion handler
			completionHandler(false, nil)
			
			return
		}
		
		let url:		URL					= URL(string: urlRoot + fileName)!
		let session:	URLSession			= URLSession.shared
		let request:	URLRequest			= URLRequest(url: url)
		
		let task:		URLSessionDataTask	= session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
			
			if let data = data {
				
				let isCachedYN: Bool = false
				
				// Call completion handler
				completionHandler(isCachedYN, data)
			}
			
		})
		
		task.resume()
	}
	
	fileprivate func getAuthorID(from daughter: Daughters) -> Int {
		
		var result: Int = 1
		
		if (self.selectedDaughter == .sofia) {
			result = 2
		}
		
		return result
	}
	
	fileprivate func setStateBeforeLoad(selectItemsAfterPreviousYN: Bool) {
		
		self.isLoadingDataYN									= true
		self.previousVolumeID									= 0
		
		if (selectItemsAfterPreviousYN) {
			
			VolumeWrappers.hasLoadedAllNextItemsYN				= true
			self.previousVolumeID								= Int(VolumeWrappers.items.last?.id ?? "0")!
			
			// Check previousVolumeID is 0
			if (self.previousVolumeID == 0) {
				VolumeWrappers.hasLoadedAllPreviousItemsYN		= true
			}
			
		} else {
			
			VolumeWrappers.hasLoadedAllPreviousItemsYN			= true
			self.previousVolumeID								= Int(VolumeWrappers.items.first?.id ?? "0")!
			
			// Check previousVolumeID is 0
			if (self.previousVolumeID == 0) {
				VolumeWrappers.hasLoadedAllNextItemsYN			= true
			}
		}
	}
	
	
	// MARK: - Volumes
	
	fileprivate func loadVolumesFromDataSource(selectItemsAfterPreviousYN: Bool, authorID: Int, year: Int, oncomplete completionHandler:@escaping ([VolumeWrapper]?, Error?) -> Void) {
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var result: [VolumeWrapper]? = nil
			
			if (data != nil && error == nil) {
				
				// Copy items to wrappers array
				result = self.loadedVolumesToWrappers(appendYN: selectItemsAfterPreviousYN)
			}

			// Set state
			self.setStateAfterLoad()
			
			// Call completion handler
			completionHandler(result, error)
		}
		
		// Set state
		self.setStateBeforeLoad(selectItemsAfterPreviousYN: selectItemsAfterPreviousYN)

		// Load data
		self.getVolumeModelAdministrator().select(byPreviousVolumeID: self.previousVolumeID, authorID: authorID, year: year, numberofItemsToLoad: self.numberofItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, oncomplete: loadCompletionHandler)
	}
	
	fileprivate func loadVolumesFromCache(selectItemsAfterPreviousYN: Bool, authorID: Int, year: Int, oncomplete completionHandler:@escaping ([VolumeWrapper], Error?) -> Void) {
		
		// Check cache is loaded
		if (VolumesCacheManager.shared.collection == nil) {
			
			// Setup the cache
			VolumesCacheManager.shared.set(year: self.selectedYear, authorID: self.getAuthorID(from: self.selectedDaughter))
			
			// Load from cache
			VolumesCacheManager.shared.loadFromCache()
		}
		
		// Set state
		self.setStateBeforeLoad(selectItemsAfterPreviousYN: selectItemsAfterPreviousYN)
		
		// Select items from the cache
		let cacheData: [Any] = VolumesCacheManager.shared.select(byPreviousVolumeID: self.previousVolumeID, numberofItemsToLoad: self.numberofItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN)
		
		// Put loaded data into the model administrator collection
		self.getVolumeModelAdministrator().load(data: cacheData)
		
		// Copy items to wrappers array
		let result: [VolumeWrapper] = self.loadedVolumesToWrappers(appendYN: selectItemsAfterPreviousYN)

		// Set state
		self.setStateAfterLoad()
		
		// Call completion handler
		completionHandler(result, nil)
		
	}

	fileprivate func loadedVolumesToWrappers(appendYN: Bool) -> [VolumeWrapper] {
		
		var result:						[VolumeWrapper]	= [VolumeWrapper]()
		
		if let collection = self.getVolumeModelAdministrator().collection {
			
			let collection:				VolumeCollection	= collection as! VolumeCollection
			
			var numberofItemsAdded:		Int = 0
			
			// Go through each item
			for item in collection.items! {
				
				let item = item as! Volume
				
				// Nb: It is not ideal putting this here, but it handles the case where coverColor has not been set in the data source, and the data can then be saved to the cache
				// Set cover color if it has not been set
				if (item.coverColor.count == 0) {
					
					item.coverColor = UIColorHelper.toHex(color: UIColorHelper.randomColor())
					
				}
				
				// Check not added more items than numberofItemsToLoad
				if (numberofItemsAdded < self.numberofItemsToLoad) {
					
					// Include items that are not deleted or obsolete
					if (item.status != .deleted && item.status != .obsolete) {
						
						// Get item wrapper
						let wrapper: VolumeWrapper = item.toWrapper()
						
						result.append(wrapper)
						
						numberofItemsAdded += 1
					}					
					
				}

			}
			
			if (!appendYN && result.count > 0) {
			
				// Prepend to volume wrappers
				VolumeWrappers.items.insert(contentsOf: result, at: 0)
				
				// Check number of items in result
				if (result.count >= self.numberofItemsToLoad) { VolumeWrappers.hasLoadedAllPreviousItemsYN = false }

			} else if (appendYN && result.count > 0) {
				
				// Append to volume wrappers
				VolumeWrappers.items.append(contentsOf: result)
				
				// Check number of items in result
				if (result.count >= self.numberofItemsToLoad) { VolumeWrappers.hasLoadedAllNextItemsYN = false }

			}

		}
		
		return result
	}
	
	fileprivate func checkAssetsLoadedYN(volumeAssetWrappers: [VolumeAssetWrapper]) -> Bool {
		
		var result: Bool = true
		
		// Go through each item
		for vaw in volumeAssetWrappers {
			
			if (!vaw.isLoadedYN) {
			
				result = false

			}
			
		}
		
		return result
		
	}
	
	fileprivate func setCoverColors() {
		
	}
	
	
	// MARK: - VolumeContentData
	
	fileprivate func setStateBeforeLoadVolumeContentData() {
		
		self.isLoadingVolumeContentDataYN = true
		
	}
	
	fileprivate func setStateAfterLoadVolumeContentData() {
		
		self.isLoadingVolumeContentDataYN = false
		
	}
	
	fileprivate func loadVolumeContentDataFromDataSource(item: VolumeWrapper, oncomplete completionHandler:@escaping (VolumeWrapper?, Error?) -> Void) {

		// Create completion handler
		let getContentDataCompletionHandler: ((String?, Error?) -> Void) =
		{
			[unowned self] (data, error) -> Void in
			
			// Set state
			self.setStateAfterLoadVolumeContentData()
			
			if (data != nil && error == nil) {
				
				// Set in VolumeWrapper
				item.set(contentData: data!)
				
			}
			
			// Call completion handler
			completionHandler(item, error)
			
		}
		
		// Set state
		self.setStateBeforeLoadVolumeContentData()
		
		// Load data
		self.getVolumeModelAdministrator().getContentData(forVolume: item.id, oncomplete: getContentDataCompletionHandler)
		
	}
	
	fileprivate func loadVolumeContentDataFromCache(item: VolumeWrapper, oncomplete completionHandler:@escaping (VolumeWrapper?, Error?) -> Void) {
		
		// Setup the cache
		VolumeContentDataCacheManager.shared.set(volumeID: Int(item.id)!)
		
		// Load from cache
		let result: String? = VolumeContentDataCacheManager.shared.loadStringFromCache()

		// Set state
		self.setStateBeforeLoadVolumeContentData()
		
		if (result != nil) {
			
			// Set in VolumeWrapper
			item.set(contentData: result!)
			
		}

		// Set state
		self.setStateAfterLoadVolumeContentData()
		
		// Call completion handler
		completionHandler(item, nil)
		
	}
	
	
	// MARK: - Awards
	
	fileprivate func setStateBeforeLoadAwards() {
		
		self.isLoadingAwardsDataYN = true

	}

	fileprivate func setStateAfterLoadAwards() {
		
		self.isLoadingAwardsDataYN = false
		
	}
	
	fileprivate func loadAwardsFromDataSource(authorID: Int, year: Int, oncomplete completionHandler:@escaping ([AwardWrapper]?, Error?) -> Void) {
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var result: [AwardWrapper]? = nil
			
			if (data != nil && error == nil) {
				
				// Copy items to wrappers array
				result = self.loadedAwardsToWrappers()
			}
			
			// Set state
			self.setStateAfterLoadAwards()
			
			// Call completion handler
			completionHandler(result, error)
		}
		
		// Set state
		self.setStateBeforeLoadAwards()
		
		// Load data
		self.getAwardModelAdministrator().select(byAuthorID: authorID, year: year, oncomplete: loadCompletionHandler)
		
	}
	
	fileprivate func loadAwardsFromCache(authorID: Int, year: Int, oncomplete completionHandler:@escaping ([AwardWrapper], Error?) -> Void) {
		
		// Check cache is loaded
		if (AwardsCacheManager.shared.collection == nil) {
			
			// Setup the cache
			AwardsCacheManager.shared.set(year: self.selectedYear, authorID: self.getAuthorID(from: self.selectedDaughter))
			
			// Load from cache
			AwardsCacheManager.shared.loadFromCache()
		}
		
		// Set state
		self.setStateBeforeLoadAwards()
		
		// Select items from the cache
		let cacheData: [Any] = AwardsCacheManager.shared.select()
		
		// Put loaded data into the model administrator collection
		self.getAwardModelAdministrator().load(data: cacheData)
		
		let result: [AwardWrapper] = self.loadedAwardsToWrappers()

		// Set state
		self.setStateAfterLoadAwards()
		
		// Call completion handler
		completionHandler(result, nil)
		
	}
	
	fileprivate func loadedAwardsToWrappers() -> [AwardWrapper] {
		
		var result:						[AwardWrapper]	= [AwardWrapper]()
		
		if let collection = self.getAwardModelAdministrator().collection {
			
			let collection:				AwardCollection	= collection as! AwardCollection

			// Go through each item
			for item in collection.items! {
				
				// Include items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) {
					
					// Get item wrapper
					let wrapper: AwardWrapper = (item as! Award).toWrapper()
					
					result.append(wrapper)

				}
				
			}
			
			if (result.count > 0) {
				
				// Append to wrappers
				AwardWrappers.items.append(contentsOf: result)
				
			}
			
		}
		
		return result
	}

	
	// MARK: - NewsSnippets
	
	fileprivate func setStateBeforeLoadNewsSnippets() {
		
		self.isLoadingNewsSnippetsDataYN = true
		
	}
	
	fileprivate func setStateAfterLoadNewsSnippets() {
		
		self.isLoadingNewsSnippetsDataYN = false
		
	}
	
	fileprivate func loadNewsSnippetsFromDataSource(authorID: Int, year: Int, oncomplete completionHandler:@escaping ([NewsSnippetWrapper]?, Error?) -> Void) {
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var result: [NewsSnippetWrapper]? = nil
			
			if (data != nil && error == nil) {
				
				// Copy items to wrappers array
				result = self.loadedNewsSnippetsToWrappers()
			}
			
			// Set state
			self.setStateAfterLoadNewsSnippets()
			
			// Call completion handler
			completionHandler(result, error)
		}
		
		// Set state
		self.setStateBeforeLoadNewsSnippets()
		
		// Load data
		self.getNewsSnippetModelAdministrator().select(byAuthorID: authorID, year: year, oncomplete: loadCompletionHandler)
		
	}
	
	fileprivate func loadNewsSnippetsFromCache(authorID: Int, year: Int, oncomplete completionHandler:@escaping ([NewsSnippetWrapper], Error?) -> Void) {
		
		// Check cache is loaded
		if (NewsSnippetsCacheManager.shared.collection == nil) {
			
			// Setup the cache
			NewsSnippetsCacheManager.shared.set(year: self.selectedYear, authorID: self.getAuthorID(from: self.selectedDaughter))
			
			// Load from cache
			NewsSnippetsCacheManager.shared.loadFromCache()
		}
		
		// Set state
		self.setStateBeforeLoadNewsSnippets()
		
		// Select items from the cache
		let cacheData: [Any] = NewsSnippetsCacheManager.shared.select()
		
		// Put loaded data into the model administrator collection
		self.getNewsSnippetModelAdministrator().load(data: cacheData)
		
		let result: [NewsSnippetWrapper] = self.loadedNewsSnippetsToWrappers()
		
		// Set state
		self.setStateAfterLoadNewsSnippets()
		
		// Call completion handler
		completionHandler(result, nil)
		
	}
	
	fileprivate func loadedNewsSnippetsToWrappers() -> [NewsSnippetWrapper] {
		
		var result:						[NewsSnippetWrapper]	= [NewsSnippetWrapper]()
		
		if let collection = self.getNewsSnippetModelAdministrator().collection {
			
			let collection:				NewsSnippetCollection	= collection as! NewsSnippetCollection
			
			// Go through each item
			for item in collection.items! {
				
				// Include items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) {
					
					// Get item wrapper
					let wrapper: NewsSnippetWrapper = (item as! NewsSnippet).toWrapper()
					
					result.append(wrapper)
					
				}
				
			}
			
			if (result.count > 0) {
				
				// Append to wrappers
				NewsSnippetWrappers.items.append(contentsOf: result)
				
			}
			
		}
		
		return result
	}

}
