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
    let networkManager = SearchStackoverflowServices()
    var questions = [Question]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight =  UITableViewAutomaticDimension
        
        // Register cells
        let nib = UINib(nibName: "QuestionsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "questionsTableViewCell")
    }
    
    
    private func buildURLForSearching() -> String {
        let searchString = QuestionsURL.baseURL + QuestionsURL.search + QuestionsURL.site + QuestionsURL.filter + QuestionsURL.title
        return searchString
    }
    
    func buildURLForAnswersWith(id: Int) -> String {
        let answersURL = QuestionsURL.baseURL + QuestionsURL.questions + "\(id)" + QuestionsURL.answers + QuestionsURL.order + "&" + QuestionsURL.site + QuestionsURL.filter
        print(answersURL)
        return answersURL
    }
    
    private func retreiveQuestions() -> [Question] {
        let questions = realm.objects(Question.self)
        return Array(questions)
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
                self.questions = self.retreiveQuestions()
                self.tableView.reloadData()
            } else  {
                print("Not able to store items")
            }
        }
    }
    
    fileprivate func storeAnswersFor(id: Int) {
        let urlString = buildURLForAnswersWith(id: id)
        networkManager.getAnswers(urlString) {
            success, result in
            if success == true {
                
            } else {
                
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchQuestionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questions.count > 0 {
            tableView.separatorStyle = .singleLine
            return questions.count
        } else {
            tableView.separatorStyle = .none
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionsTableViewCell") as! QuestionsTableViewCell        
        let question = questions[indexPath.row]
        cell.votesLabel.text = "Score: " + String(question.score)
        cell.authorLabel.text = "Author: " + (question.user?.name)!
        cell.titleTextView.text = question.title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchQuestionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = questions[indexPath.row]
        if question.answerCount > 0 {
            storeAnswersFor(id: question.questionId)
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchQuestionsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchtext = searchBar.text
        storeQuestionsFor(searchtext)
        searchBar.resignFirstResponder()
    }
}
