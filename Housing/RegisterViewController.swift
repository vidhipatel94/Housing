//
//  RegisterViewController.swift
//  Housing
//
//  Created on 29/11/20.
//  Author: Shravani Gandla
//  Copyright © 2020 Conestoga. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // user entered data
    var namedata:String!
    var emaildata:String!
    var phonedata:String!
    var addressdata:String!
    
    var currentLang:String!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var done: UIButton!
    
    @IBOutlet weak var error: UILabel!
    
    @IBOutlet weak var languageButton: UIBarButtonItem!
    
    //MARK:- change user is created or not
    override func viewWillAppear(_ animated: Bool) {
        
        // get user from UserDefaults database
        let user = UserStore.instance.getUser()
        
        // if user exists or already created, redirect to dashboard
        if let _ = user {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let dashboardVC = storyBoard.instantiateViewController(withIdentifier: "dashboard") as! DashboardViewController
            self.navigationController?.pushViewController(dashboardVC, animated: false)
        }
    }
    
    //MARK:- initalize all
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change done button UI
        let greenColor = UIColor(red: 0.42, green: 0.73, blue: 0.6, alpha: 1).cgColor
        done.layer.borderColor = greenColor
        done.layer.borderWidth = 1
        done.layer.cornerRadius = 4
        done.contentEdgeInsets.left = 20
        done.contentEdgeInsets.right = 20
        done.contentEdgeInsets.top = 10
        done.contentEdgeInsets.bottom = 10
        
        // UITextFieldDelegate
        name.delegate = self
        email.delegate = self
        address.delegate = self
        phone.delegate = self
        
        // get current language and change nav bar button title
        currentLang = LanguageStore.instance.getLanguage()
        if currentLang == nil {
            currentLang = Locale.current.languageCode
            if currentLang != nil, currentLang == "fr" {
                currentLang = "fr-CA"
            }
        }
        // if current lang is french, display option english and vice-a-versa
        if let l = currentLang, l == "fr-CA" {
            languageButton.title = "English"
        } else {
            languageButton.title = "French"
        }
    }
    
    //MARK:- on tap outside, close keyboard
    @IBAction func onTapMade(_ sender: Any) {
        view.endEditing(true)
    }
    
    //MARK:- validate and save data before going on next screen
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if(!validateAndSaveData()){
            return false
        }
        return true
    }
    
    func validateAndSaveData() -> Bool {
        
        // close keyboard
        view.endEditing(true)
        
        // get data from text fields
        namedata = name.text
        emaildata = email.text
        phonedata = phone.text
        addressdata = address.text
        
        if namedata == nil || namedata.trimmingCharacters(in: .whitespaces).count == 0 {
            error.text = NSLocalizedString("Enter name", comment: "Error")
            return false
        }
        
        if emaildata == nil || emaildata.trimmingCharacters(in: .whitespaces).count == 0 {
            error.text = NSLocalizedString("Enter email address", comment: "Error")
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailResult = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailValid = emailResult.evaluate(with: emaildata)
        if !emailValid {
            error.text = NSLocalizedString("Email address is not valid", comment: "Error")
            return false
        }
        
        if phonedata == nil || phonedata.trimmingCharacters(in: .whitespaces).count == 0 {
            error.text = NSLocalizedString("Enter phone number", comment: "Error")
            return false
        }
        let phoneRegEx = "^\\d{3}[\\- ]?\\d{3}[\\- ]?\\d{4}$"
        // format:- (123-123-1234) or (123 123 1234) or (1231231234)
        let phoneResult = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        let phoneValid = phoneResult.evaluate(with: phonedata)
        if !phoneValid {
            error.text = NSLocalizedString("Phone number is not valid", comment: "Error")
            return false
        }
        
        if addressdata == nil || addressdata.trimmingCharacters(in: .whitespaces).count == 0 {
            error.text = NSLocalizedString("Enter address", comment: "Error")
            return false
        }
        
        saveUser()
        
        return true
    }
    
    func saveUser() {
        // saave into user defaults database
        let user = User(name: namedata, email: emaildata, phone: phonedata, address: addressdata)
        UserStore.instance.saveUser(user: user)
    }
    
    //MARK:- on click return button of keyboard, close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- change language
    @IBAction func languageClicked(_ sender: Any) {
        // flip language between english and french-canada
        if let l = currentLang, l == "fr-CA" {
            changeLanguage(lang: "en")
        } else {
            changeLanguage(lang: "fr-CA")
        }
    }
    
    func changeLanguage(lang: String) {
        currentLang = lang
        
        // save to database
        LanguageStore.instance.saveLanguage(lang: lang)
        
        // change lang using bundle
        Bundle.setLanguage(lang)
        
        // reload storyboard
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = storyboard.instantiateInitialViewController()
    }
}
