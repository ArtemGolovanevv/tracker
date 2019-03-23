//
//  Drinks.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 18.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import Foundation

class Drinks {

    let name: String?
    let coefficient: String?

    init (name: String, coefficient: String ) {
        self.name = name
        self.coefficient = coefficient
    }
}

class ReciveImagesToDrinks: Drinks {

    var image: String?

    init(image: String, name: String, coefficient: String ) {
        super.init(name: name, coefficient: coefficient)
        self.image = image
    }
}

class SelectDrink: Drinks {

    let value: Int16?
    let date: Date?

    init(value: Int16, date: Date, name: String, coefficient: String ) {
        self.value = value
        self.date = date
        super.init(name: name, coefficient: coefficient)
    }

    func getFinalValue (name: String, coefficient: String, value: Int) -> Double {
        let converterForValue = Double(value)
        print("converterForValue \(converterForValue)")
        let converterForCoefficient = Double(coefficient)
        print("converterForCoefficient \(String(describing: converterForCoefficient))")
        let final = converterForValue * converterForCoefficient!
        print("u drink \(name), water balance = \(final) ")
        return final
    }
}
