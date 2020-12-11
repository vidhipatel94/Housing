//
//  LanguageUtils.swift
//  Housing
//
//  File author: Vidhi Patel on 10/12/20.
//
//  Reference:
//  Title: iOS localization on the fly
//  Author: Fletch
//  Date: 8 December 2020
//  Availability: https://www.codebales.com/how-programmatically-change-app-language-without-restarting-app
//
//  This is used to change application language programmatically.
//  Instead of using third party library, this piece of code is used for this application.
//  There are other ways to change language but they only change strings on screen which are from Localizable.strings,
//  not from Main.strings. But this code works fine.

import Foundation

var bundleKey: UInt8 = 0

// To manage localized content
class LanguageBundle: Bundle {
    
    // This gets localized string for the key from tablename.strings file and returns that string,
    // to change text on screen.
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        // returns value associated with the app bundle for bundleKey
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
            // bundle to get resource
            let bundle = Bundle(path: path)
            else {
                // return the specific localized string for the key from table
                return super.localizedString(forKey: key, value: value, table: tableName)
        }
        
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    // static function called from dashboard/get-started screen when user change language
    class func setLanguage(_ language: String) {
        defer {
            // set class LanguageBundle to object Bundle.main that need to be modified
            object_setClass(Bundle.main, LanguageBundle.self)
        }
        // Sets an lproj path for current bundle using bundleKey and association policy OBJC_ASSOCIATION_RETAIN_NONATOMIC.
        objc_setAssociatedObject(Bundle.main, &bundleKey,
                                 Bundle.main.path(forResource: language, ofType: "lproj"),
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// To save language, and change app language on open app
class LanguageStore {
    static let instance = LanguageStore() //Singleton
    
    private init() {
        
    }
    
    func saveLanguage(lang: String) {
        UserDefaults.standard.set(lang, forKey: "language")
    }
    
    func getLanguage()->String! {
        return UserDefaults.standard.string(forKey: "language")
    }
}
