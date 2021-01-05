//
//  Enums.swift
//  f31Core
//
//  Created by David on 11/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Specifies daughters
public enum Daughters: Int {
	case elena			= 1
	case sofia			= 2
}

/// Specifies volume content keys
public enum VolumeContentKeys {
	case Pages
	case Assets
}

/// Specifies volume asset attributes
public enum VolumeAssetAttributes {
	case ImageFileName
	case ImageData
}

/// Specifies volume asset types
public enum VolumeAssetTypes: Int {
	case Image			= 1
}

/// Specifies volume group key prefixes
public enum VolumeGroupKeyPrefixes {
	case page
}
