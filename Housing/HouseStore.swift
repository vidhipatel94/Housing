//
//  HouseStore.swift
//  Housing
//
//  Created by Vidhi Patel on 29/11/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum GetServerDataResult {
    case Success(GetServerDataResponse)
    case Failure(Error)
}

enum GetServerDataError : Error {
    case InvalidJsonError
    case UnexpectedError
}

class HouseStore {
    
    static let instance = HouseStore() //Singleton
    
    private init() {
        
    }
    
    //MARK:- used while doing operations with core data
    private let citiesPersistentContainer: NSPersistentContainer = {
        return getPersistentContainer(model: "City")
    }()
    
    private let housesPersistentContainer: NSPersistentContainer = {
        return getPersistentContainer(model: "House")
    }()
    
    private static func getPersistentContainer(model:String)-> NSPersistentContainer {
        let container = NSPersistentContainer(name: "Housing")
        
        // path where sqlite file will be or is stored
        let storeURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("\(model).sqlite")
        
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.shouldInferMappingModelAutomatically = true // to handle mapping data
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Error: Unresolved error \(error)")
            }
        }
        return container
    }
    
    //MARK:- used for calling json service or network call
    private let urlSession : URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    private let urlRequest : URLRequest = {
        // path given by json-server
        let url = URLComponents(string: "http://localhost:3000/master")!.url
        return URLRequest(url: url!)
    }()
    
    //MARK:- fetch cities from database
    private func fetchCities()->[City]! {
        let fetchRequest : NSFetchRequest<City> = City.fetchRequest()
        // order by city.id ascending
        let sortDescriptor = NSSortDescriptor(key: #keyPath(City.id), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // used city NSManagedObjectContext
        let context = citiesPersistentContainer.viewContext
        
        // perform fetching and get list
        var cities: [City]!
        context.performAndWait {
            do {
                cities = try context.fetch(fetchRequest)
            } catch let error {
                print("Error on fetching cities \(error)")
            }
        }
        return cities
    }
    
    //MARK:- if cities exist in database, return the list, otherwise perform network call
    func getCities(completion: @escaping([City])->Void){
        // fetch cities from database
        var cities = fetchCities() ?? [City]()
        if cities.count > 0 {
            OperationQueue.main.addOperation {
                completion(cities)
            }
        } else {
            // get cities and houses from server as both uses same json file
            let task = urlSession.dataTask(with: urlRequest) {
                (data,response,error)->Void in
                
                if let jsonData = data {
                    // store data in database and get response object
                    let result = self.processServerDataResult(json: jsonData)
                    switch result {
                    case let .Success(serverDataResponse):
                        self.saveContexts()
                        cities = serverDataResponse.cities
                    case let .Failure(error):
                        print("Error on getting cities: \(error)")
                    }
                } else if let responseError = error {
                    print("Error on getting cities: \(responseError)")
                } else {
                    print("Error on getting cities: Unexpected error")
                }
                OperationQueue.main.addOperation {
                    completion(cities)
                }
            }
            task.resume()
        }
    }
    
    // if any data is inserted, perform save operation
    private func saveContexts(){
        if citiesPersistentContainer.viewContext.hasChanges {
            do {
                try citiesPersistentContainer.viewContext.save()
            } catch {
                print("Error on save city context: \(error)")
            }
        }
        if housesPersistentContainer.viewContext.hasChanges {
            do {
                try housesPersistentContainer.viewContext.save()
            } catch {
                print("Error on save house context: \(error)")
            }
        }
    }
    
    //MARK:- fetch houses from database
    private func fetchHouses()->[House]! {
        let fetchRequest : NSFetchRequest<House> = House.fetchRequest()
        // order by house.id ascending
        let sortDescriptor = NSSortDescriptor(key: #keyPath(House.id), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // used house NSManagedObjectContext
        let context = housesPersistentContainer.viewContext
        
        // perform fetching and get list
        var houses: [House]!
        context.performAndWait {
            do {
                houses = try context.fetch(fetchRequest)
            } catch let error {
                print("Error on fetching houses \(error)")
            }
        }
        return houses
    }
    
    //MARK:- if cities exist in database, return the list, otherwise perform network call
    func getHouses(completion: @escaping([House])->Void){
        // fetch houses from database
        var houses = fetchHouses() ?? [House]()
        if houses.count > 0 {
            OperationQueue.main.addOperation {
                completion(houses)
            }
        } else {
            // get cities and houses from server as both uses same json file
            let task = urlSession.dataTask(with: urlRequest) {
                (data,response,error)->Void in
                
                if let jsonData = data {
                    // store data in database and get response object
                    let result = self.processServerDataResult(json: jsonData)
                    switch result {
                    case let .Success(serverDataResponse):
                        self.saveContexts()
                        houses = serverDataResponse.houses
                    case let .Failure(error):
                        print("Error on getting houses: \(error)")
                    }
                } else if let responseError = error {
                    print("Error on getting houses: \(responseError)")
                } else {
                    print("Error on getting houses: Unexpected error")
                }
                OperationQueue.main.addOperation {
                    completion(houses)
                }
            }
            task.resume()
        }
    }
    
    // This prepares GetServerDataResponse object from Json
    private func processServerDataResult(json data: Data)->GetServerDataResult {
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
            guard
                let jsonDic = jsonObj as? [AnyHashable:Any],
                let citiesArr = jsonDic["cities"] as? [[String:Any]],
                let housesArr = jsonDic["houses"] as? [[String:Any]]
                else {
                    return .Failure(GetServerDataError.InvalidJsonError)
            }
            
            // prepare array of cities
            var cities = [City]()
            for cityJson in citiesArr {
                if let city = getCityObj(cityJson) {
                    cities.append(city)
                } else {
                    return .Failure(GetServerDataError.InvalidJsonError)
                }
            }
            
            // prepare array of houses
            var houses = [House]()
            for houseJson in housesArr {
                if let house = getHouseObj(houseJson) {
                    houses.append(house)
                } else {
                    return .Failure(GetServerDataError.InvalidJsonError)
                }
            }
            
            // create GetServerDataResponse object
            let responseObj = GetServerDataResponse()
            responseObj.cities = cities
            responseObj.houses = houses
            return .Success(responseObj)
        } catch let error {
            return .Failure(error)
        }
    }
    
    // This prepares City object from Json, save to database if not exist in db
    private func getCityObj(_ json:[String:Any])->City? {
        guard
            let id = json["id"] as! Int?,
            let name = json["name"] as! String?,
            let photo = json["photo"] as! String?
            else {
                return nil;
        }
        
        // Check if city with same id exists in database or not
        // if same city exists, return that city
        let fetchRequest : NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(City.id)) == \(id)")
        
        let context = citiesPersistentContainer.viewContext
        
        var existingSameCities: [City]!
        context.performAndWait {
            existingSameCities = try? fetchRequest.execute()
        }
        if let list = existingSameCities, list.count > 0, let city = list.first {
            return city
        }
        
        // otherwise, store into database and return city object
        var city: City!
        context.performAndWait {
            city = City(id: id, name: name, photo: photo, context: context)
        }
        return city
    }
    
     // This prepares House object from Json, save to database if not exist in db
    private func getHouseObj(_ json:[String:Any])->House? {
        guard
            let id = json["id"] as! Int?,
            let title = json["title"] as! String?,
            let type = json["type"] as! String?,
            let size = json["size"] as! String?,
            let address = json["address"] as! String?,
            let cityId = json["cityId"] as! Int?,
            let latitude = json["latitude"] as! Double?,
            let longitude = json["longitude"] as! Double?,
            let price = json["price"] as! Double?,
            let onSale = json["onSale"] as! Bool?,
            let onRent = json["onRent"] as! Bool?,
            let contactNo = json["contactNo"] as! String?,
            let amenities = json["amenities"] as! [NSString]?,
            let photos = json["photos"] as! [NSString]?
            else {
                return nil;
        }
        
        // Check if house with same id exists in database or not
        // if same house exists, return that house
        let fetchRequest : NSFetchRequest<House> = House.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(House.id)) == \(id)")
        
        let context = housesPersistentContainer.viewContext
        
        var existingSameHouses: [House]!
        context.performAndWait {
            existingSameHouses = try? fetchRequest.execute()
        }
        if let list = existingSameHouses, list.count > 0, let house = list.first {
            return house
        }
        
        // otherwise, store into database and return house object
        var house: House!
        context.performAndWait {
            house = House(id: id, title: title, type: type, size: size, address: address, cityId: cityId,
                          latitude: latitude, longitude: longitude, price: price, onSale: onSale, onRent: onRent,
                          contactNo: contactNo, amenities: amenities, photos: photos, context: context)
        }
        return house
    }
    
    //MARK:- get houses, apply filter and return filtered list
    func getFilteredHouses(filter: Filter, onComplete: @escaping([House])->Void){
        getHouses { (houses) -> Void in
            var finalHouses = [House]()
            if houses.count > 0 {
                finalHouses = houses.filter {
                    ( ((filter.onRent && $0.onRent) || (filter.onBuy && $0.onSale))
                        && (filter.cityId == nil || Int($0.cityId) == filter.cityId)
                        && (filter.type == nil || $0.type == filter.type)
                        && ((filter.minPrice == nil || $0.price >= filter.minPrice)
                        && (filter.maxPrice == nil || $0.price <= filter.maxPrice))
                    )
                }
            }
            onComplete(finalHouses)
        }
    }
}
