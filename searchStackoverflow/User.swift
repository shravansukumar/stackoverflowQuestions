//
//  User.swift
//  searchStackoverflow
//
//  Created by Shravan Sukumar on 31/08/17.
//  Copyright © 2017 shravan. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class User: Object, Mappable {
    dynamic var userId: Int = 0
    dynamic var userType: String = ""
    dynamic var acceptRate: Int = 0
    dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        userId <- map["user_id"]
        userType <- map["user_type"]
        acceptRate <- map["accept_rate"]
        name <- map["display_name"]
    }
    
}
