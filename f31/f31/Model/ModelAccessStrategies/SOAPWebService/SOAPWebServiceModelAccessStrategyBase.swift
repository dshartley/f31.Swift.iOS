//
//  SOAPWebServiceModelAccessStrategyBase.swift
//  f31
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// A base class for strategies for accessing model data using SOAP Web Services
public class SOAPWebServiceModelAccessStrategyBase: ModelAccessStrategyBase {

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
	
}
