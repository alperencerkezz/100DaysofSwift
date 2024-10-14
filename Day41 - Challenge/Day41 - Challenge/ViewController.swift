//
//  ViewController.swift
//  Day41 - Challenge
//
//  Created by Alperen Çerkez on 13.10.2024.
//

import UIKit

class ViewController: UIViewController {

    var allWords = ["RHYTHM", "DEVELOPER", "SWIFT", "HANGMAN", "ALPEREN", "OOP"]
    var currentWord = ""
    var usedLetters = [String]()
    var promptWord = ""
    var wrongAnswers = 0 {
        didSet {
            title = "Attempts left: \(7 - wrongAnswers)"
        }
    }

    let wordLabel = UILabel()
    let guessTextField = UITextField()
    let submitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startNewGame()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        wordLabel.font = UIFont.systemFont(ofSize: 36)
        wordLabel.textAlignment = .center
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wordLabel)
        
        guessTextField.placeholder = "Enter a letter"
        guessTextField.textAlignment = .center
        guessTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guessTextField)
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.blue, for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 80),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            guessTextField.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            guessTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submitButton.topAnchor.constraint(equalTo: guessTextField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func startNewGame() {
        currentWord = allWords.randomElement() ?? "SWIFT"
        usedLetters.removeAll()
        wrongAnswers = 0
        promptWord = String(repeating: "?", count: currentWord.count)
        wordLabel.text = promptWord
        title = "Attempts left: 7"
    }
    
    @objc func submitTapped() {
        guard let guess = guessTextField.text?.uppercased(), guess.count == 1 else { return }
        
        guessTextField.text = ""
        
        if usedLetters.contains(guess) {
            return
        }
        
        usedLetters.append(guess)
        
        if currentWord.contains(guess) {
            updatePromptWord(with: guess)
        } else {
            wrongAnswers += 1
        }
        
        checkGameStatus()
    }
    
    func updatePromptWord(with letter: String) {
        var newPrompt = ""
        
        for char in currentWord {
            let strChar = String(char)
            if usedLetters.contains(strChar) {
                newPrompt += strChar
            } else {
                newPrompt += "?"
            }
        }
        
        promptWord = newPrompt
        wordLabel.text = promptWord
    }
    
    func checkGameStatus() {
        if promptWord == currentWord {
            let ac = UIAlertController(title: "You Win!", message: "You guessed the word!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
                self.startNewGame()
            }))
            present(ac, animated: true)
        } else if wrongAnswers == 7 {
            let ac = UIAlertController(title: "You Lose!", message: "The word was \(currentWord).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
                self.startNewGame()
            }))
            present(ac, animated: true)
        }
    }
}
