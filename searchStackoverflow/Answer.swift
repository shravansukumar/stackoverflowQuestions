//
//  Answer.swift
//  searchStackoverflow
//
//  Created by Shravan Sukumar on 01/09/17.
//  Copyright © 2017 shravan. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Answer: Object, Mappable {
   
    dynamic var questionId: Int = 0
    dynamic var answerId: Int = 0
    dynamic var body: String = ""
    dynamic var isAccepted: Bool = false
    dynamic var viewCount: Int = 0
    dynamic var score: Int = 0
    dynamic var user: User? = nil

    
    override static func primaryKey() -> String? {
        return "answerId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
     func mapping(map: Map) {
        answerId <- map["answer_id"]
        questionId <- map["question_id"]
        body <- map["body"]
        viewCount <- map["view_count"]
        score <- map["score"]
        user <- map["owner"]
    }
}
