//
//  RESTWebAPIModelAccessStrategyBase.swift
//  f31
//
//  Created by David on 03/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFNet
import SFSerialization

/// A base class for strategies for accessing model data using a REST Web API
open class RESTWebAPIModelAccessStrategyBase: ModelAccessStrategyBase {
	
	// MARK: - Private Stored Properties
	
	fileprivate let RESTWebAPIConfig: String = "RESTWebAPIConfig"
	
	
	// MARK: - Public Stored Properties
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public override init(connectionString: String,
						 storageDateFormatter: DateFormatter) {
		super.init(connectionString: connectionString,
				   storageDateFormatter: storageDateFormatter)
	}
	
	public override init(connectionString: String,
						 storageDateFormatter: DateFormatter,
						 tableName: String) {
		super.init(connectionString: connectionString,
				   storageDateFormatter: storageDateFormatter,
				   tableName: tableName)
	}
	
	
	// MARK: - Public Methods
	
	
	// MARK: - Open [Overridable] Methods
	
	open func getChildAutoId() -> String {
		
		return UUID().uuidString
		
	}
	
	open func getProcessResponse(oncomplete completionHandler:@escaping ([String:Any]?, URLResponse?, Error?) -> Void) -> ((NSMutableData?, URLResponse?, Error?) -> Void) {
		
		// Create completion handler
		let processResponse: ((NSMutableData?, URLResponse?, Error?) -> Void) =
		{
			[weak self] (mutableData, response, error) -> Void in
			
			guard let strongSelf = self else {
				
				// Call completion handler
				completionHandler(nil, response, error)
				return
				
			}
			
			if (mutableData != nil) {
				
				// Process the data
				let result: [String:Any]? = strongSelf.processRESTWebAPIResponse(responseData: mutableData!)
				
				// Call completion handler
				completionHandler(result, response, error)
				
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
	
	open func processRESTWebAPIResponse(responseData: NSMutableData) -> [String:Any]? {
		
		// Get data as JSON Dictionary
		let data: 			[String:Any]? = JSONHelper.dataToJSON(data: responseData as Data) as? [String:Any]
		
		// Get dataWrapper
		let dataWrapper: 	DataJSONWrapper = JSONHelper.DeserializeDataJSONWrapper(json: data!)!
		
		return self.processRESTWebAPIResponse(dataWrapper: dataWrapper)
		
	}
	
	open func processRESTWebAPIResponse(dataWrapper: DataJSONWrapper) -> [String:Any]? {
		
		var returnData: 			[String:Any] = [String:Any]()
		
		// Set the ID
		if (!dataWrapper.ID.isEmpty) {
			
			returnData["ID"] = dataWrapper.ID
			
		}
		
		// Go through each table
		for tableItem in dataWrapper.Items {
			
			// Create the items array
			var items:				[Any] = [Any]()
			
			// Go through each item
			for item in tableItem.Items {
				
				// Create the dataItem
				var dataItem:		[String: Any] = [String: Any]()
				
				// Get the id
				dataItem["ID"]		= item.ID
				
				// Go through each parameter
				for parameter in item.Params {
					
					// Put the property in the item
					dataItem[parameter.Key] = parameter.Value
					
				}
				
				// Add the item to the array
				items.append(dataItem)
				
			}
			
			// Add the table to the array
			returnData[tableItem.ID] = items
			
		}
		
		// Check Params
		if (dataWrapper.Params.count > 0) {
			
			var params: [Any] = [Any]()
			
			// Go through each parameter
			for parameter in dataWrapper.Params {
				
				// Create parameter item
				var p: [String:Any] = [String:Any]()
				p[parameter.Key] = parameter.Value
				
				// Set in params
				params.append(p)
				
			}
			
			// Add the parameters to the array
			returnData["Params"] = params
			
		}
		
		return returnData
		
	}
	
	open func processRESTWebAPIResponse(responseData: [String:Any]?) -> [String:Any]? {
		
		var returnData: 			[String:Any] = [String:Any]()
		
		// Check responseData not nil
		guard (responseData != nil) else {
			
			return nil
		}
		
		// Check ID
		if let ID = responseData!["ID"] as? String {
			
			returnData["ID"] = ID
			
		}
		
		// Go through each table
		for (_, tableItem) in (responseData!["Items"] as? [Any])!.enumerated() {
			
			let tableItem: 			[String:Any] = tableItem as! [String:Any]
			
			// Get the table name
			let tableName:			String = tableItem["ID"] as! String
			
			// Create the items array
			var items:				[Any] = [Any]()
			
			// Go through each item
			for (_, item) in (tableItem["Items"] as? [Any])!.enumerated() {
				
				let item:			[String:Any] = item as! [String:Any]
				
				// Create the dataItem
				var dataItem:		[String: Any] = [String: Any]()
				
				// Get the id
				let id:				String = item["ID"] as! String
				dataItem["ID"]		= id
				
				// Get the parameters
				let parameters:		[Any]? = item["Params"] as? [Any]
				
				// Go through each parameter
				for (_, parameter) in parameters!.enumerated() {
					
					let parameter:	[String:Any] = parameter as! [String:Any]
					
					// Get key
					let key:		String = parameter["Key"] as! String
					
					// Get value
					let value:		String = parameter["Value"] as! String
					
					// Put the property in the item
					dataItem[key] = value
				}
				
				// Add the item to the array
				items.append(dataItem)
				
			}
			
			// Add the table to the array
			returnData[tableName] = items
			
		}
		
		// Check Params
		if let params = responseData!["Params"] as? [Any] {
			
			if (params.count > 0) {
				
				// Add the parameters to the array
				returnData["Params"] = responseData!["Params"]
				
			}
			
		}
		
		return returnData
	}
	
	open func getProcessResponseCompletionHandler(oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) -> (([String:Any]?, URLResponse?, Error?) -> Void) {
		
		// Create completion handler
		let processResponseCompletionHandler: (([String:Any]?, URLResponse?, Error?) -> Void) =
		{
			[weak self] (data, response, error) -> Void in
			
			guard let strongSelf = self else {
				
				// Call completion handler
				completionHandler(nil, error)
				return
				
			}
			
			var result: [String:Any]? 	= nil
			
			if (data != nil && error == nil) {
				
				result = [strongSelf.rootKey: data!]
			}
			
			// Call completion handler
			completionHandler(result, error)
			
		}
		
		return processResponseCompletionHandler
		
	}
	
	open func getRunQueryCompletionHandler(collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) -> (([String:Any]?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			[weak self] (data, error) -> Void in
			
			guard let strongSelf = self else {
				
				// Call completion handler
				completionHandler(data, collection, error)
				return
				
			}
			
			if (data != nil && error == nil && data![strongSelf.tableName] != nil) {
				
				var collection = collection
				
				// Fill the collection with the loaded data
				collection = strongSelf.fillCollection(collection: collection, data: data![strongSelf.tableName] as! [Any])!
				
			}
			
			// Call completion handler
			completionHandler(data, collection, error)
		}
		
		return runQueryCompletionHandler
	}
	
	
	// MARK: - Override Methods
	
	open override func runQuery(insert attributes: [String : Any], with parameters: inout ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "SaveDummyDataYN")) {
				
				self.insertDummy(insert: attributes, with: &parameters, into: collection, oncomplete: completionHandler)
				
				return
				
			}
			
		#endif
		
		// Create the dataWrapper
		let dataWrapper:			DataJSONWrapper = self.createDataWrapper(with: parameters, collection: collection)
		
		// Make sure the ID is an integer as expected by Web Api
		dataWrapper.ID = "0"
		dataWrapper.deleteParameterValue(key: self.primaryKeyColumnName)
		
		// Create processResponse completion handler
		let processResponseCompletionHandler: (([String:Any]?, URLResponse?, Error?) -> Void) =
			self.getProcessResponseCompletionHandler(oncomplete: completionHandler)
		
		// Create processResponse
		let processResponse: 		((NSMutableData?, URLResponse?, Error?) -> Void) = self.getProcessResponse(oncomplete: processResponseCompletionHandler)
		
		// Create restApiHelper
		let restApiHelper: 			RESTApiHelper = RESTApiHelper(processResponse: processResponse, mode: RESTApiHelperMode.CompletionHandler)
		
		// Get the Url
		let urlString: 				String = NSLocalizedString(self.tableName + "InsertUrl", tableName: self.RESTWebAPIConfig, comment: "")
		
		// Call the REST Api
		restApiHelper.call(urlString: urlString, httpMethod: .POST, data: dataWrapper)
		
	}
	
	open override func runQuery(update attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "SaveDummyDataYN")) {
				
				self.updateDummy(update: attributes, with: parameters, into: collection, oncomplete: completionHandler)
				
				return
				
			}
			
