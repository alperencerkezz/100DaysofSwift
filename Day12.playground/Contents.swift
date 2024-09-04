import UIKit

var age: Int? = nil

age = 75

struct Person {
    var id: String

    init?(id: String) {
        if id.count == 9 {
            self.id = id
        } else {
            return nil
        }
    }
}
class Animal { }
class Fish: Animal { }

class Dog: Animal {
    func makeNoise() {
        print("Woof!")
    }
}

let pets = [Fish(), Dog(), Fish(), Dog()]
for pet in pets {
    if let dog = pet as? Dog {
        dog.makeNoise()
    }
}

func process(order: String) {
    print("OK, I'll get your \(order).")
}
let pizzaRequest: String! = "pizza"
process(order: pizzaRequest)
