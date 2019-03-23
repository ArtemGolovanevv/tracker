//
//  Drink+CoreDataProperties.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 20.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//
//

import Foundation
import CoreData


extension Drink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var balance: Int16

}
