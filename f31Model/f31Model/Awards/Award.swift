//
//  Award.swift
//  f31Model
//
//  Created by David on 08/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel
import SFSerialization
import f31Core

public enum AwardDataParameterKeys {
	case ID
	case AuthorID
	case Year
	case Text
	case ImageFileName
	case CompetitionName
	case Quote
	case Url
}

/// Encapsulates a Award model item
public class Award: ModelItemBase {
	
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
	
	let competitionnameKey: String = "CompetitionName"
	
	/// Gets or sets the competitionName
	public var competitionName: String {
		get {
			
			return self.getProperty(key: competitionnameKey)!
		}
		set(value) {
			
			self.setProperty(key: competitionnameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let quoteKey: String = "Quote"
	
	/// Gets or sets the quote
	public var quote: String {
		get {
			
			return self.getProperty(key: quoteKey)!
		}
		set(value) {
			
			self.setProperty(key: quoteKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let urlKey: String = "Url"
	
	/// Gets or sets the url
	public var url: String {
		get {
			
			return self.getProperty(key: urlKey)!
		}
		set(value) {
			
			self.setProperty(key: urlKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> AwardWrapper {
		
		let wrapper = AwardWrapper()
		
		wrapper.id					= Int.init(self.id)!
		
		wrapper.authorID			= Int.init(self.authorID)!
		wrapper.year				= self.year
		wrapper.text				= self.text
		wrapper.imageFileName		= self.imageFileName
		wrapper.competitionName		= self.competitionName
		wrapper.quote				= self.quote
		wrapper.url					= self.url
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: AwardWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 	Bool = self.doValidationsYN
		self.doValidationsYN	= false
		
		// Copy all properties from the wrapper
		self.id					= "\(wrapper.id)"
		self.authorID			= "\(wrapper.authorID)"
		self.year				= wrapper.year
		self.text				= wrapper.text
		self.imageFileName		= wrapper.imageFileName
		self.competitionName	= wrapper.competitionName
		self.quote				= wrapper.quote
		self.url				= wrapper.url
		
		self.doValidationsYN 	= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: authoridKey,		value: "1")
		self.doSetProperty(key: yearKey,			value: "1900")
		self.doSetProperty(key: textKey,			value: "")
		self.doSetProperty(key: imagefilenameKey,	value: "")
		self.doSetProperty(key: competitionnameKey,	value: "")
		self.doSetProperty(key: quoteKey,			value: "")
		self.doSetProperty(key: urlKey,				value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.award_id.rawValue
		endEnumIndex	= ModelProperties.award_url.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]					= ModelProperties.award_id.rawValue
		keys[authoridKey]			= ModelProperties.award_authorID.rawValue
		keys[yearKey]				= ModelProperties.award_year.rawValue
		keys[textKey]				= ModelProperties.award_text.rawValue
		keys[imagefilenameKey]		= ModelProperties.award_imageFileName.rawValue
		keys[competitionnameKey]	= ModelProperties.award_competitionName.rawValue
		keys[quoteKey]				= ModelProperties.award_quote.rawValue
		keys[urlKey]				= ModelProperties.award_url.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "Award"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: Bool = self.doValidationsYN
		self.doValidationsYN = false
		
		// Copy all properties from the specified item
		if let item = item as? Award {
			
			self.id					= item.id
			self.authorID			= item.authorID
			self.year				= item.year
			self.text				= item.text
			self.imageFileName		= item.imageFileName
			self.competitionName	= item.competitionName
			self.quote				= item.quote
			self.url				= item.url
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
	
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()
		
		result.ID 		= self.id
		
		result.setParameterValue(key: "\(AwardDataParameterKeys.AuthorID)", value: self.authorID)
		result.setParameterValue(key: "\(AwardDataParameterKeys.Year)", value: "\(self.year)")
		result.setParameterValue(key: "\(AwardDataParameterKeys.Text)", value: self.text)
		result.setParameterValue(key: "\(AwardDataParameterKeys.ImageFileName)", value: self.imageFileName)
		result.setParameterValue(key: "\(AwardDataParameterKeys.CompetitionName)", value: self.competitionName)
		result.setParameterValue(key: "\(AwardDataParameterKeys.Quote)", value: self.quote)
		result.setParameterValue(key: "\(AwardDataParameterKeys.Url)", value: self.url)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 	Bool = self.doValidationsYN
		self.doValidationsYN 	= false
		
		// Copy all properties
		self.id 				= dataWrapper.ID
		self.authorID 			= dataWrapper.getParameterValue(key: "\(AwardDataParameterKeys.AuthorID)")!
		self.year 				= Int(dataWrapper.getParameterValue(key: "\(AwardDataParameterKeys.Year)")!) ?? 1900
		self.text 				= dataWrapper.getParameterValue(key: "\(AwardDataParameterKeys.Text)")!
		self.imageFileName 		= dataWrapper.getParameterValue(key: "\(AwardDataParameterKeys.ImageFileName)")!
		self.competitionName 	= dataWrapper.getParameterValue(key: "\(AwardDataParameterKeys.CompetitionName)")!
		self.quote 				= dataWrapper.getParameterValue(key: "\(AwardDataParameterKeys.Quote)")!
		self.url 				= dataWrapper.getParameterValue(key: "\(AwardDataParameterKeys.Url)")!
		
		self.doValidationsYN 	= doValidationsYN
	}
	
	public override func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = ValidationResultTypes.passed
		
		// Perform validations for the specified property
		switch toProperty(propertyEnum: propertyEnum) {
		case .award_text:
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


