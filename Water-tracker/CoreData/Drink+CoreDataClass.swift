//
//  Drink+CoreDataClass.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 19.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//
//

import Foundation
import CoreData


public class Drink: NSManagedObject {

    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Drink"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
