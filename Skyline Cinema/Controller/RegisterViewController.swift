//
//  RegisterViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 16.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import UIKit
import ChameleonFramework

class RegisterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    
    var defaults = UserDefaults.standard
    var cities : [String] = Cities().names
    var selectedCity: String = ""
    var nameSet: Bool = false
    var citySet: Bool = false
    var numberSet: Bool = false
    
    @IBOutlet weak var errorNameLabel: UILabel!
    @IBOutlet weak var errorNumberLabel: UILabel!
    @IBOutlet weak var errorCityLabel: UILabel!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var licensePlateNumberTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        cityPicker.delegate = self
        cityPicker.dataSource = self
        licensePlateNumberTextField.delegate = self
        nameTextField.delegate = self
        super.viewDidLoad()
        errorNumberLabel.isHidden = true
        errorCityLabel.isHidden = true
        errorNameLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
           if isPropSet(key: Constants.shared.propLicensePlateNumber) &&
                 isPropSet(key: Constants.shared.propCity){
                performSegue(withIdentifier: "goToMainScreen", sender: self)
             }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity = cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        return NSAttributedString(string: cities[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.flatWhite()])
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        if validate(){
            defaults.set(licensePlateNumberTextField.text, forKey: Constants.shared.propLicensePlateNumber)
            defaults.set(selectedCity, forKey: Constants.shared.propCity)
            defaults.set(nameTextField.text, forKey: Constants.shared.propName)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToMainScreen" {
            if !validate() {
                return false
            }
            return true
        }
        return false
    }
    
    func validate () -> Bool {
        if !isPropSet(key: Constants.shared.propName){
            if nameTextField.text?.count == 0 {
                nameSet = false
            }
            else {
                nameSet = true
            }
        }
        if !isPropSet(key: Constants.shared.propLicensePlateNumber) {
            if licensePlateNumberTextField.text?.count == 0 ||
                licensePlateNumberTextField.text!.count < 8 ||
                licensePlateNumberTextField.text!.count > 9 {
                numberSet = false
            }
            else {
                numberSet = true
            }
        }
        
        if !isPropSet(key: Constants.shared.propCity) {
            if selectedCity == "" {
                citySet = false
            }
            else {
                citySet = true
            }
        }
        
        if !numberSet {
            errorNumberLabel.isHidden = false
        }
        if !citySet {
            errorCityLabel.isHidden = false
        }
        if !nameSet {
            errorNameLabel.isHidden = false
        }
        
        if !numberSet || !citySet {
            return false
        }
        return true
    }
    
    func isPropSet(key: String) -> Bool {
        if defaults.string(forKey: key) != nil {
            return true
        }
        return false
    }
    
}
