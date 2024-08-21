import UIKit

let count = 1...10

for number in count {
    print("Number is \(number)")
}

let albums = ["Red", "1989", "Reputation"]

for album in albums {
    print("\(album) is on Apple Music" )
}

/*
var number = 1

while number <= 20 {
    print(number)
    number += 1
}
*/
 
print("All numbers have been counted!")

var number2: Int = 10
while number2 > 0 {
    number2 -= 2
    if number2.isMultiple(of: 2) {
        print("\(number2) is an even number.")
    }
}

var speed = 50
while speed <= 55 {
    print("Accelerating to \(speed)")
    speed += 1
}

var number = 1

repeat {
    print(number)
    number += 1
} while number <= 20

print("Ready or not, here I come!")

for i in 1...10 {
    if i % 2 == 1 {
        continue
    }

    print(i)
}

var hoursStudied = 0
var goal = 10
repeat {
    hoursStudied += 1
    if hoursStudied > 4 {
        goal -= 1
        continue
    }
    print("I've studied for \(hoursStudied) hours")
} while hoursStudied < goal
 
for i in 1...5 {
    if i == 5 {
        continue
    }
    let sum = i + i
    print("\(i) + \(i) is \(sum).")
}

var isAlive = false

while isAlive == true {
    print("I'm alive!")
}

print("I've snuffed it!")
