//
//  AwardSOAPWebServiceModelAccessStrategy.swift
//  f31
//
//  Created by David on 08/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFSerialization
import SFNet
import f31Model

/// A strategy for accessing the Award model data using SOAP Web Services
public class AwardSOAPWebServiceModelAccessStrategy: ModelAccessStrategyBase {
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public override init(connectionString: String,
						 storageDateFormatter: DateFormatter) {
		super.init(connectionString: connectionString,
				   storageDateFormatter: storageDateFormatter,
				   tableName: "Awards")
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func getProcessResponse(oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) -> ((NSMutableData?, Error?) -> Void) {
		
		// Create completion handler
		let processResponse: ((NSMutableData?, Error?) -> Void) =
		{
			(mutableData, error) -> Void in
			
			if (mutableData != nil) {
				
				// Get XML String
				let s:		NSString?		= NSString(data: mutableData! as Data, encoding: String.Encoding.utf8.rawValue)
				
				// Get data as JSON Dictionary
				let data:	[String:Any]?	= JSONHelper.xmlToJSON(xmlString: s! as String)
				
				// Call completion handler
				completionHandler(data, nil)
				
			} else if error != nil {
				
				// Call completion handler
				completionHandler(nil, error)
			}
		}
		
		return processResponse
	}
	
	fileprivate func processWebServiceResponse(soapResponse: [String:Any]) -> [Any]? {
		
		var returnData: [Any] = [Any]()
		
		// Get the data string
		let envelope:	[String:Any]?	= soapResponse["soap:Envelope"] as? [String:Any]
		let body:		[String:Any]?	= envelope?["soap:Body"] as? [String:Any]
		let response:	[String:Any]?	= body?["LoadAwardsByCategoryYearResponse"] as? [String:Any]
		let result:		[String:Any]?	= response?["LoadAwardsByCategoryYearResult"] as? [String:Any]
		let dataString:	String?			= result?["text"] as? String
		
		// Check dataString not nil
		guard (dataString != nil) else {
			
			return nil
		}
		
		// Convert the data string to JSON dictionary
		let dataJSON:	[String:Any]?	= JSONHelper.stringToJSON(jsonString: dataString!) as? [String:Any]
		
		// Create model items
		let items:		[Any]?			= dataJSON!["Items"] as? [Any]
		
		// Go through each item
		for (_, item) in items!.enumerated() {
			
			let item = item as! [String:Any]
			
			// Create the data item
			var dataItem				= [String: Any]()
			
			// Get the id
			let id:				Int		= item["ID"] as! Int
			dataItem["ID"] = String(id)
			
			
			// Get the parameters
			let parameters:		[Any]?	= item["Params"] as? [Any]
			
			// Go through each parameter
			for (_, parameter) in parameters!.enumerated() {
				
				let parameter = parameter as! [String:Any]
				
				// Get key
				let key:		String	= parameter["Key"] as! String
				
				// Get value
				let value:		String	= parameter["Value"] as! String
				
				
				// Put the property in the item
				dataItem[key.lowercased()] = value
			}
			
			// Add the item to the array
			returnData.append(dataItem)
			
		}
		
		return returnData
	}
	
	
	// MARK: - Dummy Data Methods
	
	public func selectDummy(byAuthorID authorID: Int, year: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		var returnData		= [Any]()
		
		let soapResponse	= NSLocalizedString("text", tableName: "AwardsDummySOAPResponse", comment: "")
		
		// Convert the response to JSON dictionary
		let data:			[String:Any]?	= JSONHelper.stringToJSON(jsonString: soapResponse) as? [String:Any]
		
		returnData			= self.processWebServiceResponse(soapResponse: data!)!
		
		var collection		= collection
		
		// Fill the collection with the loaded data
		collection = self.fillCollection(collection: collection, data: returnData)!
		
		// Call the completion handler
		completionHandler(returnData, collection, nil)
		
	}
	
}

// MARK: - Extension ProtocolAwardModelAccessStrategy

extension AwardSOAPWebServiceModelAccessStrategy: ProtocolAwardModelAccessStrategy {
	
	// MARK: - Public Methods
	
	public func select(byAuthorID authorID: Int, year: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// DEBUG:
		//self.selectDummy(byCategory: category, year: year, collection: collection, oncomplete: completionHandler)
		
		//return
		
		//////////
		
		
		// Create processResponse completion handler
		let processResponseCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(response, error) -> Void in
			
			var data: [Any]? 	= nil
			var collection 		= collection
			
			// Check response not nil
			if (response != nil) {
				
				// Process the response data
				data = self.processWebServiceResponse(soapResponse: response!)
				
				if (data != nil) {
					
					// Fill the collection with the loaded data
					collection = self.fillCollection(collection: collection, data: data!)!
				}
			}
			
			// Call the completion handler
			completionHandler(data, collection, error)
		}
		
		// Create processResponse
		let processResponse: 		((NSMutableData?, Error?) -> Void) = getProcessResponse(oncomplete: processResponseCompletionHandler)
		
		// Create webServiceHelper
		let webServiceHelper:		WebServiceHelper = WebServiceHelper(processResponse: processResponse, mode: WebServiceHelperMode.CompletionHandler)
		
		// Get the Url
		let urlString: 				String = NSLocalizedString("loadAwardsSOAPUrl", tableName: "SOAPRequestConfig", comment: "")
		
		// Setup the SOAP message
		let soapMessageTemplate: 	String = NSLocalizedString("loadAwardsSOAPRequest", tableName: "SOAPRequestConfig", comment: "")
		let soapMessage: 			String = String(format: soapMessageTemplate, String(authorID), String(year))
		
		// Call web service
		webServiceHelper.call(urlString: urlString, soapMessage: soapMessage)
		
	}
	
}

