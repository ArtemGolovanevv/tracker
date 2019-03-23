//
//  NotificationTime.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 18.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import Foundation

class NotificationTime {

    var firstTimePoint: Date?
    var secondTimePoint: Date?
    var interval: DateInterval?
    var selectedRange: Int?

    init(firstTimePoint: Date, secondTimePoint: Date, selectedRange: Int) {
        self.firstTimePoint = firstTimePoint
        self.secondTimePoint = secondTimePoint
        self.selectedRange = selectedRange
    }
/*
    func getInterval(firstTimePoint: Date, secondTimePoint: Date) -> DateInterval {

        let first = firstTimePoint
        let second = secondTimePoint
        let interval = DateInterval(start: first, end: second)
        self.interval = interval
        return self.interval!
    }
 */
}
