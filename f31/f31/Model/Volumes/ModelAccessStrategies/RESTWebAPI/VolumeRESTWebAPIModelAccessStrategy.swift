//
//  VolumeRESTWebAPIModelAccessStrategy.swift
//  f31
//
//  Created by David on 03/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFSocial
import SFSerialization
import SFNet
import f31Core
import f31Model

/// A strategy for accessing the Volume model data using a REST Web API
public class VolumeRESTWebAPIModelAccessStrategy: RESTWebAPIModelAccessStrategyBase {

	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(connectionString: String,
						 storageDateFormatter: DateFormatter) {
		super.init(connectionString: connectionString,
				   storageDateFormatter: storageDateFormatter,
				   tableName: "Volumes")
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func runQuery(byPreviousVolumeID id: Int, authorID: Int, year: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "LoadVolumesDummyDataYN")) {
				
				self.selectDummy(byPreviousVolumeID: id, authorID: authorID, year: year, numberofItemsToLoad: numberofItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, into: collection, oncomplete: completionHandler)
				
				return
				
			}
			
		#endif
		
		// Create the dataWrapper
		let dataWrapper:			DataJSONWrapper = DataJSONWrapper()
		dataWrapper.setParameterValue(key: "\(VolumeDataParameterKeys.NumberofItemsToLoad)", value: "\(numberofItemsToLoad)")
		dataWrapper.setParameterValue(key: "\(VolumeDataParameterKeys.SelectItemsAfterPreviousYN)", value: "\(selectItemsAfterPreviousYN)")
		
		// Create processResponse completion handler
		let processResponseCompletionHandler: (([String:Any]?, URLResponse?, Error?) -> Void) =
		{
			(data, response, error) -> Void in	// [weak self]
			
			// Call completion handler
			completionHandler(data, error)
		}
		
		// Create processResponse
		let processResponse: 		((NSMutableData?, URLResponse?, Error?) -> Void) = self.getProcessResponse(oncomplete: processResponseCompletionHandler)
		
		// Create restApiHelper
		let restApiHelper: 			RESTApiHelper = RESTApiHelper(processResponse: processResponse, mode: RESTApiHelperMode.CompletionHandler)
		
		// Get the Url
		var urlString: 				String = NSLocalizedString("VolumesSelectByPreviousVolumeIDAuthorIDYearUrl", tableName: "RESTWebAPIConfig", comment: "")
		urlString 					= String(format: urlString,
											   String(id),
											   String(authorID),
											   String(year))
		
