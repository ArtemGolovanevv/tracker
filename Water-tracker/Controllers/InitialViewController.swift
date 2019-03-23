//
//  InitialViewController.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 18.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import UIKit
import CoreData

class InitialViewController: UIViewController, NSFetchedResultsControllerDelegate {

    private weak var selectDrinkButton: UIButton?
    private weak var nameLabel: UILabel?
    private weak var balanceLabel: UILabel?
    private weak var goalLabel: UILabel?
    private var getGoal = [UserConfiguration]()
    private var getSelectedDrink = [Drink]()
    private var sumGoal = Int()
    private var percent: Percentage?
    private var total = Int()
    private var goal = Int()
    private var imageForButton = UIImage(named: "wine")
    private var frcGoal = CoreDataManager.instance.fetchedResultsController(entityName: "UserConfiguration", keyForSort:"date")
    private var frcDrink = CoreDataManager.instance.fetchedResultsController(entityName: "Drink", keyForSort:"date")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "drop-3")
        self.tabBarController?.tabBar.items?[1].image = UIImage(named: "line-chart")
        self.tabBarController?.tabBar.items?[2].image = UIImage(named: "settings")

        characteristicOfFirstButton()
        labelSettings()
        buttonAnchor()
        nameLabelAnchor()
        balanceLabelAnchor()
        goalLabelAnchor()
    }

    override func viewWillAppear(_ animated: Bool) {
        view.reloadInputViews()
        var balanceArry  = [Int]()
        var total = Int()
        do {
            try frcDrink.performFetch()
            try frcGoal.performFetch()
        } catch {
            print(error)
        }
        getSelectedDrink = frcDrink.fetchedObjects as? [Drink] ?? []
        getGoal = frcGoal.fetchedObjects as? [UserConfiguration] ?? []

        for goal in getGoal {
            sumGoal = Int(goal.goal)
        }
        print(sumGoal)

        for drink in getSelectedDrink {
            balanceArry.append(Int(drink.balance))
            total = balanceArry.reduce(0, +)
            if sumGoal == 0 {
                nameLabel?.text = "Please set goal"
                balanceLabel?.text = ""
                goalLabel?.text = ""
            } else {
                let percent = Percentage(goal: sumGoal, total: total)
                let percentTarget = percent.setPercentage(goal: sumGoal, total: total)
                self.percent = percent
                nameLabel?.text = "You drank: \(drink.name!)"
                balanceLabel?.text = "Your water balance: \(total)"
                goalLabel?.text =   "Target: \(percentTarget) "
                //print(drink.name as Any)
                //print(percentTarget)
                //print(sumGoal)
                //print(total)
            }
        }
    }

    //MARK: Settings
    private func characteristicOfFirstButton(){
        let selectDrinkButton = UIButton()
        selectDrinkButton.addTarget(self,
                                    action: #selector(goToChoose(param:)),
                                    for: .touchUpInside)
        view.addSubview(selectDrinkButton)
        selectDrinkButton.setBackgroundImage(UIImage(named: "menu"), for: .normal)
        self.selectDrinkButton = selectDrinkButton
    }

    func labelSettings() {
        let nameLabel = UILabel()
        let balanceLabel = UILabel()
        let goalLabel = UILabel()

        for label in [nameLabel, balanceLabel, goalLabel] {
            label.textColor = UIColor.customMilkWhite
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 25)
            view.addSubview(label)
        }
        self.nameLabel = nameLabel
        self.balanceLabel = balanceLabel
        self.goalLabel = goalLabel
    }
    //MARK: Actions
    @objc func goToChoose(param: Any) {

        let layout = UICollectionViewFlowLayout()
        let chooseCollection = ChooseCollectionViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(chooseCollection, animated: true)
    }
    //MARK: Anchors
    private func buttonAnchor() {

        selectDrinkButton?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            (selectDrinkButton?.centerXAnchor.constraint(equalTo: view.centerXAnchor))!,
            (selectDrinkButton?.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100))!,
            (selectDrinkButton?.widthAnchor.constraint(equalToConstant: 150))!,
            (selectDrinkButton?.heightAnchor.constraint(equalToConstant: 150))!
            ])
    }

    private func nameLabelAnchor() {

        nameLabel!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel!.centerYAnchor.constraint(equalTo: selectDrinkButton!.centerYAnchor, constant: 130)
            ])
    }
    private func balanceLabelAnchor() {

        balanceLabel!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            balanceLabel!.centerYAnchor.constraint(equalTo: nameLabel!.centerYAnchor, constant: 40)
            ])
    }
    private func goalLabelAnchor() {

        goalLabel!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goalLabel!.centerYAnchor.constraint(equalTo: balanceLabel!.centerYAnchor, constant: 40)
            ])
    }
}

