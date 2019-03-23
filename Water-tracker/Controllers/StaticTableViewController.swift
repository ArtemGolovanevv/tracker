//
//  StaticTableViewController.swift
//  Water-tracker
//
//  Created by Artem Golovanev on 18.03.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import UIKit
import MessageUI
import CoreData
class StaticTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate {
  
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var goalTextField: UITextField!
    private weak var pickerView: UIPickerView?

    private  var transmissionData: Data?
    private var notif: NotificationTime?
    private var putSettings: UserConfiguration?
    private var getSettings = [UserConfiguration]()
    private var fromDatePicker: UIDatePicker?
    private var toDatePicker: UIDatePicker?
    private var notifSwitch = Bool()
    private var settings: DataSettings?

    internal var timeInterval: Int16 = 0
    private var sex: Bool = true
    private var calculate: Bool = false
    private var selectedForWeight: Int16 = 30
    private var selectedForGoal: Int16 = 100
    private var frc = CoreDataManager.instance.fetchedResultsController(entityName: "UserConfiguration", keyForSort:"date")

    override func viewDidLoad() {
        super.viewDidLoad()
        transmissionData = Data()
        datePickerSettings()
        notifTextFieldLock()
        picker()
          setupModel()
        pickerView?.dataSource = self
        pickerView?.delegate = self
        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            print(error)
        }

        getSettings = frc.fetchedObjects as! [UserConfiguration]

        for newSet in getSettings{
            frc.fetchRequest.fetchBatchSize = 1
            frc.fetchRequest.fetchLimit = 1
            selectedForWeight = newSet.weight
            selectedForGoal = newSet.goal
         //   sex = newSet.sex
            notifSwitch = newSet.notifIsOn
            fromDatePicker?.date = newSet.from! as Date
            toDatePicker?.date = newSet.to! as Date
            timeInterval = newSet.frequency
            print(newSet)
            print(getSettings)
            weightTextField.text = "\(selectedForWeight)kg"
            goalTextField.text = "\(selectedForGoal)ml"
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        let thisDate = Date()
        let notif = NotificationTime(firstTimePoint: (fromDatePicker?.date ?? thisDate), secondTimePoint: (toDatePicker?.date ?? thisDate), selectedRange: 10)
        self.notif = notif
        //print("\(String(describing: putSettings))")
        if putSettings == nil {
            putSettings = UserConfiguration()
        }
        // Saving object
        if let putSettings = putSettings {
            putSettings.weight = selectedForWeight
            putSettings.goal = selectedForGoal
          //  putSettings.sex = sex
            //putSettings.calculate = calculate
            putSettings.notifIsOn = notifSwitch
            putSettings.from = fromDatePicker?.date as NSDate?
            putSettings.to = toDatePicker?.date as NSDate?
            putSettings.frequency = timeInterval
            putSettings.date = Date() as NSDate
            CoreDataManager.instance.saveContext()
        }
    }
    //MARK: Settings
    private func setupModel(){
        var settings = DataSettings(sex: sex, weight: Int(selectedForWeight), goal: Int(selectedForGoal) , calculate: calculate )
        self.settings = settings
      //  print(" \(String(describing: settings.weight))")

        let change = settings.setForAuto(weight: Int(selectedForWeight), calculate: calculate, sex: sex )
      //  print(" \(String(describing: change))")
        selectedForGoal = Int16(change)
        print("\(String(describing: settings.sex))")
        print("\(sex)")
       goalTextField.text = "\(selectedForGoal)ml"
        weightTextField.text = "\(selectedForWeight)kg"
        
    }

    private func picker() {
        let pickerView = UIPickerView()
        for field in [goalTextField, weightTextField, frequencyTextField] {
            field?.delegate = self
            field?.inputView = pickerView
            self.pickerView = pickerView
        }
    }

    private func notifTextFieldLock() {
        fromTextField.isEnabled = false
        toTextField.isEnabled = false
        frequencyTextField.isEnabled = false
    }

    private func datePickerSettings() {
        let fromDatePicker = UIDatePicker()
        let toDatePicker = UIDatePicker()
        fromDatePicker.datePickerMode = .time
        toDatePicker.datePickerMode = .time
        fromDatePicker.addTarget(self, action: #selector (fromDateChange(sender:)), for: .valueChanged)
        toDatePicker.addTarget(self, action: #selector (toDateChange(sender:)), for: .valueChanged)
        self.fromDatePicker = fromDatePicker
        self.toDatePicker = toDatePicker
    }
    //MARK: Actions
    @objc func viewTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }

    @objc func toDateChange(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        toTextField.text = formatter.string(from: (toDatePicker?.date)!)
        view.endEditing(true)
    }

    @objc func fromDateChange(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        fromTextField.text = formatter.string(from: (fromDatePicker?.date)!)
        view.endEditing(true)
    }

    @IBAction func handleAutoBttn(_ sender: UIButton) {
        setupModel()
        print(settings?.goal as Any)
        calculate = true
    }
    @IBAction func hanldeNotificationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            notifSwitch = true
            for field in [fromTextField, toTextField, frequencyTextField] {
                field?.isEnabled = true
               // let formatter = DateFormatter()
                //formatter.dateFormat = "HH:mm"
                //field?.text = formatter.string(from: (Date()))
                for label in [fromLabel, toLabel, frequencyLabel] {
                    label?.textColor = UIColor.customLightBlueColor
                }
            }
            frequencyTextField.inputView = pickerView
            toTextField.inputView = toDatePicker
            fromTextField?.inputView = fromDatePicker
        }
        else {
            notifSwitch = false
            for field in [fromTextField, toTextField, frequencyTextField] {
                field?.isEnabled = false
                field?.text = ""
                for label in [fromLabel, toLabel, frequencyLabel] {
                    label?.textColor = .lightGray
                }
            }
        }
    }
    @IBAction func handleSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex ==  0{
            sex = true
        } else {
            sex = false
        }
    }
    @IBAction func handleSendEmail(_ sender: Any) {
        let email = "example@example.com"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    private func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView?.reloadAllComponents()
    }
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if weightTextField.isFirstResponder {
            return transmissionData?.kg.count ?? 0
        } else if goalTextField.isFirstResponder {
            return  transmissionData?.ml.count ?? 0
        } else if frequencyTextField.isFirstResponder {
            return transmissionData?.range.count ?? 0
        }
        return 0
    }
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if weightTextField.isFirstResponder {
            return transmissionData?.kg[row].description
        } else if goalTextField.isFirstResponder {
            return  transmissionData?.ml[row].description
        } else if frequencyTextField.isFirstResponder {
            // secletData = transmissionData?.range[row].quantity
            return  transmissionData?.range[row].description
        }
        return "0"
    }

    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if weightTextField.isFirstResponder {
            selectedForWeight = Int16(transmissionData?.kg[row].quantity ?? 30)
            weightTextField.text = "\(selectedForWeight)kg"
        } else if goalTextField.isFirstResponder {
            selectedForGoal = Int16(transmissionData?.ml[row].quantity ?? 100)
           // print("теперь стало \(String(describing: selectedForGoal))")
            goalTextField.text = "\(selectedForGoal)ml"
        } else if frequencyTextField.isFirstResponder {
            frequencyTextField.text = transmissionData?.range[row].description
            timeInterval = Int16(transmissionData?.range[row].quantity ?? 0)
            print(timeInterval)
        }
        view.endEditing(true)
    }

}

