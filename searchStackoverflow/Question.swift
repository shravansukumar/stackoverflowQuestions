//
//  Question.swift
//  searchStackoverflow
//
//  Created by Shravan Sukumar on 30/08/17.
//  Copyright © 2017 shravan. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Question: Object, Mappable {
    
    dynamic var questionId: Int = 0
    dynamic var title: String = ""
    dynamic var body: String = ""
    dynamic var isAnswered: Bool = false
    dynamic var viewCount: Int = 0
    dynamic var answerCount: Int = 0
    dynamic var user: User? = nil
    
    
    override static func primaryKey() -> String? {
        return "questionId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        questionId <- map["question_id"]
        title <- map["title"]
        body <- map["body"]
        isAnswered <- map["is_answered"]
        viewCount <- map["view_count"]
        answerCount <- map["answer_count"]
        user <- map["owner"]
    }
}
