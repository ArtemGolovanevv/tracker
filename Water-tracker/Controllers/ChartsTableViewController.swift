//
//  ChartsTableViewController.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 18.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import CoreData
import UIKit

class ChartsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {


    var drinks = [Drink]()
    let customCellIdentifier = "customCell"
    var frc = CoreDataManager.instance.fetchedResultsController(entityName: "Drink", keyForSort: "date")


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.customLightBlueColor
        tableView.separatorColor = UIColor.customMilkWhite
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.title = "Charts Drinks"

        navigationController?.navigationBar.barTintColor = UIColor.customDarkBlueColor
        navigationController?.navigationBar.titleTextAttributes =            [NSAttributedString.Key.foregroundColor:  UIColor.customMilkWhite,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
       // tableView = UITableView(frame: .zero, style: .plain)

       

        tableView.register(UINib(nibName: "ChartsTableViewCell", bundle: nil), forCellReuseIdentifier: customCellIdentifier)


         frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        drinks = frc.fetchedObjects as! [Drink]
}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        drinks = frc.fetchedObjects as! [Drink]
        tableView.reloadData()
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: customCellIdentifier, for: indexPath)
        if let drinksCell = cell as? ChartsTableViewCel {
            let drink = drinks[indexPath.row]
            var thisDate = Date()
            thisDate = drink.date! as Date
            let formatter = DateFormatter()
            formatter.dateFormat = " HH:mm dd/mm/yy"
            drinksCell.dateLabel.text = formatter.string(from: thisDate)
            drinksCell.nameLabel.text = drink.name
            drinksCell.quanttityLabel.text = "\(drink.quantity)ml"
        }
        return cell
    }

     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .delete {
            let managedObject = frc.object(at: indexPath as IndexPath) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
}

