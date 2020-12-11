//
//  UserStore.swift
//  Housing
//
//  Created by Shravani Gandla on 9/12/20.
//  Copyright © 2020 Conestoga. All rights reserved.
//

import Foundation

class UserStore {
    
    static let instance = UserStore() //Singleton
    
    private init() {
        
    }
    
    func saveUser(user: User) {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode User
            let data = try encoder.encode(user)

            // Write/Set User
            UserDefaults.standard.set(data, forKey: "user")

        } catch {
            print("Error : Unable to Encode (\(error))")
        }
    }
    
    func getUser()->User! {
        if let data = UserDefaults.standard.data(forKey: "user") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode User
                let user = try decoder.decode(User.self, from: data)
                return user

            } catch {
                print("Error: Unable to Decode (\(error))")
            }
        }
        return nil
    }
}
