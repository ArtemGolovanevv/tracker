//
//  UserConfiguration+CoreDataClass.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 19.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//
//

import Foundation
import CoreData


public class UserConfiguration: NSManagedObject {

    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "UserConfiguration"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
