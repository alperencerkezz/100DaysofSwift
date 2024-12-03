//
//  ViewController.swift
//  Project5
//
//  Created by Alperen Çerkez on 21.09.2024.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]() {
        didSet {
            
            UserDefaults.standard.set(usedWords, forKey: "usedWords")
        }
    }
    
    var currentWord: String? {
        didSet {
          
            UserDefaults.standard.set(currentWord, forKey: "currentWord")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Word", style: .plain, target: self, action: #selector(startGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        loadGame()
        startGame()
    }
    
    func loadGame() {
        
        if let savedWords = UserDefaults.standard.array(forKey: "usedWords") as? [String] {
            usedWords = savedWords
        }
        currentWord = UserDefaults.standard.string(forKey: "currentWord")
        
        
        if let startsWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startsWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            allWords = ["silkworm"]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func startGame() {
        currentWord = allWords.randomElement()
        title = currentWord
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] action in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = currentWord!.lowercased()
        
        for letter in word {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains { $0.lowercased() == word.lowercased() }
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isLongEnough(word: String) -> Bool {
        return word.count >= 3
    }
    
    func isNotStartWord(word: String) -> Bool {
        return word.lowercased() != currentWord?.lowercased()
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
        
    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()
        
        var errorTitle: String
        var errorMessage: String
        
        if isNotStartWord(word: lowerAnswer) {
            if isLongEnough(word: lowerAnswer) {
                if isPossible(word: lowerAnswer) {
                    if isOriginal(word: lowerAnswer) {
                        if isReal(word: lowerAnswer) {
                            // Everything is correct, so we can add the word
                            usedWords.insert(answer, at: 0)
                            
                            let indexPath = IndexPath(row: 0, section: 0)
                            tableView.insertRows(at: [indexPath], with: .automatic)
                            
                            return
                        } else {
                            errorTitle = "Word not recognized"
                            errorMessage = "You can't just make them up, you know!"
                        }
                    } else {
                        errorTitle = "Word used already"
                        errorMessage = "Be more original!"
                    }
                } else {
                    errorTitle = "Word not possible"
                    errorMessage = "You can't spell that word from '\(currentWord!.lowercased())'!"
                }
            } else {
                errorTitle = "Word too short"
                errorMessage = "Your word must be at least three letters long."
            }
        } else {
            errorTitle = "Start word"
            errorMessage = "You can't use the start word as your answer!"
        }
        
        showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
    }
}
