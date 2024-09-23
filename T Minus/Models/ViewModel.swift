//
//  ViewModel.swift
//  T Minus
//
//  Created by Dylan Hawley on 8/27/24.
//

import Foundation
import SwiftData

/// User interface configuration values.
@Observable
class ViewModel {
    /// The sort direction for launches in the list view.
    var sortOrder: SortOrder = .forward

    /// A location name to use when filtering launches.
    var searchText: String = ""

    /// A date to use when filtering launches.
    ///
    /// Both the list and map views display only the launches that occur between
    /// the start and end of the day in the current time zone that contain
    /// the point in time represented by this date.
    var searchDate: Date = .now

    /// The range of dates that the date picker offers for filtering launches.
    ///
    /// The app recalculates this range when the list of launches changes, like
    /// after loading new launches or deleting existing ones, to
    /// include the full range of dates over all the stored launches.
    var searchDateRange: ClosedRange<Date> = .distantPast ... .distantFuture

    /// The total number of launches in the store.
    var totalLaunches: Int = 0

    /// Updates the search date and search date range based on the current
    /// set of stored launches.
    func update(modelContext: ModelContext) {
//        searchDateRange = Launch.dateRange(modelContext: modelContext)
//        searchDate = min(searchDateRange.upperBound, .now)
//        totalLaunches = Launch.totalLaunches(modelContext: modelContext)
    }
}
