
let days = 100 - 3
print("There are \(days) days until the SwiftUI.")

let number = 465
let isMultiple = number.isMultiple(of: 7)

let firstHalf = ["John", "Paul"]
let secondHalf = ["George", "Ringo"]
let beatles = firstHalf + secondHalf

var score = 95
score -= 5

//Basic blackjack

let firstCard = 11
let secondCard = 10

if firstCard + secondCard == 2 {
    print("Aces!")
} else if firstCard + secondCard == 21 {
    print("Blackjack!")
} else {
    print("Regular cards")
}

let age1 = 17
let age2 = 20

if age1 > 18 && age2 > 18 {
    print("Both of them are over 18")
}

if age1 > 18 || age2 > 18 {
    print("At least one of them is over 18")
}


let weather = "sunny"

switch weather {
case "rain":
    print("Bring an umbrella")
case "snow":
    print("Wrap up warm")
case "sunny":
    print("Wear sunscreen")
    fallthrough
default:
    print("Enjoy your day!")
}

let score2 = 85

switch score {
case 0..<50:
    print("You failed badly.")
case 50..<85:
    print("You did OK.")
default:
    print("You did great!")
}
