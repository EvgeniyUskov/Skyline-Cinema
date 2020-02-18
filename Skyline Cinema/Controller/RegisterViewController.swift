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
    
    @IBOutlet weak var errorLabel: UILabel!
    
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
        errorLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isPropSet(key: Constants.propLicensePlateNumber) &&
            isPropSet(key: Constants.propCity){
            performSegue(withIdentifier: "goToMainScreen", sender: self)
        }
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: Constants.personalDataWarning, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: nil))

        self.present(alert, animated: true)
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
            defaults.set(licensePlateNumberTextField.text, forKey: Constants.propLicensePlateNumber)
            defaults.set(selectedCity, forKey: Constants.propCity)
            defaults.set(nameTextField.text, forKey: Constants.propName)
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
        errorLabel.text = ""
        
        if !isPropSet(key: Constants.propName) &&
            nameTextField.text?.count == 0  {
            nameSet = false
            errorLabel.isHidden = false
            errorLabel.text = errorLabel.text! + Constants.errorName
        } else {
            nameSet = true
        }
        if !isPropSet(key: Constants.propLicensePlateNumber) &&
            !isNumberCorrect() {
            numberSet = false
            errorLabel.isHidden = false
            errorLabel.text = errorLabel.text! + Constants.errorLicensePlateNumber
        } else {
            numberSet = true
        }
        
        if !isPropSet(key: Constants.propCity) &&
            selectedCity == "" {
            citySet = false
            errorLabel.isHidden = false
            errorLabel.text = errorLabel.text! + Constants.errorCity
        } else {
            citySet = true
        }
        
        
        if !numberSet || !citySet || !nameSet {
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
    
    func isNumberCorrect() -> Bool {
        return !(licensePlateNumberTextField.text?.count == 0 ||
            licensePlateNumberTextField.text!.count < 8 ||
            licensePlateNumberTextField.text!.count > 9)
    }
    
}
