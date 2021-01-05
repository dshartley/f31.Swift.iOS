//
//  Volume.swift
//  f31Model
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFSerialization
import f31Core

public enum VolumeDataParameterKeys {
	case ID
	case AuthorID
	case Title
	case DatePublished
	case CoverThumbnailImageFileName
	case CoverColor
	case NumberofPages
	case NumberofLikes
	case NumberofVolumeComments
	case LatestVolumeCommentDatePosted
	case LatestVolumeCommentPostedByName
	case LatestVolumeCommentText
	case ContentData
	case AssetType
	case GroupKey
	case NumberofItemsToLoad
	case SelectItemsAfterPreviousYN
}

/// Encapsulates a Volume model item
public class Volume: ModelItemBase {
	
	// MARK: - Public Stored Properties
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(collection: ProtocolModelItemCollection,
						 storageDateFormatter: DateFormatter) {
		super.init(collection: collection,
				   storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods
	
	let authoridKey: String = "AuthorID"
	
	/// Gets or sets the authorID
	public var authorID: String {
		get {
			
			return self.getProperty(key: authoridKey)!
		}
		set(value) {
			
			self.setProperty(key: authoridKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let titleKey: String = "Title"
	
	/// Gets or sets the title
	public var title: String {
		get {
			
			return self.getProperty(key: titleKey)!
		}
		set(value) {
			
			self.setProperty(key: titleKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let datepublishedKey: String = "DatePublished"
	
	/// Gets or sets the datePublished
	public var datePublished: Date {
		get {
			
			let dateString = self.getProperty(key: datepublishedKey)!
			
			return DateHelper.getDate(fromString: dateString, fromDateFormatter: self.storageDateFormatter!)
		}
		set(value) {
			
			self.setProperty(key: datepublishedKey, value: self.getStorageDateString(fromDate: value), setWhenInvalidYN: false)
		}
	}
	
	let coverthumbnailimagefilenameKey: String = "CoverThumbnailImageFileName"
	
	/// Gets or sets the coverThumbnailImageFileName
	public var coverThumbnailImageFileName: String {
		get {
			
			return self.getProperty(key: coverthumbnailimagefilenameKey)!
		}
		set(value) {
			
			self.setProperty(key: coverthumbnailimagefilenameKey, value: value, setWhenInvalidYN: false)
		}
	}

	let covercolorKey: String = "CoverColor"
	
	/// Gets or sets the coverColor
	public var coverColor: String {
		get {
			
			return self.getProperty(key: covercolorKey)!
		}
		set(value) {
			
			self.setProperty(key: covercolorKey, value: value, setWhenInvalidYN: false)
		}
	}

	let numberofpagesKey: String = "NumberofPages"
	
	/// Gets or sets the numberofPages
	public var numberofPages: Int {
		get {
			
			return Int(self.getProperty(key: numberofpagesKey)!)!
		}
		set(value) {
			
			self.setProperty(key: numberofpagesKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let numberoflikesKey: String = "NumberofLikes"
	
	/// Gets or sets the numberofLikes
	public var numberofLikes: Int {
		get {
			
			return Int(self.getProperty(key: numberoflikesKey)!)!
		}
		set(value) {
			
			self.setProperty(key: numberoflikesKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let numberofvolumecommentsKey: String = "NumberofVolumeComments"
	
	/// Gets or sets the numberofVolumeComments
	public var numberofVolumeComments: Int {
		get {
			
			return Int(self.getProperty(key: numberofvolumecommentsKey)!)!
		}
		set(value) {
			
			self.setProperty(key: numberofvolumecommentsKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let latestvolumecommentdatepostedKey: String = "LatestVolumeCommentDatePosted"
	
	/// Gets or sets the latestVolumeCommentDatePosted
	public var latestVolumeCommentDatePosted: Date {
		get {
			
			let dateString = self.getProperty(key: latestvolumecommentdatepostedKey)!
			
			return DateHelper.getDate(fromString: dateString, fromDateFormatter: self.storageDateFormatter!)
		}
		set(value) {
			
			self.setProperty(key: latestvolumecommentdatepostedKey, value: self.getStorageDateString(fromDate: value), setWhenInvalidYN: false)
		}
	}
	
	let latestvolumecommentpostedbynameKey: String = "LatestVolumeCommentPostedByName"
	
	/// Gets or sets the latestVolumeCommentPostedByName
	public var latestVolumeCommentPostedByName: String {
		get {
			
			return self.getProperty(key: latestvolumecommentpostedbynameKey)!
		}
		set(value) {
			
			self.setProperty(key: latestvolumecommentpostedbynameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let latestvolumecommenttextKey: String = "LatestVolumeCommentText"
	
	/// Gets or sets the latestVolumeCommentText
	public var latestVolumeCommentText: String {
		get {
			
			return self.getProperty(key: latestvolumecommenttextKey)!
		}
		set(value) {
			
			self.setProperty(key: latestvolumecommenttextKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let contentdataKey: String = "ContentData"
	
	/// Gets or sets the contentData
	public var contentData: String {
		get {
			
			return self.getProperty(key: contentdataKey)!
		}
		set(value) {
			
			self.setProperty(key: contentdataKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> VolumeWrapper {
		
		let wrapper = VolumeWrapper()
		
		wrapper.id									= self.id
		wrapper.authorID							= Int.init(self.authorID)!
		wrapper.title								= self.title
		wrapper.datePublished						= self.datePublished
		wrapper.coverThumbnailImageFileName			= self.coverThumbnailImageFileName
		wrapper.coverColor							= self.coverColor
		wrapper.numberofPages						= self.numberofPages
		wrapper.numberofLikes						= self.numberofLikes
		wrapper.numberofVolumeComments				= self.numberofVolumeComments
		wrapper.latestVolumeCommentDatePosted		= self.latestVolumeCommentDatePosted
		wrapper.latestVolumeCommentPostedByName		= self.latestVolumeCommentPostedByName
		wrapper.latestVolumeCommentText				= self.latestVolumeCommentText
		
		// Nb: This sets up the VolumeContentDataWrapper wrapper
		wrapper.set(contentData: self.contentData)
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: VolumeWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 					Bool = self.doValidationsYN
		self.doValidationsYN					= false
		
		// Copy all properties from the wrapper
		self.id									= wrapper.id
		self.authorID							= "\(wrapper.authorID)"
		self.title								= wrapper.title
		self.datePublished						= wrapper.datePublished
		self.coverThumbnailImageFileName		= wrapper.coverThumbnailImageFileName
		self.coverColor							= wrapper.coverColor
		self.numberofPages						= wrapper.numberofPages
		self.numberofLikes						= wrapper.numberofLikes
		self.numberofVolumeComments				= wrapper.numberofVolumeComments
		self.latestVolumeCommentDatePosted		= wrapper.latestVolumeCommentDatePosted
		self.latestVolumeCommentPostedByName	= wrapper.latestVolumeCommentPostedByName
		self.latestVolumeCommentText			= wrapper.latestVolumeCommentText
		self.contentData 						= wrapper.contentData
		
		self.doValidationsYN 					= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: authoridKey,	    				value: "0")
		self.doSetProperty(key: titleKey,	    					value: "")
		self.doSetProperty(key: datepublishedKey,	    			value: "1/1/1900")
		self.doSetProperty(key: coverthumbnailimagefilenameKey,	    value: "")
		self.doSetProperty(key: covercolorKey,	    				value: "")
		self.doSetProperty(key: numberofpagesKey,	    			value: "0")
		self.doSetProperty(key: numberoflikesKey,	    			value: "0")
		self.doSetProperty(key: numberofvolumecommentsKey,	    	value: "0")
		self.doSetProperty(key: latestvolumecommentdatepostedKey, 	value: "1/1/1900")
		self.doSetProperty(key: latestvolumecommentpostedbynameKey, value: "")
		self.doSetProperty(key: latestvolumecommenttextKey,	    	value: "")
		self.doSetProperty(key: contentdataKey,	    				value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.volume_id.rawValue
		endEnumIndex	= ModelProperties.volume_contentData.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]									= ModelProperties.volume_id.rawValue
		keys[authoridKey]							= ModelProperties.volume_authorID.rawValue
		keys[titleKey]								= ModelProperties.volume_title.rawValue
		keys[datepublishedKey]						= ModelProperties.volume_datePublished.rawValue
		keys[coverthumbnailimagefilenameKey]		= ModelProperties.volume_coverThumbnailImageFileName.rawValue
		keys[covercolorKey]							= ModelProperties.volume_coverColor.rawValue
		keys[numberofpagesKey]						= ModelProperties.volume_numberofPages.rawValue
		keys[numberoflikesKey]						= ModelProperties.volume_numberofLikes.rawValue
		keys[numberofvolumecommentsKey]				= ModelProperties.volume_numberofVolumeComments.rawValue
		keys[latestvolumecommentdatepostedKey]		= ModelProperties.volume_latestVolumeCommentDatePosted.rawValue
		keys[latestvolumecommentpostedbynameKey]	= ModelProperties.volume_latestVolumeCommentPostedByName.rawValue
		keys[latestvolumecommenttextKey]			= ModelProperties.volume_latestVolumeCommentText.rawValue
		keys[contentdataKey]						= ModelProperties.volume_contentData.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "Volume"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 						Bool = self.doValidationsYN
		self.doValidationsYN 						= false
		
		// Copy all properties from the specified item
		if let item = item as? Volume {
			
			self.id									= item.id
			self.authorID							= item.authorID
			self.title								= item.title
			self.datePublished						= item.datePublished
			self.coverThumbnailImageFileName		= item.coverThumbnailImageFileName
			self.coverColor							= item.coverColor
			self.numberofPages						= item.numberofPages
			self.numberofLikes						= item.numberofLikes
			self.numberofVolumeComments				= item.numberofVolumeComments
			self.latestVolumeCommentDatePosted		= item.latestVolumeCommentDatePosted
			self.latestVolumeCommentPostedByName	= item.latestVolumeCommentPostedByName
			self.latestVolumeCommentText			= item.latestVolumeCommentText
			self.contentData 						= item.contentData
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(VolumeDataParameterKeys.AuthorID)", value: self.authorID)
		result.setParameterValue(key: "\(VolumeDataParameterKeys.Title)", value: self.title)
		result.setParameterValue(key: "\(VolumeDataParameterKeys.DatePublished)", value: self.getStorageDateString(fromDate: self.datePublished))
		result.setParameterValue(key: "\(VolumeDataParameterKeys.CoverThumbnailImageFileName)", value: self.coverThumbnailImageFileName)
		result.setParameterValue(key: "\(VolumeDataParameterKeys.CoverColor)", value: self.coverColor)
		result.setParameterValue(key: "\(VolumeDataParameterKeys.NumberofPages)", value: "\(self.numberofPages)")
		result.setParameterValue(key: "\(VolumeDataParameterKeys.NumberofLikes)", value: "\(self.numberofLikes)")
		result.setParameterValue(key: "\(VolumeDataParameterKeys.NumberofVolumeComments)", value: "\(self.numberofVolumeComments)")
		result.setParameterValue(key: "\(VolumeDataParameterKeys.LatestVolumeCommentDatePosted)", value: self.getStorageDateString(fromDate: self.latestVolumeCommentDatePosted))
		result.setParameterValue(key: "\(VolumeDataParameterKeys.LatestVolumeCommentPostedByName)", value: self.latestVolumeCommentPostedByName)
		result.setParameterValue(key: "\(VolumeDataParameterKeys.LatestVolumeCommentText)", value: self.latestVolumeCommentText)
		result.setParameterValue(key: "\(VolumeDataParameterKeys.ContentData)", value: self.contentData)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 					Bool = self.doValidationsYN
		self.doValidationsYN 					= false
		
		// Copy all properties
		self.id 								= dataWrapper.ID
		self.authorID 							= dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.AuthorID)")!
		self.title 								= dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.Title)")!
		self.datePublished 						= DateHelper.getDate(fromString: dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.DatePublished)")!, fromDateFormatter: self.storageDateFormatter!)
		self.coverThumbnailImageFileName		= dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.CoverThumbnailImageFileName)")!
		self.coverColor							= dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.CoverColor)")!
		self.numberofPages 						= Int(dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.NumberofPages)")!) ?? 0
		self.numberofLikes 						= Int(dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.NumberofLikes)")!) ?? 0
		self.numberofVolumeComments 			= Int(dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.NumberofVolumeComments)")!) ?? 0
		self.latestVolumeCommentDatePosted 		= DateHelper.getDate(fromString: dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.LatestVolumeCommentDatePosted)")!, fromDateFormatter: self.storageDateFormatter!)
		self.latestVolumeCommentPostedByName	= dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.LatestVolumeCommentPostedByName)")!
		self.latestVolumeCommentText 			= dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.LatestVolumeCommentText)")!
		self.contentData 						= dataWrapper.getParameterValue(key: "\(VolumeDataParameterKeys.ContentData)")!
		
		self.doValidationsYN 					= doValidationsYN
	}
	
	public override func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes {
		
		let result: ValidationResultTypes = ValidationResultTypes.passed
		
		// Perform validations for the specified property
		//		switch toProperty(propertyEnum: propertyEnum) {
		//		case .volumComment_postedByName:
		//			result = self.isValidPostedByName(value: value)
		//			break
		//
		//		default:
		//			break
		//		}
		
		return result
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func toProperty(propertyEnum: Int) -> ModelProperties {
		
		return ModelProperties(rawValue: propertyEnum)!
	}
	
	
	// MARK: - Validations
	
}
