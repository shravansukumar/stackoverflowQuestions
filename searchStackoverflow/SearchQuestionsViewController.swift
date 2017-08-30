//
//  SearchQuestionsViewController.swift
//  searchStackoverflow
//
//  Created by Shravan Sukumar on 29/08/17.
//  Copyright © 2017 shravan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import RealmSwift

class SearchQuestionsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - Constants and Variables
    var searchtext: String!
    let realm = try! Realm()
    let manager = Alamofire.SessionManager.default
    let networkManager = SearchStackoverflowServices()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Private Methods
    private func buildURLForSearching() -> String {
        let searchString = QuestionsURL.baseURL + QuestionsURL.search + QuestionsURL.site + QuestionsURL.filter + QuestionsURL.title
        return searchString
    }
    
    // MARK: - File Private Methods
    fileprivate func storeQuestionsFor(_ phrase: String) {
        let phraseString = buildURLForSearching() + phrase.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        networkManager.searchQuestions(phraseString) {
            success, result in
            if success == true {
                let questionItems = Mapper<Question>().mapSet(JSONArray: result!)
                for item in questionItems {
                    try! self.realm.write {
                        self.realm.add(item, update: true)
                    }
                }
                print(self.realm.objects(Question.self))
            } else  {
                print("Not able to store items")
            }
            
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchQuestionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "Hello"
        return cell!
    }
}

// MARK: - UITableViewDelegate
extension SearchQuestionsViewController: UITableViewDelegate {
    
}

// MARK: - UISearchBarDelegate
extension SearchQuestionsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchtext = searchBar.text
        storeQuestionsFor(searchtext)
        searchBar.resignFirstResponder()
    }
}








