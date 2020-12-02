//
//  HouseStore.swift
//  Housing
//
//  Created by Vidhi Patel on 29/11/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import Foundation

enum GetHousesResult {
    case Success([House])
    case Failure(Error)
}

enum GetHousesError : Error {
    case InvalidJsonError
    case UnexpectedError
}

class HouseStore {
    
    private var houses = [House]()
    
    private let urlSession : URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    private let urlRequest : URLRequest = {
        let url = URLComponents(string: "http://localhost:3000/master")!.url
        return URLRequest(url: url!)
    }()
    
    func getHouses(completion: @escaping([House])->Void){
        if houses.count > 0 {
            OperationQueue.main.addOperation {
                completion(self.houses)
            }
        } else {
            
            let task = urlSession.dataTask(with: urlRequest) {
                (data,response,error)->Void in
                
                if let jsonData = data {
                    let result = self.processHousesResult(json: jsonData)
                    switch result {
                    case let .Success(houses):
                        self.houses = houses
                    case let .Failure(error):
                        print("Error on fetching houses: \(error)")
                    }
                } else if let responseError = error {
                    print("Error on fetching houses: \(responseError)")
                } else {
                    print("Error on fetching houses: Unexpected error")
                }
                OperationQueue.main.addOperation {
                    completion(self.houses)
                }
            }
            task.resume()
        }
    }
    
    private func processHousesResult(json data: Data)->GetHousesResult {
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
            guard
                let jsonDic = jsonObj as? [AnyHashable:Any],
                let housesArr = jsonDic["houses"] as? [[String:Any]]
                else {
                    return .Failure(GetHousesError.InvalidJsonError)
            }
            var houses = [House]()
            for houseJson in housesArr {
                if let house = convertJsonToHouseObj(houseJson) {
                    houses.append(house)
                } else {
                    return .Failure(GetHousesError.InvalidJsonError)
                }
            }
            return .Success(houses)
        } catch let error {
            return .Failure(error)
        }
    }
    
    private func convertJsonToHouseObj(_ json:[String:Any])->House? {
        guard
            let id = json["id"] as! Int?,
            let title = json["title"] as! String?,
            let type = json["type"] as! String?,
            let size = json["size"] as! String?,
            let address = json["address"] as! String?,
            let city = json["city"] as! String?,
            let latitude = json["latitude"] as! Double?,
            let longitude = json["longitude"] as! Double?,
            let price = json["price"] as! Double?,
            let onSale = json["onSale"] as! Bool?,
            let onRent = json["onRent"] as! Bool?,
            let contactNo = json["contactNo"] as! String?,
            let amenities = json["amenities"] as! [String]?,
            let photos = json["photos"] as! [String]?
            else {
                return nil;
        }
        return House(id: id, title: title, type: type, size: size, address: address, city: city,
        latitude: latitude, longitude: longitude, price: price, onSale: onSale, onRent: onRent,
        contactNo: contactNo, amenities: amenities, photos: photos)
    }
    
}
