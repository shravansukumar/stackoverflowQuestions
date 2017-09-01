//
//  SearchStackoverflowServices.swift
//  searchStackoverflow
//
//  Created by Shravan Sukumar on 30/08/17.
//  Copyright © 2017 shravan. All rights reserved.
//

import Foundation
import Alamofire

typealias response = (Bool, [[String : Any]]?) -> ()

public final class SearchStackoverflowServices {
    
    let manager = Alamofire.SessionManager.default
    
    func searchQuestions( _ url: String, responseResult: @escaping response) {
        
        let searchURL = URL(string: url)
        
        manager.request(searchURL!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            if let error = response.result.error {
                print(error.localizedDescription)
                return responseResult(false, nil)
            } else {
                if let result = response.result.value as? [String : Any], let item = result["items"] as? [[String : Any]] {
                    return responseResult(true, item)
                }
            }
        }
    }
    
    func getAnswers(_ url: String, responseResult: @escaping response) {
       let answerURL = URL(string: url)
        manager.request(answerURL!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            if let error = response.result.error {
                print(error.localizedDescription)
                return responseResult(false, nil)
            } else {
                if let result = response.result.value as? [String : Any], let item = result["items"] as? [[String : Any]] {
                    print(item)
                    return responseResult(true, item)
                }
            }
        }
    }
}
