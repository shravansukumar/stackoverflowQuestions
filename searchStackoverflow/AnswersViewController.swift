//
//  AnswersViewController.swift
//  searchStackoverflow
//
//  Created by Shravan Sukumar on 01/09/17.
//  Copyright © 2017 shravan. All rights reserved.
//

import UIKit
import RealmSwift

class AnswersViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Constants and Variables
    var question: Question!
    var answers = [Answer]()
    let realm = try! Realm()
    let cellIdentifier = "questionsTableViewCell"
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        retreiveAnswers()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight =  UITableViewAutomaticDimension
        
        // Register cells
        let nib = UINib(nibName: "QuestionsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func retreiveAnswers() {
        let answers = realm.objects(Answer.self).filter("questionId == %@", question.questionId)
        print(answers)
        self.answers = Array(answers)
        tableView.reloadData()
    }
}

extension AnswersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if answers.count > 0 {
            tableView.separatorStyle = .singleLine
            return answers.count
        } else {
            tableView.separatorStyle = .none
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! QuestionsTableViewCell
        let answer = answers[indexPath.row]
        cell.authorLabel.text = "Author: " + (answer.user?.name)!
        cell.votesLabel.text = "Score: " + "\(answer.score)"
        cell.titleTextView.text = answer.body
        return cell
    }
}

extension AnswersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


