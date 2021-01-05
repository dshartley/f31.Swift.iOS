//
//  ModelManager.swift
//  f31Model
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages the model layer and provides access to the model administrators
public class ModelManager: ModelManagerBase {

	// MARK: - Initializers
	
	fileprivate override init() {
		super.init()
	}
	
	public override init(storageDateFormatter: DateFormatter) {
		super.init(storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods
	
	// MARK: - Volume
	
	fileprivate var _volumeModelAdministrator: VolumeModelAdministrator?
	
	public func setupVolumeModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("volume")) { self.modelAdministrators.removeValue(forKey: "volume") }
		
		self._volumeModelAdministrator = VolumeModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["volume"] = self._volumeModelAdministrator
	}
	
	public var getVolumeModelAdministrator: VolumeModelAdministrator? {
		get {
			return self._volumeModelAdministrator
		}
	}
	
	
	// MARK: - VolumeComment
	
	fileprivate var _volumeCommentModelAdministrator: VolumeCommentModelAdministrator?
	
	public func setupVolumeCommentModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("volumeComment")) { self.modelAdministrators.removeValue(forKey: "volumeComment") }
		
		self._volumeCommentModelAdministrator = VolumeCommentModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["volumeComment"] = self._volumeCommentModelAdministrator
	}
	
	public var getVolumeCommentModelAdministrator: VolumeCommentModelAdministrator? {
		get {
			return self._volumeCommentModelAdministrator
		}
	}
	
	
	// MARK: - Award
	
	fileprivate var _awardModelAdministrator: AwardModelAdministrator?
	
	public func setupAwardModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("award")) { self.modelAdministrators.removeValue(forKey: "award") }
		
		self._awardModelAdministrator = AwardModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["award"] = self._awardModelAdministrator
	}
	
	public var getAwardModelAdministrator: AwardModelAdministrator? {
		get {
			return self._awardModelAdministrator
		}
	}
	
	
	// MARK: - NewsSnippet
	
	fileprivate var _newsSnippetModelAdministrator: NewsSnippetModelAdministrator?
	
	public func setupNewsSnippetModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("newsSnippet")) { self.modelAdministrators.removeValue(forKey: "newsSnippet") }
		
		self._newsSnippetModelAdministrator = NewsSnippetModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["newsSnippet"] = self._newsSnippetModelAdministrator
	}
	
	public var getNewsSnippetModelAdministrator: NewsSnippetModelAdministrator? {
		get {
			return self._newsSnippetModelAdministrator
		}
	}
	
}
