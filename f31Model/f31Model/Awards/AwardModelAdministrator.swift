//
//  AwardModelAdministrator.swift
//  f31Model
//
//  Created by David on 08/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages Award data
public class AwardModelAdministrator: ModelAdministratorBase {
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(modelAccessStrategy:			ProtocolModelAccessStrategy,
						 modelAdministratorProvider:	ProtocolModelAdministratorProvider,
						 storageDateFormatter:			DateFormatter) {
		super.init(modelAccessStrategy: modelAccessStrategy,
				   modelAdministratorProvider: modelAdministratorProvider,
				   storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods
	
	public func select(byAuthorID authorID: Int, year: Int, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			if (error != nil) {
				
				self.doAfterLoad()
				
			}
			
			// Call completion handler
			completionHandler(self.collection!.dataDocument, error)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolAwardModelAccessStrategy).select(byAuthorID: authorID, year: year, collection: self.collection!, oncomplete: selectCompletionHandler)
		
	}
	
	
	// MARK: - Override Methods
	
	public override func newCollection() -> ProtocolModelItemCollection? {
		
		return AwardCollection(modelAdministrator: self,
							   storageDateFormatter: self.storageDateFormatter!)
	}
	
	public override func setupForeignKeys() {
		
		// No foreign keys
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func doLoadDataTables(data: [Any], oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Fill the [ForeignKeyItem] collection
		if (data.count >= 2) {
			//let fkiModelAdministrator: ProtocolModelAdministrator = self.modelAdministratorProvider!.getModelAdministrator(key: "ForeignKeyTable")!
			
			//if (fkiModelAdministrator != nil) {
			//fkiModelAdministrator.load(id: [data[0]], oncomplete: completionHandler)
			//}
		}
	}
	
}

