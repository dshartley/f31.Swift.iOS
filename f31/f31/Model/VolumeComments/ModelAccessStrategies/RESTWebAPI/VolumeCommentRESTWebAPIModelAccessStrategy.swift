//
//  VolumeCommentRESTWebAPIModelAccessStrategy.swift
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

/// A strategy for accessing the VolumeComment model data using a REST Web API
public class VolumeCommentRESTWebAPIModelAccessStrategy: RESTWebAPIModelAccessStrategyBase {

	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(connectionString: String,
						 storageDateFormatter: DateFormatter) {
		super.init(connectionString: connectionString,
				   storageDateFormatter: storageDateFormatter,
				   tableName: "VolumeComments")
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func runQuery(byVolumeID volumeID: Int, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "LoadVolumeCommentsDummyDataYN")) {
				
				self.selectDummy(byVolumeID: volumeID, into: collection, oncomplete: completionHandler)
				
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
		var urlString: 				String = NSLocalizedString("VolumeCommentsSelectByVolumeIDUrl", tableName: "RESTWebAPIConfig", comment: "")
		urlString 					= String(format: urlString, String(volumeID))
		
		// Call the REST Api
		restApiHelper.call(urlString: urlString, httpMethod: .POST, data: dataWrapper)
		
	}

	
	// MARK: - Override Methods
	

	// MARK: - Dummy Data Methods
	
	fileprivate func selectDummy(byVolumeID volumeID: Int, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		let responseString	= NSLocalizedString("byVolumeID", tableName: "VolumeCommentsDummyRESTWebAPIResponse", comment: "")
		
		// Convert the response to JSON dictionary
		let data:			[String:Any]? = JSONHelper.stringToJSON(jsonString: responseString) as? [String:Any]
		
		// Process the data
		let returnData:		[String:Any]? = self.processRESTWebAPIResponse(responseData: data!)
		
		// Call completion handler
		completionHandler(returnData, nil)
		
	}

}

// MARK: - Extension ProtocolVolumeCommentModelAccessStrategy

extension VolumeCommentRESTWebAPIModelAccessStrategy: ProtocolVolumeCommentModelAccessStrategy {
	
	// MARK: - Public Methods
	
	public func select(byVolumeID volumeID: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler: @escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) = self.getRunQueryCompletionHandler(collection: collection, oncomplete: completionHandler)
		
		// Run the query
		self.runQuery(byVolumeID: volumeID, into: collection, oncomplete: runQueryCompletionHandler)
		
	}

}
