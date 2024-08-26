import UIKit

let driving = {
    print("I'm driving in my car")
}

driving()


let drivingWithReturn = { (place: String) -> String in
    return "I'm going to \(place) in my car"
}
let message = drivingWithReturn("Istanbul")
print(message)
