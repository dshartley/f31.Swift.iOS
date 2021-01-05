//
//  VolumesListDisplayControlManager.swift
//  f31Controller
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFController
import f31Core
import f31Model
import f31View

/// Manages the VolumesListDisplay control layer
public class VolumesListDisplayControlManager: VolumesControlManagerBase {

	// MARK: - Private Stored Properties
	
	// MARK: - Public Stored Properties
	
	public var viewManager:	VolumesListDisplayViewManager?

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager,
				viewManager: VolumesListDisplayViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager	= viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func clearData() {
	
		self.clearVolumesData()
		self.clearAwardsData()
		self.clearNewsSnippetsData()
		
	}
	
	public func clearVolumesData() {
		
		// Clear the cache
		VolumesCacheManager.shared.clear()
		
		// Clear the wrappers array
		VolumeWrappers.items							= [VolumeWrapper]()
		
		VolumeWrappers.hasLoadedAllPreviousItemsYN		= false
		VolumeWrappers.hasLoadedAllNextItemsYN			= false
		
		self.getVolumeModelAdministrator().initialise()
		
	}
	
	public func clearAwardsData() {
		
		// Clear the cache
		AwardsCacheManager.shared.clear()
		
		// Clear the wrappers array
		AwardWrappers.items 							= [AwardWrapper]()
		
		self.getAwardModelAdministrator().initialise()
		
	}

	public func clearNewsSnippetsData() {
		
		// Clear the cache
		NewsSnippetsCacheManager.shared.clear()
		
		// Clear the wrappers array
		NewsSnippetWrappers.items 						= [NewsSnippetWrapper]()
		
		self.getNewsSnippetModelAdministrator().initialise()
		
	}
	
	public func deleteLastItem() {
		
		let aw: Volume = self.getVolumeModelAdministrator().collection?.items?.last as! Volume
		
		self.getVolumeModelAdministrator().collection?.removeItem(item: aw)
		
		VolumeWrappers.items.removeLast()

	}

	public func getYears() -> [Int] {
	
		// Get current year
		let date		= Date()
		let calendar	= Calendar.current
		let year:		Int = calendar.component(.year, from: date)
		
		var result		= [Int]()
		
		for i in stride(from: year, through: 2013, by: -1) {
			
			result.append(i)
		}

		// Set selected year
		self.selectedYear = year
		
		return result
	}
	
	public func set(selectedDaughter daughter: Daughters) {
		
		// If changed then clear data
		if (daughter != self.selectedDaughter) { self.clearData() }
			
		self.selectedDaughter = daughter
		
	}
	
	public func set(selectedYear year: Int) {
		
		// If changed then clear data
		if (year != self.selectedYear) { self.clearData() }
		
		self.selectedYear = year
		
	}
	
	public func clearAwardsView() {
		
		self.viewManager!.clearAwards()
		
	}
	
	public func displayAwards() {
		
		self.viewManager!.displayAwards(items: AwardWrappers.items)

	}

	
	// MARK: - Private Methods

}