		#endif
		
		// Create the dataWrapper
		let dataWrapper:			DataJSONWrapper = self.createDataWrapper(with: parameters, collection: collection)
		
		// Create processResponse completion handler
		let processResponseCompletionHandler: (([String:Any]?, URLResponse?, Error?) -> Void) =
			self.getProcessResponseCompletionHandler(oncomplete: completionHandler)
		
		// Create processResponse
		let processResponse: 		((NSMutableData?, URLResponse?, Error?) -> Void) = self.getProcessResponse(oncomplete: processResponseCompletionHandler)
		
		// Create restApiHelper
		let restApiHelper: 			RESTApiHelper = RESTApiHelper(processResponse: processResponse, mode: RESTApiHelperMode.CompletionHandler)
		
		// Get the Url
		var urlString: 				String = NSLocalizedString(self.tableName + "UpdateUrl", tableName: self.RESTWebAPIConfig, comment: "")
		urlString 					= String(format: urlString, dataWrapper.ID)
		
		// Call the REST Api
		restApiHelper.call(urlString: urlString, httpMethod: .PUT, data: dataWrapper)
		
	}
	
	open override func runQuery(delete attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		// Get the model item key from the primary key column parameter
		let parameter:			ModelAccessParameter	= parameters!.get(parameterName: self.primaryKeyColumnName) as! ModelAccessParameter
		let modelItemKey:		String					= parameter.value as! String
		
		// Create processResponse completion handler
		let processResponseCompletionHandler: (([String:Any]?, URLResponse?, Error?) -> Void) =
		{
			(data, response, error) -> Void in	// [weak self]
			
			// Call completion handler
			completionHandler(nil, error)
		}
		
		// Create processResponse
		let processResponse: 		((NSMutableData?, URLResponse?, Error?) -> Void) = self.getProcessResponse(oncomplete: processResponseCompletionHandler)
		
		// Create restApiHelper
		let restApiHelper: 			RESTApiHelper = RESTApiHelper(processResponse: processResponse, mode: RESTApiHelperMode.CompletionHandler)
		
		// Get the Url
		var urlString: 				String = NSLocalizedString(self.tableName + "DeleteUrl", tableName: self.RESTWebAPIConfig, comment: "")
		urlString 					= String(format: urlString, modelItemKey)
		
		// Call the REST Api
		restApiHelper.call(urlString: urlString, httpMethod: .DELETE, data: nil)
		
	}
	
	open override func runQuery(select attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
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
		let urlString: 				String = NSLocalizedString("RelativeMembersSelectUrl", tableName: "RESTWebAPIConfig", comment: "")
		
		// Call the REST Api
		restApiHelper.call(urlString: urlString, httpMethod: .GET, data: nil)
		
	}
	
	
	// MARK: - Dummy Data Methods
	
	fileprivate func insertDummy(insert attributes: [String : Any], with parameters: inout ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		let responseString	= NSLocalizedString("insert" + self.tableName, tableName: "InsertDummyRESTWebAPIResponse", comment: "")
		
		// Convert the response to JSON dictionary
		let data:			[String:Any]? = JSONHelper.stringToJSON(jsonString: responseString) as? [String:Any]
		
		// Process the data
		let returnData:		[String:Any]? = self.processRESTWebAPIResponse(responseData: data)
		
		// Create processResponse completion handler
		let processResponseCompletionHandler: (([String:Any]?, URLResponse?, Error?) -> Void) =
			self.getProcessResponseCompletionHandler(oncomplete: completionHandler)
		
		// Call completion handler
		processResponseCompletionHandler(returnData, nil, nil)
		
	}
	
	fileprivate func updateDummy(update attributes: [String : Any], with parameters: ProtocolParametersCollection?, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		let responseString	= NSLocalizedString("update" + self.tableName, tableName: "UpdateDummyRESTWebAPIResponse", comment: "")
		
		// Convert the response to JSON dictionary
		let data:			[String:Any]? = JSONHelper.stringToJSON(jsonString: responseString) as? [String:Any]
		
		// Process the data
		let returnData:		[String:Any]? = self.processRESTWebAPIResponse(responseData: data)
		
		// Create processResponse completion handler
		let processResponseCompletionHandler: (([String:Any]?, URLResponse?, Error?) -> Void) =
			self.getProcessResponseCompletionHandler(oncomplete: completionHandler)
		
		// Call completion handler
		processResponseCompletionHandler(returnData, nil, nil)
		
	}
}

