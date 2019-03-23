//
//  DrinksCell.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 18.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import UIKit

class DrinksCell: UICollectionViewCell {
    
    var drinks: ReciveImagesToDrinks? {
        didSet {
            guard let drinksImage = drinks?.image else { return }
            guard let drinksName = drinks?.name else { return }
            guard (drinks?.coefficient) != nil else {return}
            
            drinksImageView.image = UIImage(named: drinksImage)
            drinksNameLabel.text = drinksName
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setCellShadow()
        
    }
    private func setup(){
        
        self.backgroundColor = UIColor.customDarkBlueColor
        self.addSubview(drinksImageView)
        self.addSubview(drinksNameLabel)
        
        drinksImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        drinksNameLabel.anchor(top: drinksImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    private let drinksImageView: UIImageView = {
        
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor.customDarkBlueColor
        return image
    }()
    
    private let drinksNameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Name"
        label.textColor =  UIColor.customMilkWhite
        label.font = UIFont.boldSystemFont(ofSize: 13 )
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

