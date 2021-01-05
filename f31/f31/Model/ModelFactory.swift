//
//  ModelFactory.swift
//  f31
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel
import f31Model

/// Creates model administrators
public class ModelFactory {

	// MARK: - Initializers
	
	private init() {
		
	}
	
	
	// MARK: - Public Class Methods
	
	fileprivate static var _modelManager: ModelManager?
	
	public class var modelManager: ModelManager {
		get {
			if (_modelManager == nil) {
				_modelManager = ModelManager(storageDateFormatter: ModelFactory.storageDateFormatter)
			}
			
			return _modelManager!
		}
	}
	
	fileprivate static var _storageDateFormatter: DateFormatter?
	
	public class var storageDateFormatter: DateFormatter {
		get {
			if (_storageDateFormatter == nil) {
				
				// Get dateFormatter
				_storageDateFormatter 				= DateFormatter()
				_storageDateFormatter!.timeZone 	= TimeZone(secondsFromGMT: 0)
				
				// "dd-MM-yyyy HH:mm:ss a"
				_storageDateFormatter!.dateFormat	= "dd-MM-yyyy HH:mm:ss a"
				
			}
			
			return _storageDateFormatter!
		}
	}
	
	
	// MARK: - Volume
	
	public class var getVolumeModelAdministrator: VolumeModelAdministrator {
		get {
			if (self.modelManager.getVolumeModelAdministrator == nil) {
				self.setupVolumeModelAdministrator(modelManager: self.modelManager)
			}
			
			return self.modelManager.getVolumeModelAdministrator!
		}
	}
	
	public class func setupVolumeModelAdministrator(modelManager: ModelManager) {
		
		// Connection string
		let connectionString: String = ""
		
		let modelAccessStrategy: ProtocolModelAccessStrategy = VolumeRESTWebAPIModelAccessStrategy(connectionString: connectionString, storageDateFormatter: ModelFactory.storageDateFormatter)
		
		modelManager.setupVolumeModelAdministrator(modelAccessStrategy: modelAccessStrategy)
	}
	
	
	// MARK: - VolumeComment
	
	public class var getVolumeCommentModelAdministrator: VolumeCommentModelAdministrator {
		get {
			if (self.modelManager.getVolumeCommentModelAdministrator == nil) {
				self.setupVolumeCommentModelAdministrator(modelManager: self.modelManager)
			}
			
			return self.modelManager.getVolumeCommentModelAdministrator!
		}
	}
	
	public class func setupVolumeCommentModelAdministrator(modelManager: ModelManager) {
		
		// Connection string
		let connectionString: String = ""
		
		let modelAccessStrategy: ProtocolModelAccessStrategy = VolumeCommentRESTWebAPIModelAccessStrategy(connectionString: connectionString, storageDateFormatter: ModelFactory.storageDateFormatter)
		
		modelManager.setupVolumeCommentModelAdministrator(modelAccessStrategy: modelAccessStrategy)
	}
	
	
	// MARK: - Award
	
	public class var getAwardModelAdministrator: AwardModelAdministrator {
		get {
			if (self.modelManager.getAwardModelAdministrator == nil) {
				self.setupAwardModelAdministrator(modelManager: self.modelManager)
			}
			
			return self.modelManager.getAwardModelAdministrator!
		}
	}
	
	public class func setupAwardModelAdministrator(modelManager: ModelManager) {
		
		// Connection string
		let connectionString: String = ""
		
		let modelAccessStrategy: ProtocolModelAccessStrategy = AwardRESTWebAPIModelAccessStrategy(connectionString: connectionString, storageDateFormatter: ModelFactory.storageDateFormatter)
		
		modelManager.setupAwardModelAdministrator(modelAccessStrategy: modelAccessStrategy)
	}

	
	// MARK: - NewsSnippet
	
	public class var getNewsSnippetModelAdministrator: NewsSnippetModelAdministrator {
		get {
			if (self.modelManager.getNewsSnippetModelAdministrator == nil) {
				self.setupNewsSnippetModelAdministrator(modelManager: self.modelManager)
			}
			
			return self.modelManager.getNewsSnippetModelAdministrator!
		}
	}
	
	public class func setupNewsSnippetModelAdministrator(modelManager: ModelManager) {
		
		// Connection string
		let connectionString: String = ""
		
		let modelAccessStrategy: ProtocolModelAccessStrategy = NewsSnippetRESTWebAPIModelAccessStrategy(connectionString: connectionString, storageDateFormatter: ModelFactory.storageDateFormatter)
		
		modelManager.setupNewsSnippetModelAdministrator(modelAccessStrategy: modelAccessStrategy)
	}
	
}
