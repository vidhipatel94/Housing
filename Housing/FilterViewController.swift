//
//  FilterViewController.swift
//  Housing
//
//  Created on 29/11/20.
//  Author: Simranjit Singh
//  Copyright © 2020 Conestoga. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btn_Apply: UIButton!
    @IBOutlet weak var txtField_Max: UITextField!
    @IBOutlet weak var txtField_Min: UITextField!
    @IBOutlet weak var btn_PropertyType: UIButton!
    @IBOutlet weak var lbl_PropertyType: UILabel!
    @IBOutlet weak var view_PropertyType: UIView!
    @IBOutlet weak var view_City: UIView!
    @IBOutlet weak var btn_SelectCity: UIButton!
    @IBOutlet weak var lbl_City: UILabel!
    @IBOutlet weak var view_Buy: UIView!
    @IBOutlet weak var btn_Buy: UIButton!
    @IBOutlet weak var imgView_Rent: UIImageView!
    @IBOutlet weak var imgView_Buy: UIImageView!
    @IBOutlet weak var btn_Rent: UIButton!
    @IBOutlet weak var view_Rent: UIView!
    
    //MARK:- Variables
    var filter = Filter()
    var cityArray = ["Toronto","Missisauga","Scarbrough","Brampton","Waterloo","Kitchener"]
    var propertyArray = ["Villa","Basement","Bungalow","Condos","Apartment"]
    var houseArray = [House]()
    
    var toolBar = UIToolbar()
    var selectedType="0"
    var cityPickerView=UIPickerView()
    var propertyPickerView=UIPickerView()
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_Apply.layer.borderColor = UIColor(red: 71/255, green: 144/255, blue: 123/255, alpha: 1.0).cgColor
        btn_Apply.layer.borderWidth = 1.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(FilterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.setButtonUI(false, false, true)
        self.setUI(view_Rent)
        self.setUI(view_Buy)
        self.setUI(view_City)
        self.setUI(view_PropertyType)
        self.setUI(btn_Apply)
    }
    
    //MARK:- Dismiss keyboard
    @objc func dismissKeyboard() {
        toolBar.removeFromSuperview()
        propertyPickerView.removeFromSuperview()
        cityPickerView.removeFromSuperview()
        
        view.endEditing(true)
    }
    
    
    func setUI(_ view:UIView) {
        view.layer.cornerRadius = 8.0
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setUI(_ btn:UIButton) {
        let greenColor = UIColor(red: 0.42, green: 0.73, blue: 0.6, alpha: 1).cgColor
        btn.layer.borderColor = greenColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        btn.contentEdgeInsets.left = 20
        btn.contentEdgeInsets.right = 20
        btn.contentEdgeInsets.top = 10
        btn.contentEdgeInsets.bottom = 10
    }
    
    func setButtonUI(_ isRentSelected:Bool,_ isBuySelected:Bool,_ noneSelected:Bool) {
        if noneSelected {
            selectedType = "0"
            imgView_Rent.image = UIImage(named: "Unselected")
            imgView_Buy.image = UIImage(named: "Unselected")
        } else if isBuySelected {
            selectedType = "1"
            imgView_Rent.image = UIImage(named: "Unselected")
            imgView_Buy.image = UIImage(named: "Selected")
        } else if isRentSelected {
            selectedType = "2"
            imgView_Rent.image = UIImage(named: "Selected")
            imgView_Buy.image = UIImage(named: "Unselected")
        }
    }
    
    //MARK:- View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    @IBAction func buttonActions(_ sender: UIButton) {
        switch sender.tag {
        case 100://Buy Button
            view.endEditing(true)
            toolBar.removeFromSuperview()
            propertyPickerView.removeFromSuperview()
            cityPickerView.removeFromSuperview()
            setButtonUI(false, true, false)
         case 101://Rent Button
            view.endEditing(true)
            toolBar.removeFromSuperview()
            propertyPickerView.removeFromSuperview()
            cityPickerView.removeFromSuperview()
             setButtonUI(true, false, false)
        case 102://City Button
            view.endEditing(true)
            toolBar.removeFromSuperview()
            propertyPickerView.removeFromSuperview()
            cityPickerView = UIPickerView.init()
            cityPickerView.delegate = self
            cityPickerView.dataSource = self
            cityPickerView.backgroundColor = UIColor.white
            cityPickerView.setValue(UIColor.black, forKey: "textColor")
            cityPickerView.autoresizingMask = .flexibleWidth
            cityPickerView.contentMode = .center
            cityPickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(cityPickerView)
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneCityButtonTapped))]
            self.view.addSubview(toolBar)
        case 103://Property Type Button
            view.endEditing(true)
            toolBar.removeFromSuperview()
            cityPickerView.removeFromSuperview()

            propertyPickerView = UIPickerView.init()
            propertyPickerView.delegate = self
            propertyPickerView.dataSource = self
            propertyPickerView.backgroundColor = UIColor.white
            propertyPickerView.setValue(UIColor.black, forKey: "textColor")
            propertyPickerView.autoresizingMask = .flexibleWidth
            propertyPickerView.contentMode = .center
            propertyPickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(propertyPickerView)
            
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDonePropertyButtonTapped))]
            self.view.addSubview(toolBar)
        case 104://Apply Button
            toolBar.removeFromSuperview()
            propertyPickerView.removeFromSuperview()
            cityPickerView.removeFromSuperview()

            checkValidation()
        default:
            break
        }
    }
    
    @objc func onDoneCityButtonTapped() {
        toolBar.removeFromSuperview()
        cityPickerView.removeFromSuperview()
     }
    
    @objc func onDonePropertyButtonTapped() {
        toolBar.removeFromSuperview()
        propertyPickerView.removeFromSuperview()
     }
    
    func checkValidation() {
        if selectedType == "0" {
            //Show Alert select Type
            showAlert("Please select search type")
        } else if lbl_City.text == "Select" {
            //Show Alert select City
            showAlert("Please select city")
        } else if lbl_PropertyType.text == "Select" {
            //Show Alert select Property Type
            showAlert("Please select property type")
        } else if txtField_Min.text!.isEmpty {
            //Show Alert Add minimum value
            showAlert("Please select minimum value")
        } else if txtField_Max.text!.isEmpty {
            //Show Alert Add maximum value
            showAlert("Please select maximum value")
        } else if Int(txtField_Min.text!)! > Int(txtField_Max.text!)! {
            //Show Alert Minimum value should be less
            showAlert("Maximum value should be greater than minimum value")
        } else {
            if selectedType == "1" {
                filter.onBuy = true
                filter.onRent = false
            } else {
                filter.onBuy = false
                filter.onRent = true
            }
            filter.city = lbl_City.text!
            filter.type = lbl_PropertyType.text!
            filter.minPrice = Double(txtField_Min.text!)
            filter.maxPrice = Double(txtField_Max.text!)
            
            HouseStore.instance.getFilteredHouses(filter: filter) { (house) in
                if house.count == 0 {
                    self.showAlert("No result found")
                } else {
                    self.houseArray = house
                    self.performSegue(withIdentifier: "unwindToback", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToback" {
            let dest = segue.destination as! ListViewController
            dest.houses = self.houseArray
        }
    }
    

}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cityPickerView {
            return cityArray.count
        } else {
            return propertyArray.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPickerView {
            return cityArray[row]
        } else {
            return propertyArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cityPickerView {
            self.lbl_City.text = cityArray[row]
        } else {
            self.lbl_PropertyType.text = propertyArray[row]
        }
    }
}


