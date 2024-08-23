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


