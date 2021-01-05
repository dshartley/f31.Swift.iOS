//
//  VolumeComment.swift
//  f31Model
//
//  Created by David on 01/01/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFSerialization
import f31Core

public enum VolumeCommentDataParameterKeys {
	case ID
	case VolumeID
	case DatePosted
	case PostedByName
	case Text
}

/// Encapsulates a VolumeComment model item
public class VolumeComment: ModelItemBase {
	
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
	
	
	let volumeidKey: String = "VolumeID"
	
	/// Gets or sets the volumeID
	public var volumeID: Int {
		get {
			
			return Int(self.getProperty(key: volumeidKey)!)!
		}
		set(value) {
			
			self.setProperty(key: volumeidKey, value: String(value), setWhenInvalidYN: false)
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
	
	let postedbynameKey: String = "PostedByName"
	
	/// Gets or sets the postedByName
	public var postedByName: String {
		get {
			
			return self.getProperty(key: postedbynameKey)!
		}
		set(value) {
			
			self.setProperty(key: postedbynameKey, value: value, setWhenInvalidYN: false)
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
	
	public func toWrapper() -> VolumeCommentWrapper {
		
		let wrapper = VolumeCommentWrapper()
		
		wrapper.id				= self.id

		wrapper.volumeID		= self.volumeID
		wrapper.datePosted		= self.datePosted
		wrapper.postedByName	= self.postedByName
		wrapper.text			= self.text
		
		return wrapper
	}
	
	public func clone(fromWrapper wrapper: VolumeCommentWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 	Bool = self.doValidationsYN
		self.doValidationsYN	= false
		
		// Copy all properties from the wrapper
		self.id					= wrapper.id
		self.volumeID			= wrapper.volumeID
		self.datePosted			= wrapper.datePosted
		self.postedByName		= wrapper.postedByName
		self.text				= wrapper.text
		
		self.doValidationsYN 	= doValidationsYN
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		super.initialiseDataNode()
		
		// Setup the node data
		
		self.doSetProperty(key: volumeidKey, 		value: "")
		self.doSetProperty(key: datepostedKey,		value: "")
		self.doSetProperty(key: postedbynameKey,	value: "")
		self.doSetProperty(key: textKey,	    	value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.volumeComment_id.rawValue
		endEnumIndex	= ModelProperties.volumeComment_text.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]				= ModelProperties.volumeComment_id.rawValue
		keys[volumeidKey]		= ModelProperties.volumeComment_volumeID.rawValue
		keys[datepostedKey]		= ModelProperties.volumeComment_datePosted.rawValue
		keys[postedbynameKey]	= ModelProperties.volumeComment_postedByName.rawValue
		keys[textKey]			= ModelProperties.volumeComment_text.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "VolumeComment"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: 		Bool = self.doValidationsYN
		self.doValidationsYN 		= false
		
		// Copy all properties from the specified item
		if let item = item as? VolumeComment {
			
			self.id					= item.id
			self.volumeID			= item.volumeID
			self.datePosted			= item.datePosted
			self.postedByName		= item.postedByName
			self.text				= item.text
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
		
	public override func copyToWrapper() -> DataJSONWrapper {
		
		let result: 	DataJSONWrapper = DataJSONWrapper()

		result.ID 		= self.id

		result.setParameterValue(key: "\(VolumeCommentDataParameterKeys.VolumeID)", value: "\(self.volumeID)")
		result.setParameterValue(key: "\(VolumeCommentDataParameterKeys.DatePosted)", value: self.getStorageDateString(fromDate: self.datePosted))
		result.setParameterValue(key: "\(VolumeCommentDataParameterKeys.PostedByName)", value: self.postedByName)
		result.setParameterValue(key: "\(VolumeCommentDataParameterKeys.Text)", value: self.text)
		
		return result
	}
	
	public override func copyFromWrapper(dataWrapper: DataJSONWrapper, fromDateFormatter: DateFormatter) {
		
		// Validations should not be performed when copying the item
		let doValidationsYN: 	Bool = self.doValidationsYN
		self.doValidationsYN 	= false
		
		// Copy all properties
		self.id 				= dataWrapper.ID
		self.volumeID 			= Int(dataWrapper.getParameterValue(key: "\(VolumeCommentDataParameterKeys.VolumeID)")!) ?? 0
		self.datePosted 		= DateHelper.getDate(fromString: dataWrapper.getParameterValue(key: "\(VolumeCommentDataParameterKeys.DatePosted)")!, fromDateFormatter: self.storageDateFormatter!)
		self.postedByName 		= dataWrapper.getParameterValue(key: "\(VolumeCommentDataParameterKeys.PostedByName)")!
		self.text 				= dataWrapper.getParameterValue(key: "\(VolumeCommentDataParameterKeys.Text)")!
		
		self.doValidationsYN 	= doValidationsYN
	}
	
	public override func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes {
		
		let result: ValidationResultTypes = ValidationResultTypes.passed
		
		// Perform validations for the specified property
		//		switch toProperty(propertyEnum: propertyEnum) {
		//		case .volumeComment_postedByName:
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
