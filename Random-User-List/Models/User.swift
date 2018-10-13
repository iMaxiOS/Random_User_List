//
//  User.swift
//  Random-User-List
//
//  Created by iMaxiOS on 10/9/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    
    //MARK:- Properties
    var first: String = ""
    var last: String  = ""
    var email: String = ""
    var phone: String = ""
    var thumbnail: String = ""
    var pageOf: Page!
    
    //MARK: Init
    init(first: String, last: String, email: String, phone: String, thumbnail: String, pageTotal: String, hasMorePage: String = "", numberOfPage: String) {
        self.first = first
        self.last = last
        self.email = email
        self.phone = phone
        self.thumbnail = thumbnail
        self.pageOf = Page(total: pageTotal, hasMore: hasMorePage, page: numberOfPage, user: self)
    }
}

class Page {
    
    //MARK:- Properties
    var total = ""
    var hasMore = ""
    var page = ""
    unowned var user: User
    
    //MARK: Init
    init(total: String, hasMore: String, page: String, user: User) {
        self.user = user
        self.total = total
        self.hasMore = hasMore
        self.page = page
    }
}

//MARK:- Extension
extension User {
    
    //Full name of user
    var fullNameOfUser: String {
        return first.capitalized + " " + last.capitalized
    }
    
    //MARK: Action
    static func setupUser(json: JSON) -> [User] {
        return ParseHandlerForUser.setupUser(json: json)
    }
}



//Parse of data
class ParseHandlerForUser {
    
    @discardableResult
    static func setupUser(json: JSON) -> [User] {
        var userContainer = [User]()
        
        let pageTotal = json["info"]["results"].stringValue
        let numberOfPage = json["info"]["page"].stringValue
        
        for  result in json["results"].arrayValue {
            let first = result["name"]["first"].stringValue
            let last = result["name"]["last"].stringValue
            let email = result["email"].stringValue
            let phone = result["phone"].stringValue
            let thumbnail = result["picture"]["thumbnail"].stringValue
            
            userContainer.append(User(first: first, last: last, email: email, phone: phone, thumbnail: thumbnail, pageTotal: pageTotal, numberOfPage: numberOfPage))
        }
        return userContainer
    }
}






