//
//  QuestionsURL.swift
//  searchStackoverflow
//
//  Created by Shravan Sukumar on 30/08/17.
//  Copyright © 2017 shravan. All rights reserved.
//

import Foundation


struct QuestionsURL {
    static let baseURL = "https://api.stackexchange.com/2.2/"
    static let search = "search?"
    static let site =  "site=stackoverflow"
    static let filter = "&filter=withbody"
    static let title = "&intitle="
    
    static let answers = "/answers?"
    static let questions = "questions/"
    static let order = "order=desc"
}
