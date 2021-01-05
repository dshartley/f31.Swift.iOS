//
//  NewsSnippet.swift
//  f31Model
//
//  Created by David on 08/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel
import SFCore
import SFSerialization
import f31Core

public enum NewsSnippetDataParameterKeys {
	case ID
	case AuthorID
	case Year
	case Text
	case DatePosted
	case ImageFileName
}

/// Encapsulates a NewsSnippet model item
public class NewsSnippet: ModelItemBase {
	
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
	
	let yearKey: String = "Year"
	
	/// Gets or sets the year
	public var year: Int {
		get {
			
			return Int(self.getProperty(key: yearKey)!)!
		}
		set(value) {
			
			self.setProperty(key: yearKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let textKey: String = "Text"
	
	/// Gets or sets the text
	public var text: String {
		get {
			
			return self.getProperty(key: textKey)!
		}
		set(value) {
			
			self.setProperty(key: textKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let datepostedKey: String = "DatePosted"
	
	/// Gets or sets the datePosted
	public var datePosted: Date {
		get {
			
			let dateString = self.getProperty(key: datepostedKey)!
			
			return DateHelper.getDate(fromString: dateString, fromDateFormatter: self.storageDateFormatter!)
			
		}
		set(value) {
			
			self.setProperty(key: datepostedKey, value: self.getStorageDateString(fromDate: value), setWhenInvalidYN: false)
		}
	}
	
	let imagefilenameKey: String = "ImageFileName"
	
	/// Gets or sets the imageFileName
	public var imageFileName: String {
		get {
			
			return self.getProperty(key: imagefilenameKey)!
		}
		set(value) {
			
			self.setProperty(key: imagefilenameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> NewsSnippetWrapper {
		
		let wrapper = NewsSnippetWrapper()
		
		wrapper.id					= Int.init(self.id)!
		
		wrapper.authorID			= Int.init(self.authorID)!
		wrapper.year				= self.year
		wrapper.text				= self.text
		wrapper.datePosted			= self.datePosted
		wrapper.imageFileName		= self.imageFileName
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: NewsSnippetWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 	Bool = self.doValidationsYN
		self.doValidationsYN	= false
		
		// Copy all properties from the wrapper
		self.id					= "\(wrapper.id)"
		self.authorID			= "\(wrapper.authorID)"
		self.year				= wrapper.year
		self.text				= wrapper.text
		self.datePosted			= wrapper.datePosted
		self.imageFileName		= wrapper.imageFileName
		
		self.doValidationsYN 	= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: authoridKey,		value: "1")
		self.doSetProperty(key: yearKey,			value: "1900")
		self.doSetProperty(key: textKey,			value: "")
		self.doSetProperty(key: datepostedKey,		value: "1/1/1900")
		self.doSetProperty(key: imagefilenameKey,	value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.newsSnippet_id.rawValue
		endEnumIndex	= ModelProperties.newsSnippet_imageFileName.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]					= ModelProperties.newsSnippet_id.rawValue
		keys[authoridKey]			= ModelProperties.newsSnippet_authorID.rawValue
		keys[yearKey]				= ModelProperties.newsSnippet_year.rawValue
		keys[textKey]				= ModelProperties.newsSnippet_text.rawValue
		keys[datepostedKey] 		= ModelProperties.newsSnippet_datePosted.rawValue
		keys[imagefilenameKey]		= ModelProperties.newsSnippet_imageFileName.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "NewsSnippet"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: Bool = self.doValidationsYN
		self.doValidationsYN = false
		
		// Copy all properties from the specified item
		if let item = item as? NewsSnippet {
			
			self.id					= item.id
			self.authorID			= item.authorID
			self.year				= item.year
			self.text				= item.text
			self.datePosted 		= item.datePosted
			self.imageFileName		= item.imageFileName
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
	
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()
		
		result.ID 		= self.id
		
		result.setParameterValue(key: "\(NewsSnippetDataParameterKeys.AuthorID)", value: self.authorID)
		result.setParameterValue(key: "\(NewsSnippetDataParameterKeys.Year)", value: "\(self.year)")
		result.setParameterValue(key: "\(NewsSnippetDataParameterKeys.Text)", value: self.text)
		result.setParameterValue(key: "\(NewsSnippetDataParameterKeys.DatePosted)", value: self.getStorageDateString(fromDate: self.datePosted))
		result.setParameterValue(key: "\(NewsSnippetDataParameterKeys.ImageFileName)", value: self.imageFileName)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 	Bool = self.doValidationsYN
		self.doValidationsYN 	= false
		
		// Copy all properties
		self.id 				= dataWrapper.ID
		self.authorID 			= dataWrapper.getParameterValue(key: "\(NewsSnippetDataParameterKeys.AuthorID)")!
		self.year 				= Int(dataWrapper.getParameterValue(key: "\(NewsSnippetDataParameterKeys.Year)")!) ?? 0
		self.text 				= dataWrapper.getParameterValue(key: "\(NewsSnippetDataParameterKeys.Text)")!
		self.datePosted 		= DateHelper.getDate(fromString: dataWrapper.getParameterValue(key: "\(NewsSnippetDataParameterKeys.DatePosted)")!, fromDateFormatter: self.storageDateFormatter!)
		self.imageFileName 		= dataWrapper.getParameterValue(key: "\(NewsSnippetDataParameterKeys.ImageFileName)")!
		
		self.doValidationsYN 	= doValidationsYN
	}
	
	public override func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = ValidationResultTypes.passed
		
		// Perform validations for the specified property
		switch toProperty(propertyEnum: propertyEnum) {
		case .newsSnippet_text:
			result = self.isValidText(value: value)
			break
			
		default:
			break
		}
		
		return result
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func toProperty(propertyEnum: Int) -> ModelProperties {
		
		return ModelProperties(rawValue: propertyEnum)!
	}
	
	
	// MARK: - Validations
	
	fileprivate func isValidText(value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = .passed
		
		result = self.checkMaxLength(value: value, maxLength: 250, propertyName: "Text")
		
		return result
	}
	
}


