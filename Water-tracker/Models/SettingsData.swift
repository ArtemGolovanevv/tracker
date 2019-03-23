//
//  SettingsData.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 18.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import Foundation

struct DataSettings {
    var sex: Bool?
    var weight: Int?
    var goal: Int?
    //var traning: Int?
    var calculate: Bool?

    init( sex: Bool, weight: Int, goal: Int, calculate: Bool) {
        self.sex = sex
        self.weight = weight
        self.goal = goal
        //self.traning = traning
        self.calculate = calculate
    }

    mutating func setForAuto(weight: Int, calculate: Bool, sex: Bool ) -> Int {
        var newGoal = 0
        if calculate == true {
            if sex == true {
                newGoal = 900
                for kg in 30...(weight) {
                    print(kg)
                    if kg % 3 == 0 {
                        newGoal += 50
                        print (newGoal)
                    } else {
                        continue
                    }
                }
            } else {
                newGoal = 1050
                for kg in 30...(weight) {
                    print(kg)
                    if kg % 2 == 0 {
                        newGoal += 50
                        print (newGoal)
                    } else {
                        continue
                    }
                }
            }
            print("\(newGoal) result")
        }
        goal = newGoal

        return goal!
    }
}
