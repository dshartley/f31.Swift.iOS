//
//  ModelProperties.swift
//  f31Model
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Specifies model properties
public enum ModelProperties: Int {

	// General
	case id
	
	// volume
	case volume_id
	case volume_authorID
	case volume_title
	case volume_datePublished
	case volume_coverThumbnailImageFileName
	case volume_coverColor
	case volume_numberofPages
	case volume_numberofLikes
	case volume_numberofVolumeComments
	case volume_latestVolumeCommentDatePosted
	case volume_latestVolumeCommentPostedByName
	case volume_latestVolumeCommentText
	case volume_contentData
	
	// volumeComment
	case volumeComment_id
	case volumeComment_volumeID
	case volumeComment_datePosted
	case volumeComment_postedByName
	case volumeComment_text
	
	// award
	case award_id
	case award_authorID
	case award_year
	case award_text
	case award_imageFileName
	case award_competitionName
	case award_quote
	case award_url

	// newsSnippet
	case newsSnippet_id
	case newsSnippet_authorID
	case newsSnippet_year
	case newsSnippet_text
	case newsSnippet_datePosted
	case newsSnippet_imageFileName
	
}
