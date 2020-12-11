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
    var cityArray = [City]()
    var propertyArray = [String]()
    var houseArray = [House]()
    
    var toolBar = UIToolbar() //picker toolbar
    var selectedType="0" // search type
    var cityPickerView=UIPickerView()
    var propertyPickerView=UIPickerView()
    
    var selectedCityId = 0
    
    // previously selected indexes from picker view
    var prevSelectedCityIndex = -1
    var prevSelectedPropertyTypeIndex = -1
    
    //MARK:- View Did Load, Get Data, change UI
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCities()
        getPropertyTypes()
        
        // Change apply button UI
        btn_Apply.layer.borderColor = UIColor(red: 71/255, green: 144/255, blue: 123/255, alpha: 1.0).cgColor
        btn_Apply.layer.borderWidth = 1.0
        
        // added tap gesture recognizer programmatically to superview
        let tap = UITapGestureRecognizer(target: self, action: #selector(FilterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // set UI
        if filter.onRent, filter.onBuy {
            self.setButtonUI(false, false, true)
        } else {
            self.setButtonUI(filter.onRent, filter.onBuy, !filter.onRent && !filter.onBuy)
        }
        self.setUI(view_Rent)
        self.setUI(view_Buy)
        self.setUI(view_City)
        self.setUI(view_PropertyType)
        self.setUI(btn_Apply)
        
        if let min = filter.minPrice, min > 0 {
            txtField_Min.text = String(min)
        }
        if let max = filter.maxPrice, max > 0 {
            txtField_Max.text = String(max)
        }
    }
    
    //MARK:- get data and set in array
    private func getCities() {
        HouseStore.instance.getCities { (cities) -> Void in
            self.cityArray = cities
            
            for city in cities {
                // set previously selected index and set label
                if let id = self.filter.cityId, city.id == id {
                    self.prevSelectedCityIndex = self.cityArray.firstIndex(of: city) ?? -1
                    if self.prevSelectedCityIndex >= 0 {
                        self.lbl_City.text = self.cityArray[self.prevSelectedCityIndex].name // change label
                        self.selectedCityId = Int(self.cityArray[self.prevSelectedCityIndex].id) // update variable value
                    }
                }
            }
        }
    }
    
    // prepare property type array from house list
    private func getPropertyTypes() {
        HouseStore.instance.getHouses { (houses) -> Void in
            self.propertyArray.removeAll()
            for house in houses {
                if let type = house.type, !self.propertyArray.contains(type) {
                    self.propertyArray.append(type)
                    
                    // set previously selected index
                    if let ft = self.filter.type, type == ft {
                        self.prevSelectedPropertyTypeIndex = self.propertyArray.count - 1
                        
                        if self.prevSelectedPropertyTypeIndex >= 0 {
                            // update label
                            self.lbl_PropertyType.text = self.propertyArray[self.prevSelectedPropertyTypeIndex]
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- Dismiss keyboard
    @objc func dismissKeyboard() {
        // unlink the views from superview
        toolBar.removeFromSuperview()
        propertyPickerView.removeFromSuperview()
        cityPickerView.removeFromSuperview()
        
        // remove editing focus
        view.endEditing(true)
    }
    
    //MARK:- set UI
    func setUI(_ view:UIView) {
        view.layer.cornerRadius = 8.0
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // change button UI
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
            // change images
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
    
    //MARK:- View Will Disappear, Close keyboard
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    //MARK:- Handle all clicks
    @IBAction func buttonActions(_ sender: UIButton) {
        switch sender.tag {
        case 100://Buy Button
            view.endEditing(true)
            toolBar.removeFromSuperview() //picker toolbar
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
            if prevSelectedCityIndex > 0 {
                cityPickerView.selectRow(prevSelectedCityIndex, inComponent: 0, animated: true)
            }
            cityPickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            
            self.view.addSubview(cityPickerView)
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.items = [UIBarButtonItem.init(title: NSLocalizedString("Done", comment: "Button"), style: .done, target: self, action: #selector(onDoneCityButtonTapped))]
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
            if prevSelectedPropertyTypeIndex > 0 {
                propertyPickerView.selectRow(prevSelectedPropertyTypeIndex, inComponent: 0, animated: true)
            }
            self.view.addSubview(propertyPickerView)
            
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.items = [UIBarButtonItem.init(title: NSLocalizedString("Done", comment: "Button"), style: .done, target: self, action: #selector(onDonePropertyButtonTapped))]
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
    
    // Close picker
    @objc func onDoneCityButtonTapped() {
        toolBar.removeFromSuperview()
        cityPickerView.removeFromSuperview()
    }
    
    // Close picker
    @objc func onDonePropertyButtonTapped() {
        toolBar.removeFromSuperview()
        propertyPickerView.removeFromSuperview()
    }
    
    // on click apply
    func checkValidation() {
        if selectedType == "0" {
            //Show Alert select search Type
            showAlert(NSLocalizedString("Please select search type", comment: "Error"))
        } else if lbl_City.text == NSLocalizedString("Select", comment: "Select") {
            //Show Alert select City
            showAlert(NSLocalizedString("Please select city", comment: "Error"))
        } else if lbl_PropertyType.text == NSLocalizedString("Select", comment: "Select") {
            //Show Alert select Property Type
            showAlert(NSLocalizedString("Please select property type", comment: "Error"))
        } else if txtField_Min.text!.isEmpty {
            //Show Alert Add minimum value
            showAlert(NSLocalizedString("Please select minimum value", comment: "Error"))
        } else if txtField_Max.text!.isEmpty {
            //Show Alert Add maximum value
            showAlert(NSLocalizedString("Please select maximum value", comment: "Error"))
        } else if Double(txtField_Min.text!)! > Double(txtField_Max.text!)! {
            //Show Alert Minimum value should be less
            showAlert(NSLocalizedString("Maximum value should be greater than minimum value", comment: "Error"))
        } else {
            // set filter data
            if selectedType == "1" {
                filter.onBuy = true
                filter.onRent = false
            } else {
                filter.onBuy = false
                filter.onRent = true
            }
            filter.cityId = selectedCityId
            filter.type = lbl_PropertyType.text!
            filter.minPrice = Double(txtField_Min.text!)
            filter.maxPrice = Double(txtField_Max.text!)
            
            // get filtered houses and check if empty
            HouseStore.instance.getFilteredHouses(filter: filter) { (houses) in
                if houses.count == 0 {
                    self.showAlert(NSLocalizedString("No result found", comment: "Error"))
                } else {
                    self.houseArray = houses
                    self.performSegue(withIdentifier: "unwindToback", sender: self)
                }
            }
        }
    }
    
    //MARK:- Set filtered houses in list, on click back
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToback" {
            let dest = segue.destination as! ListViewController
            dest.houses = self.houseArray
        }
    }
}

//MARK:- For city, property type picker
extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // total picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // total options
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cityPickerView {
            return cityArray.count
        } else {
            return propertyArray.count
        }
        
    }
    
    // title of options
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cityPickerView {
            return cityArray[row].name
        } else {
            return propertyArray[row]
        }
    }
    
    // on option selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cityPickerView {
            self.lbl_City.text = cityArray[row].name // change label
            self.selectedCityId = Int(cityArray[row].id) // update variable value
            prevSelectedCityIndex = row
        } else {
            self.lbl_PropertyType.text = propertyArray[row] // update variable value
            prevSelectedPropertyTypeIndex = row
        }
    }
}


