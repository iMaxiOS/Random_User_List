//
//  User.swift
//  Random-User-List
//
//  Created by iMaxiOS on 9/28/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

//MARK:- Model User
@objcMembers class UserOfRealm: Object {
    
    //MARK:- Properties user's
    dynamic var first: String = ""
    dynamic var last: String  = ""
    dynamic var email: String = ""
    dynamic var phone: String = ""
    dynamic var thumbnail: String = ""
    
    static var listUsers: Results<UserOfRealm>!
    
    override static func primaryKey() -> String? {
        return "phone"
    }
}

//MARK:- Extension
extension UserOfRealm {
    
    //Full name of user
    var fullName: String {
        return first.capitalized + " " + last.capitalized
    }
    
    static func setConfigPathOfRealm() {
        return SetConfigPathOfRealm.setConfig()
    }
    
    @discardableResult
    static func setupUserForRealm(objUser: [String: Any]) -> UserOfRealm {
        return ParseHandler.setupUser(objUser: objUser)
    }
}

//MARK:- Configuration path of Realm
class SetConfigPathOfRealm {
    
    //Path to Realm
    static func setConfig() {
        let realm = try! Realm()
        if let url = realm.configuration.fileURL {
            print("FileURL of DataBase - \(url)")
        }
    }
}

//MARK:- Parse of data
class ParseHandler {
    
    @discardableResult
    static func setupUser(objUser: [String: Any]) -> UserOfRealm {
        var user = UserOfRealm()
        let realm = try! Realm()
        try! realm.write {
            
            user = realm.create(UserOfRealm.self, value: [objUser["first"], objUser["last"], objUser["email"], objUser["phone"], objUser["thumbnail"]], update: true)
        }
        return user
    }
}

//MARK:- Methods Realm
extension UserOfRealm {
    
    //All users of Realm
    @discardableResult
    func allUsers() -> [UserOfRealm] {
        let realm = try! Realm()
        UserOfRealm.listUsers = realm.objects(UserOfRealm.self)
        return Array(UserOfRealm.listUsers)
    }
    
    //Delete all users from Realm
    func delAllUsers() {
        let realm = try! Realm()
        let allUsers = realm.objects(UserOfRealm.self)
        try! realm.write {
            realm.delete(allUsers)
        }
    }
}
