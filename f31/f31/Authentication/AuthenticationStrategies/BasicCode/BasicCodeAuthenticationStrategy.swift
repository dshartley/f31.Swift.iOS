//
//  BasicCodeAuthenticationStrategy.swift
//  Smart.Foundation
//
//  Created by David on 07/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFCore
import SFSecurity
import f31Core

/// A strategy for managing user authentication using a basic code
public class BasicCodeAuthenticationStrategy: AuthenticationStrategyBase {
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	
	// MARK: - Override Methods
	
	public override func getCurrentUserProperties() -> UserProperties? {
		
		return UserProperties()
		
	}
	
	public override func isSignedInYN() -> Bool {
		
		var result: Bool = false
		
		// Check app setting
		result = SettingsManager.get(boolForKey: "\(SettingsKeys.isSignedInYN)") ?? false
		
		return result
	}
	
	public override func signIn(withEmail email: String, password: String, oncomplete completionHandler:@escaping (UserProperties?, Error?, AuthenticationErrorCodes?) -> Void) {
		
		// Create authentication error code
		var errorCode: 		AuthenticationErrorCodes? = nil

		var userProperties:	UserProperties? = UserProperties()
		var error: 			Error? = nil
		
		// Get the basicCode
		let basicCode: 		String = self.getBasicCode()
		
		var isCorrectYN:	Bool = false
		
		// Check the password
		if (password == basicCode) {
			
			isCorrectYN 	= true
			
		} else {
			
			error 			= NSError()
			userProperties 	= nil
			errorCode 		= AuthenticationErrorCodes.wrongPassword
			
		}

		// Save isSignedInYN app setting
		SettingsManager.set(bool: isCorrectYN, forKey: "\(SettingsKeys.isSignedInYN)")
		
		// Call completion handler
		completionHandler(userProperties, error, errorCode)
		
	}
	
	public override func signOut(oncomplete completionHandler:@escaping (Error?, AuthenticationErrorCodes?) -> Void) {
		
		// Not implemented
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func getBasicCode() -> String {
		
		let path: String? 		= Bundle.main.path(forResource: "AppSettings", ofType: "plist")
		let dict: NSDictionary 	= NSDictionary(contentsOfFile: path!)!
		
		let code: String = dict.object(forKey: "BasicCode") as! String
		
		return code
		
	}
	
}


