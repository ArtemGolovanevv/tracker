//
//  Quantity.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 18.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import Foundation

class Quantity {

    let description: String
    let quantity: Int

    init(description: String, quantity: Int) {
        self.description = description
        self.quantity = quantity
    }

}

class Percentage {

    var goal: Int?
    var total: Int?

    init (goal: Int, total: Int) {
        self.goal = goal
        self.total = total
    }

    func setPercentage(goal: Int, total: Int) -> String {
        let percentageGoal: Double = 100
        let convertGoal = Double(goal)
        let convertTotal = Double(total)
        let percentageTotal = (percentageGoal/convertGoal) * convertTotal
        //print(". \(convertGoal)")
        //print(". \(total)")
        //print(". \(convertTotal)")
        let strTotal = "\(Int(percentageTotal))%"
        return strTotal
    }


}
