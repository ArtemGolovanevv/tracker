//
//  ChartsTable.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 20.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import UIKit
import CoreData
class ChartsTable: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
  //TODO: Create normal segmentControl
    let segment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Days","Months", "Years"])
        sc.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
        sc.backgroundColor = UIColor.customDarkBlueColor
        sc.tintColor = UIColor.customMilkWhite
        return sc

    }()

    var drinks = [Drink]()
    let customCellIdentifier = "customCell"
    var frc = CoreDataManager.instance.fetchedResultsController(entityName: "Drink", keyForSort: "date")

    let tableView = UITableView(frame: .zero, style: .plain)


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
          frc.delegate = self
        tableView.backgroundColor = UIColor.customLightBlueColor
        tableView.separatorColor = UIColor.customMilkWhite

        navigationItem.title = "Charts Drinks"
        navigationController?.navigationBar.barTintColor = UIColor.customDarkBlueColor
        navigationController?.navigationBar.titleTextAttributes =            [NSAttributedString.Key.foregroundColor:  UIColor.customMilkWhite,
                                                                              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]

        let stackView = UIStackView(arrangedSubviews: [segment,tableView])
        stackView.axis = .vertical
        view.addSubview(stackView)

        stackView.anchor(top: view.safeTopAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)


        tableView.register(UINib(nibName: "ChartsTableViewCell", bundle: nil), forCellReuseIdentifier: customCellIdentifier)



        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        drinks = frc.fetchedObjects as? [Drink] ?? []
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        drinks = frc.fetchedObjects as? [Drink] ?? []
        tableView.reloadData()
    }

    @objc private func handleSegment() {
/*
        switch  segment.selectedSegmentIndex {
        case 0:

        case 1:
        <#code#>

        case 2:

        default: break
        }
*/
    }
    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {

        guard let sections = frc.sections else { return 0 }
        return sections.count
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: customCellIdentifier, for: indexPath)
        if let drinksCell = cell as? ChartsTableViewCel {
            let drink = drinks[indexPath.row]
            var thisDate = Date()
            thisDate = drink.date! as Date
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            drinksCell.dateLabel.text = formatter.string(from: thisDate)
            drinksCell.nameLabel.text = drink.name
            drinksCell.quanttityLabel.text = "\(drink.quantity)ml"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80

    }
/*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = frc.object(at: indexPath as IndexPath) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = frc.sections else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = ""
        let abc = sections[section].indexTitle
        let cba = formatter.string(for: abc)
        return cba
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = frc.sections else { return 0 }
        return sections[section].numberOfObjects
}

*/
}