		// Call the REST Api
		restApiHelper.call(urlString: urlString, httpMethod: .POST, data: dataWrapper)
		
	}

	fileprivate func runQueryGetContentData(forVolume volumeID: String, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "GetVolumeContentDataDummyDataYN")) {
				
				self.getContentDataDummy(forVolume: volumeID, oncomplete: completionHandler)
				
				return
				
			}
			
		#endif
		
		// Create the dataWrapper
		let dataWrapper:			DataJSONWrapper = DataJSONWrapper()
		
		// Create processResponse completion handler
		let processResponseCompletionHandler: (([String:Any]?, URLResponse?, Error?) -> Void) =
		{
			(data, response, error) -> Void in	// [weak self]
			
			// Call completion handler
			completionHandler(data, error)
		}
		
		// Create processResponse
		let processResponse: 		((NSMutableData?, URLResponse?, Error?) -> Void) = self.getProcessResponseGetContentData(oncomplete: processResponseCompletionHandler)
		
		// Create restApiHelper
		let restApiHelper: 			RESTApiHelper = RESTApiHelper(processResponse: processResponse, mode: RESTApiHelperMode.CompletionHandler)
		
		// Get the Url
		var urlString: 				String = NSLocalizedString("VolumesGetContentDataForVolumeUrl", tableName: "RESTWebAPIConfig", comment: "")
		urlString 					= String(format: urlString,
											   volumeID)
		
		// Call the REST Api
		restApiHelper.call(urlString: urlString, httpMethod: .POST, data: dataWrapper)
		
	}
		
	fileprivate func runQueryAddLike(volumeID: Int, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "AddLikeDummyDataYN")) {
				
				return
				
			}
			
		#endif
		
		// Create the dataWrapper
		let dataWrapper:			DataJSONWrapper = DataJSONWrapper()
		
		// Create processResponse completion handler
		let processResponseCompletionHandler: (([String:Any]?, URLResponse?, Error?) -> Void) =
		{
			(data, response, error) -> Void in	// [weak self]
			
			// Call completion handler
			completionHandler(data, error)
		}

		// Create processResponse
		let processResponse: 		((NSMutableData?, URLResponse?, Error?) -> Void) = self.getProcessResponse(oncomplete: processResponseCompletionHandler)
		
		// Create restApiHelper
		let restApiHelper: 			RESTApiHelper = RESTApiHelper(processResponse: processResponse, mode: RESTApiHelperMode.CompletionHandler)
		
		// Get the Url
		var urlString: 				String = NSLocalizedString("VolumesAddLikeUrl", tableName: "RESTWebAPIConfig", comment: "")
		urlString 					= String(format: urlString,
											   String(volumeID))
		
		// Call the REST Api
		restApiHelper.call(urlString: urlString, httpMethod: .POST, data: dataWrapper)
		
	}
	
	fileprivate func getProcessResponseGetContentData(oncomplete completionHandler:@escaping ([String:Any]?, URLResponse?, Error?) -> Void) -> ((NSMutableData?, URLResponse?, Error?) -> Void) {
		
		// Create completion handler
		let processResponse: ((NSMutableData?, URLResponse?, Error?) -> Void) =
		{
			(mutableData, response, error) -> Void in		// [weak self]
			
			if (mutableData != nil) {
				
				// Get data as JSON Dictionary
				let returnData: [String:Any]? = JSONHelper.dataToJSON(data: mutableData! as Data) as? [String:Any]
				
				// Call completion handler
				completionHandler(returnData, response, error)
				
			} else if error != nil {
				
				// Call completion handler
				completionHandler(nil, response, error)
				
			} else {
				
				// Call completion handler
				completionHandler(nil, response, error)
				
			}
		}
		
		return processResponse
	}
	
	// MARK: - Override Methods
	
	
	// MARK: - Dummy Data Methods
	
	fileprivate func selectDummy(byPreviousVolumeID id: Int, authorID: Int, year: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		let responseString	= NSLocalizedString("byPreviousVolumeID_AuthorID_Year", tableName: "VolumesDummyRESTWebAPIResponse", comment: "")
		
		// Convert the response to JSON dictionary
		let data:			[String:Any]? = JSONHelper.stringToJSON(jsonString: responseString) as? [String:Any]
		
		// Process the data
		let returnData:		[String:Any]? = self.processRESTWebAPIResponse(responseData: data!)
		
		// Call completion handler
		completionHandler(returnData, nil)
		
	}

	fileprivate func getContentDataDummy(forVolume volumeID: String, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		let responseString	= NSLocalizedString("getContentDataForVolume", tableName: "VolumesDummyRESTWebAPIResponse", comment: "")
		
		// Convert the response to JSON dictionary
		let data:			[String:Any]? = JSONHelper.stringToJSON(jsonString: responseString) as? [String:Any]
		
		// Process the data
		let returnData: 	[String:Any]? = data
		
		// Call completion handler
		completionHandler(returnData, nil)
		
	}
	
}

// MARK: - Extension ProtocolVolumeModelAccessStrategy

extension VolumeRESTWebAPIModelAccessStrategy: ProtocolVolumeModelAccessStrategy {
	
	// MARK: - Public Methods
	
	public func select(byPreviousVolumeID id: Int, authorID: Int, year: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, collection: ProtocolModelItemCollection, oncomplete completionHandler: @escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) = self.getRunQueryCompletionHandler(collection: collection, oncomplete: completionHandler)
		
		// Run the query
		self.runQuery(byPreviousVolumeID: id, authorID: authorID, year: year, numberofItemsToLoad: numberofItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, into: collection, oncomplete: runQueryCompletionHandler)
		
	}
	
	public func getContentData(forVolume volumeID: String, oncomplete completionHandler:@escaping (String?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in	// [weak self]
			
			var result: String? = nil
			
			if (data != nil && error == nil) {
				
				// Get wrapper
				let wrapper: DataJSONWrapper? = JSONHelper.DeserializeDataJSONWrapper(json: data!)
				
				if (wrapper != nil) {
				
					// Get ContentData
					result = wrapper!.getParameterValue(key: "\(VolumeDataParameterKeys.ContentData)")
					
				}
				
			}
			
			// Call completion handler
			completionHandler(result, error)
			
		}
		
		// Run the query
		self.runQueryGetContentData(forVolume: volumeID, oncomplete: runQueryCompletionHandler)
		
	}

	public func addLike(id: Int) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in	// [weak self]
			
		}
		
		// Run the query
		self.runQueryAddLike(volumeID: id, oncomplete: runQueryCompletionHandler)
		
	}

}
