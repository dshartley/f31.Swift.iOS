//
//  NewsSnippetRESTWebAPIModelAccessStrategy.swift
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

/// A strategy for accessing the NewsSnippet model data using a REST Web API
public class NewsSnippetRESTWebAPIModelAccessStrategy: RESTWebAPIModelAccessStrategyBase {

	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(connectionString: String,
						 storageDateFormatter: DateFormatter) {
		super.init(connectionString: connectionString,
				   storageDateFormatter: storageDateFormatter,
				   tableName: "NewsSnippets")
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func runQuery(byAuthorID authorID: Int, year: Int, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "LoadNewsSnippetsDummyDataYN")) {
				
				self.selectDummy(byAuthorID: authorID, year: year, into: collection, oncomplete: completionHandler)
				
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
		var urlString: 				String = NSLocalizedString("NewsSnippetsSelectByAuthorIDYearUrl", tableName: "RESTWebAPIConfig", comment: "")
		urlString 					= String(format: urlString, String(authorID), String(year))
		
		// Call the REST Api
		restApiHelper.call(urlString: urlString, httpMethod: .POST, data: dataWrapper)
		
	}

	
	// MARK: - Override Methods
	

	// MARK: - Dummy Data Methods
	
	fileprivate func selectDummy(byAuthorID authorID: Int, year: Int, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		let responseString	= NSLocalizedString("byAuthorIDYear", tableName: "NewsSnippetsDummyRESTWebAPIResponse", comment: "")
		
		// Convert the response to JSON dictionary
		let data:			[String:Any]? = JSONHelper.stringToJSON(jsonString: responseString) as? [String:Any]
		
		// Process the data
		let returnData:		[String:Any]? = self.processRESTWebAPIResponse(responseData: data!)
		
		// Call completion handler
		completionHandler(returnData, nil)
		
	}

}

// MARK: - Extension ProtocolNewsSnippetModelAccessStrategy

extension NewsSnippetRESTWebAPIModelAccessStrategy: ProtocolNewsSnippetModelAccessStrategy {

	// MARK: - Public Methods
	
	public func select(byAuthorID authorID: Int, year: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler: @escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) = self.getRunQueryCompletionHandler(collection: collection, oncomplete: completionHandler)
		
		// Run the query
		self.runQuery(byAuthorID: authorID, year: year, into: collection, oncomplete: runQueryCompletionHandler)
		
	}

}
