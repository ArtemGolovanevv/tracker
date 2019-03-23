//
//  SelectDrinkValueViewController.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 18.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import UIKit
import CoreData
class SelectDrinkValueViewController: UIViewController {

    private var drink: Drink?
    private var selectedValue: Int?
    private var slider = UISlider()
    private var sliderLabel = UILabel()
    internal var drinkNameLabel = UILabel()
    private var textField = UITextField()
    private var doneButton: UIButton?
    private var cancelButton: UIButton?
    private var segmentControl: UISegmentedControl?
    private var thumbImage = UIImage(named: "drop-2")
    internal var drinkImage = UIImageView()
    internal var getCoefficient = String()
    internal var drinksMethod: SelectDrink?

    override func loadView() {
        super.loadView()
        view.addSubview(sliderLabel)
        view.addSubview(slider)
        view.addSubview(drinkImage)

        sliderAnchor()
        sliderLabelAnchor()
        imageAnchor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customDarkBlueColor.withAlphaComponent(0.9)
        textField.delegate = self

        sliderSettings()
        ButtonsSettings()
        labelsSetting()
        textFieldSettings()
        segmentSettings()
        toolBarSettings()
        doneButtonAnchor()
        cancelButtonAnchor()
        drinkNameLabelAnchor()
        segmentAnchor()
    }
    //MARK: --Settings
    private func ButtonsSettings(){
        let doneButton = UIButton()
        doneButton.setBackgroundImage(UIImage(named: "tick"), for: .normal)
        doneButton.addTarget(self,
                             action: #selector(handleDoneButton(sender: )),
                             for: .touchUpInside)
        let cancelButton = UIButton()
        cancelButton.setBackgroundImage(UIImage(named: "cancel"), for: .normal)
        cancelButton.addTarget(self,
                               action: #selector(handleCancelButton(sender: )),
                               for: .touchUpInside)
        view.addSubview(cancelButton)
        view.addSubview(doneButton)
        self.doneButton = doneButton
        self.cancelButton = cancelButton
    }

    private func labelsSetting()  {
        sliderLabel.font = UIFont.systemFont(ofSize: 30)
        sliderLabel.textColor = UIColor.customMilkWhite
        sliderLabel.text = "0 ml"

        drinkNameLabel.font = UIFont.systemFont(ofSize: 30)
        drinkNameLabel.textColor = UIColor.customMilkWhite
        view.addSubview(drinkNameLabel)
    }

    func sliderSettings() {
        slider.minimumValue = 0.0
        slider.maximumValue = 20.0
        slider.setThumbImage(thumbImage, for: .normal)
        slider.isContinuous = true
        slider.minimumTrackTintColor = UIColor.customLightBlueColor
        slider.maximumTrackTintColor = UIColor.customMilkWhite
        slider.addTarget(self,
                         action: #selector(touchSlider(sender:)),
                         for: .allTouchEvents)
    }

    private func textFieldSettings() {
        textField.borderStyle = .roundedRect
        textField.textColor = UIColor.darkGray
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .center
        textField.backgroundColor = UIColor.customMilkWhite
        textField.placeholder = "Select value"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .always
        textField.keyboardAppearance = .dark
    }

    private func toolBarSettings(){
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: view.frame.size.width,
                                                         height: 20))

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)

        let doneBarButtonItem = UIBarButtonItem(title: "Done",
                                                style: .done,
                                                target: self,
                                                action: #selector(handleDoneToolBarButton))

        toolbar.setItems([flexSpace, doneBarButtonItem], animated: false)
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
        toolbar.barStyle = .blackOpaque
        toolbar.tintColor = UIColor.customMilkWhite
    }

    private func segmentSettings(){
        segmentControl = UISegmentedControl(items: ["SL","TF"])
        segmentControl!.setEnabled(true, forSegmentAt: 0)
        segmentControl?.tintColor = UIColor.customMilkWhite
        segmentControl!.selectedSegmentIndex = 0
        segmentControl!.addTarget(self,
                                  action: #selector(handleSegment(sender:)),
                                  for: .valueChanged)
        view.addSubview(segmentControl!)
    }
    //MARK: -- Actions
    @objc func handleDoneButton(sender: UIButton) {
        var selectedValue = Int()
        if segmentControl?.selectedSegmentIndex == 0 {
            selectedValue = Int(slider.value * 100.0)
        } else {
            selectedValue = Int(textField.text ?? "0") ?? 0
        }
        self.selectedValue = selectedValue
        let date = Date()
        let drinksMethod = SelectDrink.init(value: Int16(self.selectedValue ?? 0), date: date ,
                                            name: drinkNameLabel.text ?? "0",
                                            coefficient: getCoefficient)
        self.drinksMethod = drinksMethod
        let balance = self.drinksMethod?.getFinalValue(name: drinksMethod.name!,
                                                       coefficient: drinksMethod.coefficient!,
                                                       value: Int(drinksMethod.value!))
        if selectedValue != 0 {
            if drink == nil {
                drink = Drink()
            }
            // Saving object
            if let drink = drink {
                drink.name = drinksMethod.name
                drink.quantity = drinksMethod.value ?? 0
                drink.date = drinksMethod.date as NSDate?
                drink.balance = Int16(balance!)
                CoreDataManager.instance.saveContext()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func  handleCancelButton(sender: UIButton){
        self.dismiss(animated: true, completion: nil)

    }
    @objc func touchSlider(sender: UISlider) {
        sliderLabel.text = ("\(String(Int(slider.value * 100.0))) ml")
    }
    @objc func handleDoneToolBarButton() {
        view.endEditing(true)
    }
    // Mark: Segmetn
    @objc func handleSegment(sender: UISegmentedControl) {
        if sender == segmentControl {
            switch segmentControl?.selectedSegmentIndex {
            case 0: view.addSubview(slider)
            view.addSubview(sliderLabel)
            textField.removeFromSuperview()
            sliderAnchor()
            sliderLabelAnchor()

            case 1 : view.addSubview(textField)
            slider.removeFromSuperview()
            sliderLabel.removeFromSuperview()
            textFieldAnchor()
            default: break
            }
        }
    }
    //MARK: --Anchor
    func cancelButtonAnchor() {
        cancelButton!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            (cancelButton!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20)),
            (cancelButton!.widthAnchor.constraint(equalToConstant: 42)),
            (cancelButton!.heightAnchor.constraint(equalToConstant: 42)),
            (cancelButton!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70))
            ])
    }

    func  doneButtonAnchor() {
        doneButton!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton!.widthAnchor.constraint(equalToConstant: 50),
            doneButton!.heightAnchor.constraint(equalToConstant: 50),
            doneButton!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            doneButton!.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20)
            ])
    }

    func sliderAnchor() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            slider.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            slider.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor, constant: -30)
            ])
    }

    func sliderLabelAnchor() {
        sliderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sliderLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130)
            ])
    }

    func textFieldAnchor(){
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            textField.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor, constant: -30)
            ])
    }

    func drinkNameLabelAnchor() {
        drinkNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drinkNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drinkNameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
            ])
    }

    func segmentAnchor() {
        guard segmentControl != nil else {return}
        segmentControl!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl!.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            segmentControl!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -65),
            segmentControl!.widthAnchor.constraint(equalToConstant: 100),
            segmentControl!.heightAnchor.constraint(equalToConstant: 30)
            ])
    }

    func imageAnchor() {
        drinkImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //drinkImage
            drinkImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drinkImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            drinkImage.widthAnchor.constraint(equalToConstant: 100),
            drinkImage.heightAnchor.constraint(equalToConstant: 100)
            ])
    }

}

