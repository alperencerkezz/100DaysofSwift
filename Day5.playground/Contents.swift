import UIKit


func printHelp() {
    let message = """
Welcome to MyApp!

Run this app inside a directory of images and
MyApp will resize them all into thumbnails
"""
    print(message)
}

printHelp()

func square(number: Int) {
    print(number * number)
}

square(number: 8)

func count(to: Int) {
    for i in 1...to {
        print("I'm counting: \(i)")
    }
}

func format(number: Int) {
    print("The number is \(number).")
}
format(number: 32)

func makeBand(names: [String]) {
    print("Let's start a band...")
    for name in names {
        print("\(name) wants to join!")
    }
}
makeBand(names: ["John", "Paul"])

func square2(number: Int) -> Int {
    return number * number
}
let result = square2(number: 8)
print(result)

func greet(_ person: String, nicely: Bool = true) {
    if nicely == true {
        print("Hello, \(person)!")
    } else {
        print("Oh no, it's \(person) again...")
    }
}
greet("Alperen")
greet("Taylor", nicely: false)

enum CatProblems: Error {
    case notACat
    case unfriendly
}
func strokeCat(_ name: String) throws {
    if name == "Mr Bitey" {
        throw CatProblems.unfriendly
    } else if name == "Lassie" {
        throw CatProblems.notACat
    } else {
        print("You stroked \(name).")
    }
}

func doubleInPlace(number: inout Int) {
    number *= 2
}
var myNum = 10
doubleInPlace(number: &myNum)
print("Number is: ", myNum)
