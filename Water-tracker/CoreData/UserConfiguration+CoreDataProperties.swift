//
//  UserConfiguration+CoreDataProperties.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 19.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//
//

import Foundation
import CoreData


extension UserConfiguration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserConfiguration> {
        return NSFetchRequest<UserConfiguration>(entityName: "UserConfiguration")
    }

    @NSManaged public var calculate: Bool
    @NSManaged public var goal: Int16
    @NSManaged public var sex: Bool
    @NSManaged public var weight: Int16
    @NSManaged public var to: NSDate?
    @NSManaged public var from: NSDate?
    @NSManaged public var frequency: Int16
    @NSManaged public var notifIsOn: Bool
    @NSManaged public var date: NSDate?

}
