import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "Choose the flag: \(countries[correctAnswer].uppercased()) - Score: \(score)"
    }
    
    func startNewGame(action: UIAlertAction! = nil) {
        score = 0
        count = 0
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        count += 1
        if count < 10 {
            if sender.tag == correctAnswer {
                score += 1
                let ac = UIAlertController(title: "Correct", message: "Your score is \(score)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            } else {
                score -= 1
                let ac = UIAlertController(title: "Wrong", message: "Your score is \(score), That's the flag of \(countries[sender.tag].uppercased())", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            }
        } else {
            if sender.tag != correctAnswer {
                score -= 1
                let fac = UIAlertController(title: "Game Over", message: "Wrong! Your score is \(score), That's the flag of \(countries[sender.tag].uppercased())", preferredStyle: .alert)
                fac.addAction(UIAlertAction(title: "Start New Game!", style: .default, handler: startNewGame))
                present(fac, animated: true)
            } else {
                score += 1
                let fac = UIAlertController(title: "Game Over", message: "Correct! Your score is \(score)", preferredStyle: .alert)
                fac.addAction(UIAlertAction(title: "Start New Game!", style: .default, handler: startNewGame))
                present(fac, animated: true)
            }
        }
    }
    
    @objc func showScore() {
        let alert = UIAlertController(title: "Your Score", message: "Your current score is \(score).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
