//
//  ChooseCollectionViewController.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 18.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ChooseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var drinksData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        drinksData = Data()
        collectionView.backgroundColor = UIColor.customLightBlueColor
        navigationItem.title = "Drinks List"

        navigationController?.navigationBar.barTintColor = UIColor.customDarkBlueColor

        navigationController?.navigationBar.titleTextAttributes =            [NSAttributedString.Key.foregroundColor:  UIColor.customMilkWhite,
                                                                              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]

        self.collectionView!.register(DrinksCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
   internal override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinksData?.drinks.count ?? 0
    }
    internal override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DrinksCell
        cell.drinks = drinksData?.drinks[indexPath.item]
        return cell
    }

   internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionSize = CGSize(width: (view.frame.width / 3) - 16, height: 100)
        return collectionSize
    }

    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inserts = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return inserts
    }

    // MARK: UICollectionViewDelegate
    internal override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = drinksData?.drinks[indexPath.row] 
        let selectValue = SelectDrinkValueViewController()
        selectValue.drinkNameLabel.text = cell?.name
        selectValue.drinkImage.image = UIImage(named: cell?.image! ?? "")
        selectValue.getCoefficient = (cell?.coefficient)!
        selectValue.modalTransitionStyle = .coverVertical
        selectValue.modalPresentationStyle = .custom
        self.present(selectValue, animated: true, completion: nil)
    }
}
